# Configuración y funciones compartidas por los scripts del proyecto MCC.
# Se carga con: . "$PSScriptRoot/comun.ps1"

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$TexBins = @{
    TeXLive = 'C:\msys64\ucrt64\bin'
    MiKTeX  = 'D:\miktex\miktex\bin\x64'
}
$MsysBin = 'C:\msys64\usr\bin'      # pandoc, git de MSYS2
$NodeExe = 'C:\msys64\ucrt64\bin\node.exe'
$MathJax = 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js'
$Css = 'tema-1.css'
$PandocCommon = @('--from=markdown+tex_math_dollars', '--standalone', '--metadata=lang:es')
$PandocTex = $PandocCommon + @('--to=latex', '--include-in-header=latex/pandoc-pdf-header.tex')
$BasePath = $env:PATH

$Problems = New-Object System.Collections.Generic.List[string]
function Add-Problem([string]$msg) { $Problems.Add($msg); Write-Host "  PROBLEMA: $msg" -ForegroundColor Red }

function Invoke-Tool {
    # Ejecuta un programa, devuelve su salida combinada y registra fallo si el código de salida no es 0.
    param([string]$Label, [string]$Exe, [string[]]$Arguments)
    $out = & $Exe @Arguments 2>&1 | ForEach-Object { "$_" }
    if ($LASTEXITCODE -ne 0) {
        Add-Problem "$Label terminó con código $LASTEXITCODE"
        $out | Select-Object -Last 30 | ForEach-Object { Write-Host "    $_" }
    }
    return , $out
}

function Test-PandocWarnings([string]$Label, [string[]]$Output) {
    foreach ($line in $Output) {
        if ($line -match '\[WARNING\]|Warning|Error') { Add-Problem "${Label}: $line" }
    }
}

function Test-LatexLog([string]$Label, [string]$LogPath) {
    if (-not (Test-Path $LogPath)) { Add-Problem "${Label}: no existe el log $LogPath"; return }
    $log = Get-Content $LogPath -Raw -Encoding utf8
    $patterns = @(
        '(?m)^! .*',                              # errores
        '(?m)^.*(LaTeX|Package|Class) [^\n]*Warning[^\n]*',
        '(?m)^(Overfull|Underfull) \\[hv]box[^\n]*',
        '(?m)^Missing character[^\n]*'
    )
    foreach ($p in $patterns) {
        foreach ($m in [regex]::Matches($log, $p)) { Add-Problem "${Label}: $($m.Value.Trim())" }
    }
}

function Get-Distros([string]$TeX) {
    $distros = @(if ($TeX -eq 'Both') { 'TeXLive', 'MiKTeX' } else { $TeX })
    foreach ($d in $distros) {
        if (-not (Test-Path (Join-Path $TexBins[$d] 'pdflatex.exe'))) { throw "No se encuentra pdflatex de $d en $($TexBins[$d])" }
    }
    return , $distros
}

function Use-TeX([string]$Distro) {
    # Pone delante en el PATH la distribución LaTeX indicada (latexmk necesita su Perl) y Pandoc.
    $env:PATH = if ($Distro) { "$($TexBins[$Distro]);$MsysBin;$BasePath" } else { "$MsysBin;$BasePath" }
}

function Invoke-LatexCompile([string]$TexFile, [string]$Distro, [string]$OutDir) {
    # Compila un .tex con latexmk + pdflatex en $OutDir y revisa su log. Devuelve la ruta del PDF.
    $n = [IO.Path]::GetFileNameWithoutExtension($TexFile)
    New-Item -ItemType Directory -Force $OutDir | Out-Null
    Use-TeX $Distro
    Write-Host "-- latexmk ($Distro): $TexFile"
    $null = Invoke-Tool "latexmk ($Distro)" 'latexmk' @('-pdf', '-interaction=nonstopmode', '-halt-on-error', '-file-line-error', "-outdir=$OutDir", $TexFile)
    Test-LatexLog "LaTeX ($Distro)" "$OutDir/$n.log"
    return "$OutDir/$n.pdf"
}

function Get-DocNames([string[]]$Name) {
    return , @(if ($Name) { $Name } else { Get-ChildItem markdown -Filter *.md | ForEach-Object BaseName })
}

function Exit-WithSummary {
    $env:PATH = $BasePath
    if ($Problems.Count) {
        Write-Host "`n$($Problems.Count) problema(s). La compilación NO es válida." -ForegroundColor Red
        exit 1
    }
    Write-Host "`nTodo correcto: sin errores ni advertencias." -ForegroundColor Green
    exit 0
}

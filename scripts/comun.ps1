# Configuración y funciones compartidas por los scripts del proyecto MCC.
# Se carga con: . "$PSScriptRoot/comun.ps1"
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '',
    Justification = 'Las variables las usan los scripts que cargan este archivo.')]
param()

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$TexBins = @{
    TeXLive = 'C:\msys64\ucrt64\bin'
    MiKTeX  = 'D:\miktex\miktex\bin\x64'
}
$MsysBin = 'C:\msys64\usr\bin'      # pandoc, git de MSYS2
$NodeExe = 'C:\msys64\ucrt64\bin\node.exe'
# SageMath en WSL (REGLAS.md 7.5): distribución y entorno conda que crea scripts/prepara-sage.ps1.
$SageDistro = 'Ubuntu'
$SageEnv = '$HOME/miniforge3/envs/sage'
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

function ConvertTo-WslPath([string]$Path) {
    # Ruta de Windows -> ruta en la distribución WSL de Sage (C:\a\b -> /mnt/c/a/b).
    $p = (& wsl.exe -d $SageDistro --exec wslpath -a ($Path -replace '\\', '/')) | Select-Object -First 1
    if ($LASTEXITCODE -ne 0 -or -not $p) { throw "wslpath no pudo convertir $Path" }
    return $p.Trim()
}

function Test-PandocWarnings([string]$Label, [string[]]$Output) {
    foreach ($line in $Output) {
        if ($line -match '\[WARNING\]|Warning|Error') { Add-Problem "${Label}: $line" }
    }
}

function Test-LatexLog([string]$Label, [string]$LogPath, [string[]]$Permitidas = @()) {
    # $Permitidas: expresiones regulares de advertencias que se toleran (solo las que
    # provienen de un modelo externo que no se puede modificar; REGLAS.md 8.4).
    if (-not (Test-Path $LogPath)) { Add-Problem "${Label}: no existe el log $LogPath"; return }
    $log = Get-Content $LogPath -Raw -Encoding utf8
    $patterns = @(
        '(?m)^! .*',                              # errores
        '(?m)^.*(LaTeX|Package|Class) [^\n]*Warning[^\n]*',
        '(?m)^(Overfull|Underfull) \\[hv]box[^\n]*',
        '(?m)^Missing character[^\n]*'
    )
    foreach ($p in $patterns) {
        foreach ($m in [regex]::Matches($log, $p)) {
            $texto = $m.Value.Trim()
            if ($Permitidas | Where-Object { $texto -match $_ }) { continue }
            Add-Problem "${Label}: $texto"
        }
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

function Set-SourceDate([string]$MdFile) {
    # PDFs reproducibles: pdfTeX usa SOURCE_DATE_EPOCH como fecha de creación del PDF (y con
    # FORCE_SOURCE_DATE=1 también para \today). Se toma la fecha de modificación del Markdown,
    # de modo que sin cambios en el contenido el PDF sale idéntico byte a byte (el /ID del
    # PDF se suprime con \pdftrailerid{} en latex/pandoc-pdf-header.tex).
    $env:SOURCE_DATE_EPOCH = [string][DateTimeOffset]::new((Get-Item $MdFile).LastWriteTimeUtc).ToUnixTimeSeconds()
    $env:FORCE_SOURCE_DATE = '1'
}

function Invoke-LatexCompile([string]$TexFile, [string]$Distro, [string]$OutDir, [string[]]$Permitidas = @()) {
    # Compila un .tex con latexmk + pdflatex en $OutDir y revisa su log. Devuelve la ruta del PDF.
    $n = [IO.Path]::GetFileNameWithoutExtension($TexFile)
    New-Item -ItemType Directory -Force $OutDir | Out-Null
    Use-TeX $Distro
    Write-Host "-- latexmk ($Distro): $TexFile"
    $null = Invoke-Tool "latexmk ($Distro)" 'latexmk' @('-pdf', '-interaction=nonstopmode', '-halt-on-error', '-file-line-error', "-outdir=$OutDir", $TexFile)
    Test-LatexLog "LaTeX ($Distro)" "$OutDir/$n.log" $Permitidas
    return "$OutDir/$n.pdf"
}

function Update-IndiceWeb {
    # Genera html/index.html: portada de la web con todos los documentos, agrupados por
    # asignatura, con enlaces a su HTML y a su PDF (doc_out/latex/).
    $docs = foreach ($md in Get-ChildItem markdown -Filter *.md) {
        $text = [IO.File]::ReadAllText($md.FullName)
        [pscustomobject]@{
            Nombre     = $md.BaseName
            Titulo     = if ($text -match '(?m)^# (.+)$') { $Matches[1].Trim() } else { $md.BaseName }
            Asignatura = if ($text -match '(?m)^\* \*\*Asignatura:\*\* ([^(\r\n]+)') { $Matches[1].Trim() } else { 'Otros documentos' }
            Fecha      = if ($text -match '(?m)^\* \*\*Última edición:\*\* (\S+)') { $Matches[1] } else { '' }
        }
    }
    $lineas = @(
        '---', 'author: "Julián Calderón Almendros"', '---', '',
        '# MCC: apuntes del Máster en Computación Cuántica', '',
        'Apuntes de autoestudio de Julián Calderón Almendros ([\@julian1c2a](https://github.com/julian1c2a)). Fuentes en <https://github.com/julian1c2a/MCC>. Licencia [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.es).', ''
    )
    foreach ($grupo in ($docs | Sort-Object Asignatura, Nombre | Group-Object Asignatura)) {
        $lineas += "## $($grupo.Name)", ''
        foreach ($d in $grupo.Group) {
            $lineas += "* **$($d.Titulo)** ([web]($($d.Nombre).html), [PDF](../doc_out/latex/$($d.Nombre).pdf))$(if ($d.Fecha) { ". Última edición: $($d.Fecha)." })"
        }
        $lineas += ''
    }
    New-Item -ItemType Directory -Force 'build/web' | Out-Null
    [IO.File]::WriteAllText((Join-Path $Root 'build/web/index.md'), ($lineas -join "`n"), [Text.UTF8Encoding]::new($false))
    Use-TeX
    Write-Host '-- Pandoc: portada web -> html/index.html'
    $out = Invoke-Tool 'pandoc (índice web)' 'pandoc' ($PandocCommon + @('--to=html5', '--metadata=pagetitle:MCC', "--css=$Css", '--output=html/index.html', 'build/web/index.md'))
    Test-PandocWarnings 'pandoc (índice web)' $out
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

<#
.SYNOPSIS
  ESTADO: resumen del estado del proyecto (git, sincronización, notas para la IA, borrador).
  Solo lee; no modifica nada.

.PARAMETER Fetch
  Consulta antes origin (git fetch) para saber si main está por delante o por detrás.
#>
[CmdletBinding()]
param([switch]$Fetch)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$gitWindows = 'C:\Program Files\Git\cmd'
if (Test-Path "$gitWindows\git.exe") { $env:PATH = "$gitWindows;$env:PATH" }
$env:GIT_TERMINAL_PROMPT = '0'

function Titulo([string]$t) { Write-Host "`n== $t" -ForegroundColor Cyan }

# Git
Titulo 'Git'
if ($Fetch) { git fetch -q origin 2>$null }
$rama = git branch --show-current
Write-Host "Rama actual: $rama$(if ($rama -eq 'edicion-actual') { '  (trabajo en curso que aún no ha pasado la validación)' })"
$sb = (git status -sb | Select-Object -First 1)
if ($sb -match '\[(.+)\]') { Write-Host "Respecto a origin: $($Matches[1])$(if (-not $Fetch) { ' (según la última consulta; usa -Fetch para actualizar)' })" }
else { Write-Host "Respecto a origin: al día$(if (-not $Fetch) { ' (según la última consulta; usa -Fetch para actualizar)' })" }
Write-Host "Último commit: $(git log -1 --format='%h %s (%cr)')"
$cambios = @(git status --porcelain)
if ($cambios) {
    Write-Host "Cambios sin guardar en git: $($cambios.Count) archivo(s)"
    $cambios | Select-Object -First 15 | ForEach-Object { Write-Host "   $_" }
    if ($cambios.Count -gt 15) { Write-Host '   ...' }
} else { Write-Host 'Sin cambios pendientes de guardar.' }
git show-ref --verify --quiet refs/heads/edicion-actual
if ($LASTEXITCODE -eq 0 -and $rama -ne 'edicion-actual') {
    Write-Host 'Existe la rama edicion-actual con trabajo sin integrar.' -ForegroundColor Yellow
}

# Repositorios privados
Titulo 'Repositorios privados (material/, trabajos/)'
foreach ($d in 'material', 'trabajos') {
    if (-not (Test-Path "$d/.git")) { Write-Host "${d}: sin repositorio privado"; continue }
    Push-Location $d
    $n = @(git status --porcelain).Count
    $pos = if ((git status -sb | Select-Object -First 1) -match '\[(.+)\]') { $Matches[1] } else { 'al día' }
    Write-Host ("{0,-9} {1} cambio(s) sin guardar; respecto a GitHub: {2}" -f "${d}:", $n, $pos)
    Pop-Location
}

# Sincronización
Titulo 'Sincronización de documentos'
foreach ($md in Get-ChildItem markdown -Filter *.md) {
    $n = $md.BaseName
    $estado = @()
    $tex = Get-Item "latex/$n.tex" -ErrorAction SilentlyContinue
    $html = Get-Item "html/$n.html" -ErrorAction SilentlyContinue
    $pdfs = @("doc_out/latex/$n.pdf", "doc_out/markdown/$n.pdf") | ForEach-Object { Get-Item $_ -ErrorAction SilentlyContinue }
    if (Test-Path "build/sync/$n.manual.tex") { $estado += 'SINCRONIZA_desde_TEX a medias (falta la fase Verificar)' }
    if (-not $tex -or -not $html -or ($pdfs.Count -lt 2)) { $estado += 'faltan derivados: SINCRONIZA' }
    else {
        if ($tex.LastWriteTimeUtc -gt $md.LastWriteTimeUtc) { $estado += '.tex editado a mano: SINCRONIZA (desde TEX)' }
        elseif ($tex.LastWriteTimeUtc -lt $md.LastWriteTimeUtc) { $estado += 'Markdown modificado: SINCRONIZA (desde MD)' }
        if ($html.LastWriteTimeUtc -gt $md.LastWriteTimeUtc) { $estado += '.html editado a mano (se perderá al sincronizar)' }
        if ($pdfs | Where-Object { $_.LastWriteTimeUtc -lt $md.LastWriteTimeUtc }) { $estado += 'PDF desactualizado' }
    }
    $texto = if ($estado) { $estado -join '; ' } else { 'sincronizado' }
    $color = if ($estado) { 'Yellow' } else { 'Green' }
    Write-Host ("{0,-40} {1}" -f $n, $texto) -ForegroundColor $color
}

# Notas para la IA
Titulo 'Notas para la IA pendientes'
& "$PSScriptRoot/notas.ps1"

# Borrador
Titulo 'Borrador'
if (Test-Path BORRADOR.md) {
    $contenido = [IO.File]::ReadAllText((Resolve-Path BORRADOR.md))
    $util = ($contenido -replace '(?s)<!--.*?-->', '' -split "`n" | Where-Object { $_.Trim() -and $_ -notmatch '^\s*Destino:' })
    if ($util) { Write-Host "BORRADOR.md tiene $(@($util).Count) línea(s) de contenido: listo para REPASA_BORRADOR." }
    else { Write-Host 'BORRADOR.md está vacío.' }
} else { Write-Host 'No existe BORRADOR.md.' }

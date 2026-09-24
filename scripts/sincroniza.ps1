<#
.SYNOPSIS
  SINCRONIZA: elige la dirección de sincronización según qué archivo ha cambiado por último.

.DESCRIPTION
  Para cada documento compara las fechas de modificación de markdown/<nombre>.md y
  latex/<nombre>.tex:
    - si el .tex es más reciente, se ha editado a mano: SINCRONIZA_desde_TEX, fase
      Preparar (compila el .tex y muestra los cambios que hay que portar al Markdown;
      termina con código 2 para indicar que falta ese paso);
    - en otro caso: SINCRONIZA_desde_MD.
  Si hay copias pendientes en build/sync/ (fase Preparar ya hecha y cambios ya
  portados), ejecuta la fase Verificar de SINCRONIZA_desde_TEX.
  Al final ejecuta todos los cuadernos de Python (scripts/comprueba-cuadernos.ps1).

.PARAMETER TeX
  TeXLive (por defecto), MiKTeX o Both.
#>
[CmdletBinding()]
param(
    [ValidateSet('TeXLive', 'MiKTeX', 'Both')]
    [string]$TeX = 'TeXLive'
)

. "$PSScriptRoot/comun.ps1"

$desdeTex = @(); $pendientes = @(); $desdeMd = @()
foreach ($md in Get-ChildItem markdown -Filter *.md) {
    $n = $md.BaseName
    $texPath = "latex/$n.tex"
    if (Test-Path "build/sync/$n.manual.tex") { $pendientes += $n }
    elseif ((Test-Path $texPath) -and ((Get-Item $texPath).LastWriteTimeUtc -gt $md.LastWriteTimeUtc)) { $desdeTex += $n }
    else { $desdeMd += $n }
}

$codigo = 0
function Invoke-Paso([string]$Script, [string[]]$Arguments) {
    & pwsh -NoProfile -File "$PSScriptRoot/$Script" @Arguments -TeX $TeX
    if ($LASTEXITCODE -ne 0) { $script:codigo = 1 }
}

foreach ($n in $pendientes) {
    Write-Host "== $n`: cambios del .tex ya portados -> SINCRONIZA_desde_TEX (Verificar)" -ForegroundColor Cyan
    Invoke-Paso 'sincroniza-desde-tex.ps1' @('-Fase', 'Verificar', '-Name', $n)
}
foreach ($n in $desdeMd) {
    Write-Host "== $n`: el Markdown es la versión más reciente -> SINCRONIZA_desde_MD" -ForegroundColor Cyan
    Invoke-Paso 'sincroniza-desde-md.ps1' @('-Name', $n)
}
foreach ($n in $desdeTex) {
    Write-Host "== $n`: el .tex es más reciente que el Markdown -> SINCRONIZA_desde_TEX (Preparar)" -ForegroundColor Cyan
    Invoke-Paso 'sincroniza-desde-tex.ps1' @('-Fase', 'Preparar', '-Name', $n)
    if ($codigo -eq 0) { $codigo = 2 }
}

Write-Host '== Cuadernos de Python (scripts/comprueba-cuadernos.ps1)' -ForegroundColor Cyan
& pwsh -NoProfile -File "$PSScriptRoot/comprueba-cuadernos.ps1"
if ($LASTEXITCODE -ne 0) { $codigo = 1 }

if ($codigo -eq 2) {
    Write-Host "`nFalta portar al Markdown los cambios del .tex mostrados arriba y volver a ejecutar SINCRONIZA." -ForegroundColor Yellow
}
exit $codigo

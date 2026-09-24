<#
.SYNOPSIS
  Ejecuta todos los cuadernos de cuadernos/ (salvo mcc_sym.py) y falla si alguno termina con
  error, con una comprobación fallida o con cualquier advertencia de Python.

.DESCRIPTION
  Cada cuaderno se ejecuta de principio a fin con el Python de .venv, sin ventana
  interactiva: PYTHONPATH=cuadernos (para importar mcc_sym), MPLBACKEND=Agg (los gráficos no
  se muestran) y -W error (las advertencias cuentan como errores). Lo llaman SINCRONIZA y,
  a través de él, GUARDA_y_SUBE.

.PARAMETER Cuaderno
  Ruta de uno o varios cuadernos concretos. Por defecto, todos.
#>
[CmdletBinding()]
param([string[]]$Cuaderno)

. "$PSScriptRoot/comun.ps1"

$python = Join-Path $Root '.venv\Scripts\python.exe'
if (-not (Test-Path $python)) {
    Add-Problem 'no existe .venv: ejecuta pwsh scripts/prepara-python.ps1'
    Exit-WithSummary
}

$cuadernos = @(if ($Cuaderno) { $Cuaderno } else {
        Get-ChildItem cuadernos -Recurse -Filter *.py | Where-Object { $_.Name -ne 'mcc_sym.py' } |
            ForEach-Object { [IO.Path]::GetRelativePath($Root, $_.FullName) }
    })
if (-not $cuadernos) { Write-Host 'No hay cuadernos.'; exit 0 }

$env:PYTHONPATH = Join-Path $Root 'cuadernos'
$env:MPLBACKEND = 'Agg'
$env:PYTHONIOENCODING = 'utf-8'
foreach ($c in $cuadernos) {
    Write-Host "-- Cuaderno: $c"
    $out = & $python -W error $c 2>&1 | ForEach-Object { "$_" }
    if ($LASTEXITCODE -ne 0) {
        Add-Problem "$c terminó con error"
        $out | Select-Object -Last 15 | ForEach-Object { Write-Host "    $_" }
    } else {
        $n = @($out | Where-Object { $_ -like '✓*' }).Count
        Write-Host "   $n comprobaciones correctas"
    }
}

Exit-WithSummary

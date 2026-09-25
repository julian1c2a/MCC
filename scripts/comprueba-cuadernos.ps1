<#
.SYNOPSIS
  Ejecuta todos los cuadernos de cuadernos/ (salvo mcc_sym.py) y falla si alguno termina con
  error, con una comprobación fallida o con cualquier advertencia de Python.

.DESCRIPTION
  Cada cuaderno se ejecuta de principio a fin con el Python de .venv, sin ventana
  interactiva: PYTHONPATH=cuadernos (para importar mcc_sym), MPLBACKEND=Agg (los gráficos no
  se muestran) y -W error (las advertencias cuentan como errores). Los cuadernos *_sage.py se
  ejecutan igual, pero en WSL con el Python del entorno de SageMath (REGLAS.md 7.5). Lo llaman
  SINCRONIZA y, a través de él, GUARDA_y_SUBE.

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
$rootWsl = if ($cuadernos | Where-Object { $_ -like '*_sage.py' }) { ConvertTo-WslPath $Root }
foreach ($c in $cuadernos) {
    Write-Host "-- Cuaderno: $c"
    if ($c -like '*_sage.py') {
        $rel = [IO.Path]::GetRelativePath($Root, (Resolve-Path $c)) -replace '\\', '/'
        $bash = "cd '$rootWsl' && if [ ! -x $SageEnv/bin/python ]; then " +
            "echo 'No existe el entorno de Sage: ejecuta pwsh scripts/prepara-sage.ps1'; exit 1; fi && " +
            "PATH=$SageEnv/bin:`$PATH PYTHONPATH=cuadernos MPLBACKEND=Agg PYTHONIOENCODING=utf-8 $SageEnv/bin/python -W error '$rel'"
        $out = & wsl.exe -d $SageDistro --exec bash -lc $bash 2>&1 | ForEach-Object { "$_" }
    } else {
        $out = & $python -W error $c 2>&1 | ForEach-Object { "$_" }
    }
    if ($LASTEXITCODE -ne 0) {
        Add-Problem "$c terminó con error"
        $out | Select-Object -Last 15 | ForEach-Object { Write-Host "    $_" }
    } else {
        $n = @($out | Where-Object { $_ -like '✓*' }).Count
        Write-Host "   $n comprobaciones correctas"
    }
}

Exit-WithSummary

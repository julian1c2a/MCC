<#
.SYNOPSIS
  Crea (o actualiza) el entorno de Python del proyecto en .venv con uv e instala requirements.txt.

.DESCRIPTION
  El entorno lo usan los cuadernos de cuadernos/ (ventana interactiva de Jupyter en VS Code)
  y scripts/comprueba-cuadernos.ps1. .venv está ignorado por git; basta con volver a ejecutar
  este script en otra máquina.

.PARAMETER Python
  Versión de Python para uv. Por defecto, 3.14.
#>
[CmdletBinding()]
param([string]$Python = '3.14')

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)

$uv = Join-Path $env:USERPROFILE '.local\bin\uv.exe'
if (-not (Test-Path $uv)) { $uv = (Get-Command uv -ErrorAction SilentlyContinue).Source }
if (-not $uv) { throw 'No se encuentra uv. Instálalo: https://docs.astral.sh/uv/' }

if (-not (Test-Path '.venv\Scripts\python.exe')) {
    & $uv venv .venv --python $Python
    if ($LASTEXITCODE -ne 0) { throw 'uv venv falló.' }
}
& $uv pip install --python .venv\Scripts\python.exe -r requirements.txt
if ($LASTEXITCODE -ne 0) { throw 'uv pip install falló.' }
& .venv\Scripts\python.exe -c "import sympy, numpy, matplotlib, ipykernel; print('Entorno listo: sympy', sympy.__version__)"

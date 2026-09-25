<#
.SYNOPSIS
  Crea (o actualiza) en WSL el entorno de SageMath de los cuadernos *_sage.py.

.DESCRIPTION
  SageMath no funciona de forma nativa en Windows. Este script instala Miniforge en la
  distribución WSL del proyecto ($SageDistro, en comun.ps1) si no está, y crea o actualiza el
  entorno conda "sage" a partir de sage-environment.yml, y deja en ~/.maxima/maxima-init.lisp
  el ajuste que permite compilar los paquetes de Maxima (C17). Lo usan
  scripts/comprueba-cuadernos.ps1 y scripts/sage-jupyter.ps1 (REGLAS.md 7.5).
#>
[CmdletBinding()]
param()

. "$PSScriptRoot/comun.ps1"

$yml = ConvertTo-WslPath (Join-Path $Root 'sage-environment.yml')
$bash = @"
set -e
if [ ! -x ~/miniforge3/bin/mamba ]; then
  curl -fsSL -o /tmp/miniforge.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
  bash /tmp/miniforge.sh -b -p ~/miniforge3
  rm /tmp/miniforge.sh
fi
if [ -d $SageEnv ]; then
  ~/miniforge3/bin/mamba env update -y -n sage -f '$yml'
else
  ~/miniforge3/bin/mamba env create -y -f '$yml'
fi
# ECL de conda-forge compila los paquetes de Maxima (load(...), matrixexp) con un GCC que usa
# C23 por defecto, y su cabecera object.h (typedef int bool) no compila en C23: se fuerza C17.
mkdir -p ~/.maxima
grep -qs 'std=gnu17' ~/.maxima/maxima-init.lisp || cat >> ~/.maxima/maxima-init.lisp <<'EOF'
;; Paquetes de Maxima compilados por ECL: su cabecera object.h no compila en C23.
(setq c::*cc-flags* (concatenate (quote string) c::*cc-flags* " -std=gnu17"))
EOF
$SageEnv/bin/sage --version
"@
& wsl.exe -d $SageDistro --exec bash -lc ($bash -replace "`r", '')
if ($LASTEXITCODE -ne 0) { throw 'La instalación de SageMath en WSL falló.' }
Write-Host 'Entorno de SageMath listo.'

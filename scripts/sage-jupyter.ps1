<#
.SYNOPSIS
  Arranca en WSL un servidor Jupyter con el entorno de SageMath, para usar los cuadernos
  *_sage.py desde la ventana interactiva de VS Code.

.DESCRIPTION
  VS Code (en Windows) no puede usar directamente un intérprete de WSL, pero sí conectarse a
  un servidor Jupyter: WSL2 reenvía localhost. El servidor arranca en cuadernos/ (así
  "from mcc_sym import *" funciona) y escucha solo en localhost, con un token fijo que se
  guarda en ~/.mcc-sage-token dentro de WSL para que VS Code recuerde la conexión.

  En VS Code: selector de kernel -> "Select Another Kernel" -> "Existing Jupyter Server" ->
  pegar la URL que muestra este script -> "Python 3 (ipykernel)". Ctrl+C detiene el servidor.

.PARAMETER Puerto
  Puerto del servidor. Por defecto, 8899.
#>
[CmdletBinding()]
param([int]$Puerto = 8899)

. "$PSScriptRoot/comun.ps1"

$dir = ConvertTo-WslPath (Join-Path $Root 'cuadernos')
$bash = @"
set -e
[ -x $SageEnv/bin/jupyter ] || { echo 'No existe el entorno de Sage: ejecuta pwsh scripts/prepara-sage.ps1'; exit 1; }
[ -s ~/.mcc-sage-token ] || (umask 077; head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n' > ~/.mcc-sage-token)
TOKEN=`$(cat ~/.mcc-sage-token)
echo
echo "URL para VS Code (Existing Jupyter Server): http://localhost:${Puerto}/?token=`$TOKEN"
echo
export PATH=$SageEnv/bin:`$PATH PYTHONPATH='$dir'
exec $SageEnv/bin/jupyter server --no-browser --ip=127.0.0.1 --port=$Puerto --ServerApp.root_dir='$dir' --IdentityProvider.token="`$TOKEN"
"@
& wsl.exe -d $SageDistro --exec bash -lc ($bash -replace "`r", '')

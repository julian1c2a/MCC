<#
.SYNOPSIS
  GUARDA_y_SUBE: valida todo y, según el resultado, publica en main o guarda en la rama de edición.

.DESCRIPTION
  1. Ejecuta SINCRONIZA con TeX Live y MiKTeX (-TeX Both).
  2. Si todo es correcto:
       - en main: commit y push de main;
       - en edicion-actual: commit en la rama, integración en main como un único
         commit (merge --squash), push de main y borrado de edicion-actual
         (local y remota).
  3. Si hay problemas:
       - en main: se crea la rama edicion-actual con los cambios;
       - commit "WIP" en edicion-actual y push de esa rama a origin.
     main no se toca: siempre apunta al último estado completamente correcto.

.PARAMETER Mensaje
  Mensaje del commit (en español). En caso de fallo se antepone "WIP: ".
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Mensaje
)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$edicion = 'edicion-actual'

# Git for Windows primero: su Git Credential Manager tiene las credenciales de GitHub
# (el git de MSYS2 no las tiene y el push falla).
$gitWindows = 'C:\Program Files\Git\cmd'
if (Test-Path "$gitWindows\git.exe") { $env:PATH = "$gitWindows;$env:PATH" }
$env:GIT_TERMINAL_PROMPT = '0'

function Invoke-Git {
    # Ejecuta git y aborta si falla.
    & git @args
    if ($LASTEXITCODE -ne 0) { throw "git $($args -join ' ') terminó con código $LASTEXITCODE" }
}

function Test-HayCambios { return [bool](git status --porcelain) }

$rama = git branch --show-current
if ($rama -notin @('main', $edicion)) { throw "Rama actual '$rama': GUARDA_y_SUBE solo funciona desde main o $edicion." }

Write-Host "== Validación completa (SINCRONIZA -TeX Both) en la rama $rama" -ForegroundColor Cyan
& pwsh -NoProfile -File "$PSScriptRoot/sincroniza.ps1" -TeX Both
$correcto = ($LASTEXITCODE -eq 0)

if ($correcto) {
    if ($rama -eq $edicion) {
        if (Test-HayCambios) { Invoke-Git add -A; Invoke-Git commit -q -m "WIP: $Mensaje" }
        Invoke-Git switch -q main
        & git merge --squash $edicion
        if ($LASTEXITCODE -ne 0) {
            & git merge --abort 2>$null; & git reset -q --hard HEAD; Invoke-Git switch -q $edicion
            throw "No se pudo integrar $edicion en main (¿main ha cambiado por otra vía?). Los cambios siguen en $edicion."
        }
    } else {
        Invoke-Git add -A
    }
    if (-not (git diff --cached --name-only)) {
        Write-Host 'No hay cambios que guardar.'
    } else {
        Invoke-Git commit -q -m $Mensaje
        Write-Host "-- Commit en main: $(git log -1 --format='%h %s')"
    }
    Invoke-Git push -q origin main
    Write-Host '-- main publicada en origin.' -ForegroundColor Green
    if ($rama -eq $edicion) {
        Invoke-Git branch -q -D $edicion
        & git ls-remote --exit-code --heads origin $edicion *> $null
        if ($LASTEXITCODE -eq 0) { Invoke-Git push -q origin --delete $edicion }
        Write-Host "-- Rama $edicion integrada y borrada."
    }
    exit 0
}

Write-Host "`n== Hay problemas: los cambios se guardan en la rama $edicion; main no se modifica." -ForegroundColor Yellow
if ($rama -eq 'main') {
    & git show-ref --verify --quiet "refs/heads/$edicion"
    if ($LASTEXITCODE -eq 0) { throw "Ya existe la rama $edicion. Cámbiate a ella (git switch $edicion) y repite." }
    Invoke-Git switch -q -c $edicion
}
Invoke-Git add -A
if (Test-HayCambios) { Invoke-Git commit -q -m "WIP: $Mensaje" }
Invoke-Git push -q -u origin $edicion
Write-Host "-- Guardado en $edicion y subido a origin: $(git log -1 --format='%h %s')"
exit 1

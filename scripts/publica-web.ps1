<#
.SYNOPSIS
  PUBLICA_WEB: publica html/ y doc_out/ en GitHub Pages (https://julian1c2a.github.io/MCC/).

.DESCRIPTION
  1. Activa GitHub Pages en el repositorio (origen: GitHub Actions) si aún no lo está.
  2. Ejecuta GUARDA_y_SUBE. Si falla, no publica: main no ha cambiado.
  3. Lanza el workflow .github/workflows/pages.yml, espera a que termine y muestra la URL.
     (Cada GUARDA_y_SUBE que cambie html/ o doc_out/ también lo lanza automáticamente.)

.PARAMETER Mensaje
  Mensaje del commit para GUARDA_y_SUBE.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$Mensaje)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
$gh = 'C:\Program Files\GitHub CLI\gh.exe'
$repo = 'julian1c2a/MCC'
if (-not (Test-Path $gh)) { throw "No se encuentra GitHub CLI en $gh" }

# 1. GitHub Pages con origen "GitHub Actions".
& $gh api "repos/$repo/pages" *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host '-- Activando GitHub Pages (origen: GitHub Actions)'
    & $gh api -X POST "repos/$repo/pages" -f build_type=workflow | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo activar GitHub Pages.' }
}

# 2. Validar, commit y push.
& pwsh -NoProfile -File "$PSScriptRoot/guarda-y-sube.ps1" -Mensaje $Mensaje
if ($LASTEXITCODE -ne 0) { Write-Host 'GUARDA_y_SUBE no terminó bien: no se publica.' -ForegroundColor Red; exit 1 }

# 3. Publicar y esperar.
Write-Host '-- Lanzando el workflow de publicación'
& $gh workflow run pages.yml --repo $repo --ref main
if ($LASTEXITCODE -ne 0) { throw 'No se pudo lanzar el workflow pages.yml.' }
Start-Sleep -Seconds 5
$runId = & $gh run list --repo $repo --workflow pages.yml --limit 1 --json databaseId --jq '.[0].databaseId'
& $gh run watch $runId --repo $repo --exit-status
if ($LASTEXITCODE -ne 0) { Write-Host "La publicación falló: $gh run view $runId --repo $repo --log-failed" -ForegroundColor Red; exit 1 }
$url = & $gh api "repos/$repo/pages" --jq '.html_url'
Write-Host "Publicado: $url" -ForegroundColor Green

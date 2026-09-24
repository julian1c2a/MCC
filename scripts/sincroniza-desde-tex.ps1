<#
.SYNOPSIS
  SINCRONIZA_desde_TEX: ayuda a portar al Markdown los cambios hechos a mano en un .tex.

.DESCRIPTION
  El paso .tex -> .md no es automático (Pandoc no reproduce las convenciones del
  Markdown); lo hace quien edita (o la IA) con ayuda de este script, en dos fases:

  -Fase Preparar (por defecto)
    1. Compila el .tex editado tal como está (build/sync/<distribución>/) y
       exige que no tenga errores ni advertencias.
    2. Guarda una copia en build/sync/<nombre>.manual.tex.
    3. Genera build/sync/<nombre>.base.tex desde el Markdown actual.
    4. Muestra (y guarda en build/sync/<nombre>.cambios.diff) la diferencia
       base -> manual: son exactamente los cambios hechos a mano en el .tex.
    Después se trasladan esos cambios al Markdown.

  -Fase Verificar
    1. Ejecuta SINCRONIZA_desde_MD (regenera .tex, .html y PDFs, y lo valida todo).
    2. Compara el .tex regenerado con la copia manual, ignorando espacios y
       saltos de línea. Si no hay diferencias, la sincronización es completa.

.PARAMETER Name
  Documento(s). Por defecto, los .tex más recientes que su Markdown (Preparar) o
  los que tienen copia en build/sync/ (Verificar).

.PARAMETER TeX
  TeXLive (por defecto), MiKTeX o Both.
#>
[CmdletBinding()]
param(
    [ValidateSet('Preparar', 'Verificar')]
    [string]$Fase = 'Preparar',
    [string[]]$Name,
    [ValidateSet('TeXLive', 'MiKTeX', 'Both')]
    [string]$TeX = 'TeXLive'
)

. "$PSScriptRoot/comun.ps1"

$syncDir = 'build/sync'
New-Item -ItemType Directory -Force $syncDir | Out-Null
$distros = Get-Distros $TeX

if (-not $Name) {
    $Name = @(if ($Fase -eq 'Preparar') {
            Get-ChildItem markdown -Filter *.md | Where-Object {
                $texPath = "latex/$($_.BaseName).tex"
                (Test-Path $texPath) -and ((Get-Item $texPath).LastWriteTimeUtc -gt $_.LastWriteTimeUtc)
            } | ForEach-Object BaseName
        } else {
            Get-ChildItem $syncDir -Filter *.manual.tex | ForEach-Object { $_.Name -replace '\.manual\.tex$', '' }
        })
    if (-not $Name) { Write-Host 'No hay ningún .tex pendiente de sincronizar.'; exit 0 }
}

foreach ($n in $Name) {
    Write-Host "== $n ($Fase)" -ForegroundColor Cyan
    $mdFile = "markdown/$n.md"
    $texFile = "latex/$n.tex"
    $manual = "$syncDir/$n.manual.tex"

    if ($Fase -eq 'Preparar') {
        foreach ($d in $distros) { $null = Invoke-LatexCompile $texFile $d "$syncDir/$d" }
        Copy-Item $texFile $manual -Force

        Use-TeX
        $base = "$syncDir/$n.base.tex"
        $out = Invoke-Tool 'pandoc (tex)' 'pandoc' ($PandocTex + @("--output=$base", $mdFile))
        Test-PandocWarnings 'pandoc (tex)' $out

        $diff = & git diff --no-index --word-diff=plain --ignore-all-space -- $base $manual 2>$null
        $diff | Set-Content "$syncDir/$n.cambios.diff" -Encoding utf8
        if ($diff) {
            Write-Host "-- Cambios hechos a mano en $texFile (también en $syncDir/$n.cambios.diff):"
            $diff | Where-Object { $_ -match '\[-|\{\+' } | ForEach-Object { Write-Host "   $_" }
            Write-Host "-- Traslada estos cambios a $mdFile y ejecuta la fase Verificar."
        } else {
            Write-Host "-- $texFile no tiene cambios respecto al Markdown."
        }
    } else {
        if (-not (Test-Path $manual)) { throw "No existe ${manual}: ejecuta antes la fase Preparar." }

        & pwsh -NoProfile -File "$PSScriptRoot/sincroniza-desde-md.ps1" -Name $n -TeX $TeX
        if ($LASTEXITCODE -ne 0) { Add-Problem "SINCRONIZA_desde_MD falló para $n" }

        $diff = & git diff --no-index --word-diff=plain --ignore-all-space -- $manual $texFile 2>$null
        if ($diff) {
            Add-Problem "el .tex regenerado no coincide con la edición manual de $n. Diferencias restantes (manual -> regenerado):"
            $diff | Where-Object { $_ -match '\[-|\{\+' } | ForEach-Object { Write-Host "   $_" }
        } elseif (-not $Problems.Count) {
            Remove-Item "$syncDir/$n.*" -Force
            Write-Host "-- Sincronización completa: el .tex regenerado reproduce la edición manual."
        }
    }
}

Exit-WithSummary

<#
.SYNOPSIS
  Revisa y resume los planes de trabajo del grupo (comunicaciones/planificacion/NEXT-STEPS-*.md).

.DESCRIPTION
  Cada tarea es una línea con el formato
      - [ ] G-04 | 11-10 | Parejas | Texto de la tarea. ↑G-01
  con estado [ ] pendiente, [~] en curso, [x] hecha o [!] bloqueada; identificador G-nn (grupo),
  P1-nn o P2-nn (parejas) o J-nn (personal); fecha dd-mm o «—»; responsable; y, opcionalmente,
  la tarea de la que depende (↑ID), que debe terminar no antes que ella (REGLAS.md 8.6).

  Problemas (hacen fallar el script): identificadores repetidos, dependencias que no existen y
  líneas de tarea mal formadas. Avisos: una tarea que termina después que la tarea de la que
  depende, una tarea hecha con dependientes pendientes y las tareas vencidas.

.PARAMETER Quien
  Muestra solo las tareas de esa persona (incluye las de su pareja y las de «Todos»).

.PARAMETER Resumen
  Salida breve para ESTADO: recuento por plan, vencidas y próximos 7 días.
#>
[CmdletBinding()]
param([string]$Quien, [switch]$Resumen)

. "$PSScriptRoot/comun.ps1"

$dir = Join-Path $Root 'comunicaciones/planificacion'
$planes = @(Get-ChildItem $dir -Filter 'NEXT-STEPS-*.md' -ErrorAction SilentlyContinue)
if (-not $planes) { Write-Host "No hay planes en $dir."; exit 0 }

$parejas = @{ 'Pareja 1' = @('Maria', 'Julian'); 'Pareja 2' = @('Gonzalo', 'Jose Miguel') }
function Sin-Tildes([string]$s) {
    $n = $s.Normalize([Text.NormalizationForm]::FormD)
    (-join ($n.ToCharArray() | Where-Object { [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark' })).ToLower()
}
function Es-De([string]$responsable, [string]$persona) {
    $r = Sin-Tildes $responsable; $p = Sin-Tildes $persona
    if ($r -match [regex]::Escape($p) -or $r -match '^(todos|parejas)$') { return $true }
    foreach ($par in $parejas.Keys) {
        if ($r -match (Sin-Tildes $par) -and ($parejas[$par] | Where-Object { (Sin-Tildes $_) -match [regex]::Escape($p) })) { return $true }
    }
    return $false
}

$hoy = (Get-Date).Date
$patron = '^\s*-\s\[(?<e>[ x~!])\]\s+(?<id>(?:G|P\d|J)-\d{2})\s*\|\s*(?<fecha>\d{2}-\d{2}|—|-)\s*\|\s*(?<quien>[^|]+?)\s*\|\s*(?<texto>.+?)\s*$'
$tareas = [Collections.Generic.List[object]]::new()
foreach ($plan in $planes) {
    $enCodigo = $false; $n = 0
    foreach ($linea in Get-Content $plan.FullName -Encoding utf8) {
        $n++
        if ($linea -match '^\s*```') { $enCodigo = -not $enCodigo; continue }
        if ($enCodigo -or $linea -notmatch '^\s*-\s\[') { continue }
        if ($linea -notmatch $patron) { Add-Problem "$($plan.Name):${n}: línea de tarea con formato incorrecto"; continue }
        $m = $Matches.Clone()   # los -match siguientes sobrescriben $Matches
        $fecha = $null
        if ($m.fecha -match '^(\d{2})-(\d{2})$') { $fecha = [datetime]::new($hoy.Year, [int]$Matches[2], [int]$Matches[1]) }
        $padre = if ($m.texto -match '↑((?:G|P\d|J)-\d{2})\s*$') { $Matches[1] } else { $null }
        $tareas.Add([pscustomobject]@{
                Plan = ($plan.BaseName -replace '^NEXT-STEPS-', ''); Linea = $n; Id = $m.id; Estado = $m.e
                Fecha = $fecha; Quien = $m.quien; Texto = ($m.texto -replace '\s*↑\S+\s*$', ''); Padre = $padre
            })
    }
}

# Coherencia entre planes.
$porId = @{}
foreach ($t in $tareas) {
    if ($porId.ContainsKey($t.Id)) { Add-Problem "$($t.Id) está repetido ($($porId[$t.Id].Plan) y $($t.Plan))" } else { $porId[$t.Id] = $t }
}
$avisos = [Collections.Generic.List[string]]::new()
foreach ($t in $tareas | Where-Object Padre) {
    $p = $porId[$t.Padre]
    if (-not $p) { Add-Problem "$($t.Id) depende de $($t.Padre), que no existe"; continue }
    if ($t.Fecha -and $p.Fecha -and $t.Fecha -gt $p.Fecha) {
        $avisos.Add("$($t.Id) ($($t.Fecha.ToString('dd-MM'))) termina después que $($p.Id) ($($p.Fecha.ToString('dd-MM')))")
    }
    if ($p.Estado -eq 'x' -and $t.Estado -ne 'x') { $avisos.Add("$($p.Id) está hecha, pero $($t.Id), que depende de ella, no") }
}

$abiertas = @($tareas | Where-Object { $_.Estado -ne 'x' })
if ($Quien) { $abiertas = @($abiertas | Where-Object { Es-De $_.Quien $Quien }) }
$vencidas = @($abiertas | Where-Object { $_.Fecha -and $_.Fecha -lt $hoy } | Sort-Object Fecha)
$proximas = @($abiertas | Where-Object { $_.Fecha -and $_.Fecha -ge $hoy -and $_.Fecha -le $hoy.AddDays(7) } | Sort-Object Fecha)
$marca = @{ ' ' = 'pendiente'; '~' = 'en curso'; '!' = 'BLOQUEADA'; 'x' = 'hecha' }
function Linea($t) { "   {0,-6} {1}  {2,-14} {3}{4}" -f $t.Id, $(if ($t.Fecha) { $t.Fecha.ToString('dd-MM') } else { '  —  ' }), $t.Quien, $t.Texto, $(if ($t.Estado -ne ' ') { " [$($marca[$t.Estado])]" }) }

foreach ($g in $tareas | Group-Object Plan) {
    $h = @($g.Group | Where-Object Estado -eq 'x').Count
    $b = @($g.Group | Where-Object Estado -eq '!').Count
    Write-Host ("{0,-10} {1} tarea(s): {2} hecha(s), {3} abierta(s){4}" -f $g.Name, $g.Count, $h, ($g.Count - $h), $(if ($b) { ", $b bloqueada(s)" }))
}
if ($Quien) { Write-Host "Filtrado para: $Quien (incluye su pareja y «Todos»)" }
if ($vencidas) { Write-Host 'Vencidas:' -ForegroundColor Yellow; $vencidas | ForEach-Object { Write-Host (Linea $_) -ForegroundColor Yellow } }
if ($proximas) { Write-Host 'Próximos 7 días:'; $proximas | ForEach-Object { Write-Host (Linea $_) } }
if (-not $Resumen) {
    $resto = @($abiertas | Where-Object { $_ -notin $vencidas -and $_ -notin $proximas } | Sort-Object { if ($_.Fecha) { $_.Fecha } else { [datetime]::MaxValue } })
    if ($resto) { Write-Host 'Más adelante o sin fecha:'; $resto | ForEach-Object { Write-Host (Linea $_) } }
}
foreach ($a in $avisos) { Write-Host "  AVISO: $a" -ForegroundColor Yellow }
if ($Resumen) { if ($Problems.Count) { Write-Host "$($Problems.Count) problema(s) de formato en los planes: pwsh scripts/siguientes-pasos.ps1" -ForegroundColor Red }; exit 0 }
if ($Problems.Count) { Write-Host "`n$($Problems.Count) problema(s) en los planes." -ForegroundColor Red; exit 1 }
Write-Host "`nPlanes coherentes: identificadores únicos y todas las dependencias existen."

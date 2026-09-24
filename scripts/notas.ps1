<#
.SYNOPSIS
  Lista las notas para la IA (<!-- AI:Tn-nn ... -->) de los Markdown del proyecto.

.PARAMETER Todas
  Incluye también las notas con "Estado: hecho." (por defecto, solo las pendientes).

.PARAMETER Json
  Devuelve el resultado en JSON (para otros scripts).
#>
[CmdletBinding()]
param(
    [switch]$Todas,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)

$notas = foreach ($file in Get-ChildItem markdown -Filter *.md) {
    $text = [IO.File]::ReadAllText($file.FullName)
    foreach ($m in [regex]::Matches($text, '(?s)<!--\s*AI:(?<id>T\d+-\d+)(?<cuerpo>.*?)-->')) {
        $cuerpo = $m.Groups['cuerpo'].Value
        $estado = if ($cuerpo -match '(?m)^\s*Estado:\s*(?<e>[^\r\n]*?)\.?\s*$') { $Matches['e'].Trim() } else { 'pendiente' }
        $tarea = if ($cuerpo -match '(?m)^\s*Tarea:\s*(?<t>[^\r\n]*)') { $Matches['t'].Trim() } else { ($cuerpo.Trim() -split "`n")[0] }
        [pscustomobject]@{
            Id     = $m.Groups['id'].Value
            Archivo = "markdown/$($file.Name)"
            Linea  = $text.Substring(0, $m.Index).Split("`n").Count
            Estado = $estado
            Tarea  = $tarea
        }
    }
}
$notas = @($notas | Where-Object { $Todas -or $_.Estado -notmatch '^hecho' })

if ($Json) { $notas | ConvertTo-Json -AsArray; exit 0 }
if (-not $notas) { Write-Host 'No hay notas para la IA pendientes.'; exit 0 }
foreach ($n in $notas) {
    Write-Host ("{0,-8} {1}:{2}  [{3}]  {4}" -f $n.Id, $n.Archivo, $n.Linea, $n.Estado, $n.Tarea)
}

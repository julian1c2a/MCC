<#
.SYNOPSIS
  NUEVO_TEMA: crea markdown/Tema-<n>-<titulo>.md con el bloque YAML, el título y el bloque
  de autoría de REGLAS.md (4.1), y lo sincroniza.

.PARAMETER Numero
  Número del tema.

.PARAMETER Titulo
  Título del tema, sin «Tema n.» (por ejemplo, "Postulados de la mecánica cuántica").

.PARAMETER Asignatura
  Asignatura a la que pertenece. Por defecto, Complementos de Mecánica Cuántica.

.EXAMPLE
  pwsh scripts/nuevo-tema.ps1 -Numero 2 -Titulo "Postulados de la mecánica cuántica"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][int]$Numero,
    [Parameter(Mandatory)][string]$Titulo,
    [string]$Asignatura = 'Complementos de Mecánica Cuántica'
)

. "$PSScriptRoot/comun.ps1"

# Nombre de archivo: sin tildes ni signos, palabras separadas por guiones, en mayúscula inicial.
$sinTildes = -join ($Titulo.Normalize([Text.NormalizationForm]::FormD).ToCharArray() |
        Where-Object { [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark' })
$palabras = ($sinTildes -replace '[^A-Za-z0-9 ]', ' ').Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
$slug = ($palabras | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower() }) -join '-'
$nombre = "Tema-$Numero-$slug"
$mdFile = "markdown/$nombre.md"

if (Get-ChildItem markdown -Filter "Tema-$Numero-*.md" | Where-Object { $_.BaseName -notmatch '-(ficha|ejercicios)$' }) {
    throw "Ya existe un Markdown para el tema $Numero en markdown/."
}

$fecha = (Get-Date).ToString('yyyy-MM-dd')
$contenido = @"
---
author: "Julián Calderón Almendros"
---

# Tema $Numero. $Titulo

* **Asignatura:** $Asignatura (Máster en Computación Cuántica)
* **Propósito:** apuntes de autoestudio elaborados para preparar la asignatura.
* **Última edición:** $fecha
* **Autor:** Julián Calderón Almendros
* **Correo electrónico:** julian.calderon.almendros at gmail.com
* **GitHub:** [\@julian1c2a](https://github.com/julian1c2a)
* **Proyecto:** <https://github.com/julian1c2a/MCC>
* **Licencia:** [Creative Commons Reconocimiento 4.0 Internacional (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.es). Se permite copiar, redistribuir, modificar y reutilizar este material con cualquier finalidad, incluso comercial, siempre que se reconozca la autoría original, se enlace la licencia y se indique si se han hecho cambios.

## 1. Introducción

Contenido pendiente de redactar.
"@
[IO.File]::WriteAllText((Join-Path $Root $mdFile), $contenido.Replace("`r`n", "`n") + "`n", [Text.UTF8Encoding]::new($false))
Write-Host "Creado $mdFile"

& pwsh -NoProfile -File "$PSScriptRoot/sincroniza-desde-md.ps1" -Name $nombre
exit $LASTEXITCODE

<#
.SYNOPSIS
  NUEVO_TRABAJO: crea trabajos/<nombre>/ con el esqueleto del modelo UNIR (REGLAS.md, sección 8).

.DESCRIPTION
  Copia trabajos/_plantilla/trabajo-modelo.md como trabajos/<nombre>/<nombre>.md, con el título
  y el profesor indicados, y crea una bibliografía vacía (referencias.bib). No lo compila: el
  esqueleto aún tiene textos de ejemplo que SINCRONIZA_TRABAJO rechaza.

.PARAMETER Nombre
  Nombre corto del trabajo, sin espacios ni tildes (será el nombre del directorio y de los archivos).

.PARAMETER Titulo
  Título del trabajo.

.PARAMETER Profesor
  Profesor de la asignatura.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidatePattern('^[A-Za-z0-9][A-Za-z0-9_-]*$')][string]$Nombre,
    [Parameter(Mandatory)][string]$Titulo,
    [string]$Profesor = 'Nombre del profesor'
)

. "$PSScriptRoot/comun.ps1"

$dir = "trabajos/$Nombre"
if (Test-Path $dir) { throw "Ya existe $dir." }
New-Item -ItemType Directory -Force $dir | Out-Null

$texto = [IO.File]::ReadAllText((Join-Path $Root 'trabajos/_plantilla/trabajo-modelo.md'))
$texto = $texto.Replace('title: "Título del trabajo"', "title: `"$($Titulo.Replace('"', '\"'))`"")
$texto = $texto.Replace('profesor: "Nombre del profesor"', "profesor: `"$($Profesor.Replace('"', '\"'))`"")
[IO.File]::WriteAllText((Join-Path $Root "$dir/$Nombre.md"), $texto, [Text.UTF8Encoding]::new($false))

$bib = @'
% Referencias del trabajo (APA 7; REGLAS.md, sección 8.3).
% Una entrada BibTeX por obra citada. Campos obligatorios según el tipo:
%   @article: author, year, title, journal, volume, pages, doi (o url si no tiene DOI)
%   @book:    author o editor, year, title, publisher (y doi si lo tiene)
%   @incollection: author, year, title, booktitle, editor, publisher, pages
%   @online:  author, year, title, url
'@
[IO.File]::WriteAllText((Join-Path $Root "$dir/referencias.bib"), $bib.Replace("`r`n", "`n") + "`n", [Text.UTF8Encoding]::new($false))

Write-Host "Creado $dir/$Nombre.md y $dir/referencias.bib"

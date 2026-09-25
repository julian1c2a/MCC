<#
.SYNOPSIS
  SINCRONIZA_TRABAJO: genera y valida un trabajo del curso con el modelo UNIR y APA 7.

.DESCRIPTION
  Para trabajos/<nombre>/<nombre>.md (REGLAS.md, sección 8):

    1. Protección: si el .tex es más reciente que el .md, se detiene (hay que portar
       los cambios al Markdown, o usar -Force para descartarlos).
    2. Fórmulas y estilo del proyecto (scripts/check-md.mjs).
    3. Requisitos del modelo UNIR: metadatos completos y sin textos de ejemplo, resumen y
       abstract de 150 palabras como máximo, de 3 a 5 palabras clave en cada idioma,
       capítulos obligatorios en su orden y sin numeración manual.
    4. Bibliografía (APA 7): campos obligatorios de cada referencia según su tipo; toda cita
       debe existir en la bibliografía (Pandoc avisa si no).
    5. Markdown -> trabajos/<nombre>/<nombre>.tex con trabajos/_plantilla/unir.latex, citeproc
       y el estilo trabajos/_plantilla/apa-es.csl.
    6. LaTeX -> PDF en build/trabajos/<nombre>/ (TEXINPUTS apunta al modelo de
       material/), sin errores ni advertencias salvo las del propio modelo (REGLAS.md 8.4).
       El PDF se copia a trabajos/<nombre>/<nombre>.pdf.

.PARAMETER Name
  Nombre del trabajo (subdirectorio de trabajos/). Por defecto, todos salvo _plantilla.

.PARAMETER TeX
  TeXLive (por defecto), MiKTeX o Both.

.PARAMETER Force
  Regenera el .tex aunque sea más reciente que el Markdown.
#>
[CmdletBinding()]
param(
    [string[]]$Name,
    [ValidateSet('TeXLive', 'MiKTeX', 'Both')]
    [string]$TeX = 'TeXLive',
    [switch]$Force
)

. "$PSScriptRoot/comun.ps1"

$modelo = Join-Path $Root 'material/Plantilla_LATEX_FCC_MUCC_UNIR'
$plantilla = Join-Path $Root 'trabajos/_plantilla'
if (-not (Test-Path "$modelo/estilo_unir-1.sty")) { throw "No se encuentra el modelo UNIR en $modelo" }

# Advertencias del propio modelo UNIR que no se pueden eliminar sin modificarlo (REGLAS.md 8.4).
$permitidas = @(
    '^LaTeX Warning: You have requested package `estilo_unir-1'','   # \ProvidesPackage{unir} en estilo_unir-1.sty
)

# Capítulos obligatorios del modelo, en orden (el título se compara sin distinguir mayúsculas).
$capitulos = @('Introducción', 'Contexto y estado de la cuestión', 'Objetivos',
    'Desarrollo del trabajo', 'Conclusiones', 'Bibliografía')

# Campos obligatorios de una referencia APA 7, por tipo CSL.
$camposPorTipo = @{
    'article-journal'   = @('container-title', 'volume', 'page|article-number', 'DOI|URL')
    'book'              = @('publisher')
    'chapter'           = @('container-title', 'publisher', 'page')
    'paper-conference'  = @('container-title', 'publisher|event-title')
    'thesis'            = @('publisher')
    'report'            = @('publisher')
    'webpage'           = @('URL')
    'post-weblog'       = @('URL')
}

function Get-Palabras([string]$texto) { @($texto -split '\s+' | Where-Object { $_ -match '[\p{L}\p{N}]' }).Count }

$distros = Get-Distros $TeX
$nombres = @(if ($Name) { $Name } else {
        Get-ChildItem trabajos -Directory | Where-Object { $_.Name -ne '_plantilla' } | ForEach-Object Name
    })
if (-not $nombres) { Write-Host 'No hay trabajos.'; exit 0 }

foreach ($n in $nombres) {
    Write-Host "== Trabajo: $n" -ForegroundColor Cyan
    $dir = "trabajos/$n"
    $mdFile = "$dir/$n.md"
    $texFile = "$dir/$n.tex"
    if (-not (Test-Path $mdFile)) { Add-Problem "no existe $mdFile"; continue }

    # 1. Protección frente a ediciones manuales del .tex.
    if ((Test-Path $texFile) -and ((Get-Item $texFile).LastWriteTimeUtc -gt (Get-Item $mdFile).LastWriteTimeUtc) -and -not $Force) {
        throw "$texFile es más reciente que $mdFile. Porta primero sus cambios al Markdown (o usa -Force para descartarlos)."
    }
    Set-SourceDate $mdFile

    # 2. Fórmulas y estilo.
    Write-Host '-- KaTeX y reglas de estilo'
    $out = Invoke-Tool 'check-md' $NodeExe @('scripts/check-md.mjs', $mdFile)
    $out | ForEach-Object { Write-Host "  $_" }

    # 3. Requisitos del modelo.
    Write-Host '-- Requisitos del modelo UNIR'
    Use-TeX
    $meta = (& pandoc $mdFile --template="$plantilla/meta-json.tpl" --to=plain 2>$null) -join "`n" | ConvertFrom-Json -AsHashtable
    $ejemplo = @{ title = 'Título del trabajo'; date = 'DD de MES'; profesor = 'Nombre del profesor'
        resumen = 'Resumen en español del trabajo'; abstract = 'English version of the Resumen' }
    foreach ($campo in 'title', 'author', 'date', 'profesor', 'resumen', 'abstract') {
        $valor = "$($meta[$campo])".Trim()
        if (-not $valor) { Add-Problem "${mdFile}: falta el metadato '$campo'" }
        elseif ($ejemplo[$campo] -and $valor -like "*$($ejemplo[$campo])*") { Add-Problem "${mdFile}: '$campo' conserva el texto de ejemplo" }
    }
    if (@($meta['author']).Count -gt 1 -and -not "$($meta['autor-cabecera'])".Trim()) {
        Add-Problem "${mdFile}: con varios autores hace falta 'autor-cabecera' (texto breve para la cabecera de las páginas)"
    }
    foreach ($campo in 'resumen', 'abstract') {
        $np =Get-Palabras "$($meta[$campo])"
        if ($np -gt 150) { Add-Problem "${mdFile}: '$campo' tiene $np palabras (máximo 150)" }
    }
    foreach ($campo in 'palabras-clave', 'keywords') {
        $k = @($meta[$campo]).Count
        if ($k -lt 3 -or $k -gt 5) { Add-Problem "${mdFile}: '$campo' tiene $k términos (deben ser de 3 a 5)" }
        if (@($meta[$campo]) -match '^(palabra clave|keyword) \d+$') { Add-Problem "${mdFile}: '$campo' conserva términos de ejemplo" }
    }
    if ("$($meta['lang'])" -ne 'es-ES') { Add-Problem "${mdFile}: el metadato 'lang' debe ser es-ES (citas y referencias en español)" }

    $lineas = Get-Content $mdFile -Encoding utf8
    $enCodigo = $false
    $titulos = foreach ($l in $lineas) {
        if ($l -match '^```') { $enCodigo = -not $enCodigo; continue }
        if (-not $enCodigo -and $l -match '^(#{1,6})\s+(.+?)\s*$') {
            if ($Matches[2] -match '^\d+(\.\d+)*\.?\s') { Add-Problem "${mdFile}: título con numeración manual: '$l' (la numera LaTeX)" }
            if ($Matches[1] -eq '#') { ($Matches[2] -replace '\s*\{[^}]*\}\s*$', '').Trim() }
        }
    }
    $titulos = @($titulos)
    $obligatorios = @($titulos | Select-Object -First $capitulos.Count)
    for ($i = 0; $i -lt $capitulos.Count; $i++) {
        if ($i -ge $obligatorios.Count -or $obligatorios[$i] -ne $capitulos[$i]) {
            Add-Problem "${mdFile}: el capítulo $($i + 1) debe ser '# $($capitulos[$i])' (modelo UNIR); se encontró '$($obligatorios[$i])'"
        }
    }
    if ($titulos.Count -gt $capitulos.Count -and -not ($lineas -contains '\appendix')) {
        Add-Problem "${mdFile}: hay capítulos después de la Bibliografía sin la línea \appendix que los convierte en apéndices"
    }
    if (-not ($lineas -match '^::: *\{#refs\}')) { Add-Problem "${mdFile}: falta el bloque '::: {#refs}' bajo '# Bibliografía {-}'" }

    # 4. Bibliografía.
    Write-Host '-- Bibliografía (APA 7)'
    $bib = @($meta['bibliography']) | Where-Object { $_ }
    if (-not $bib) { Add-Problem "${mdFile}: falta el metadato 'bibliography'" }
    foreach ($b in $bib) {
        $bibPath = Join-Path $dir $b
        if (-not (Test-Path $bibPath)) { Add-Problem "no existe la bibliografía $bibPath"; continue }
        $refs = (& pandoc $bibPath --to=csljson 2>&1) -join "`n" | ConvertFrom-Json -AsHashtable
        foreach ($r in $refs) {
            $id = $r['id']
            if (-not ($r['author'] -or $r['editor'])) { Add-Problem "${b}: '$id' sin autor ni editor" }
            if (-not $r['issued']) { Add-Problem "${b}: '$id' sin año" }
            if (-not $r['title']) { Add-Problem "${b}: '$id' sin título" }
            foreach ($req in $camposPorTipo[$r['type']]) {
                if (-not ($req -split '\|' | Where-Object { $r[$_] })) { Add-Problem "${b}: '$id' ($($r['type'])) sin '$($req -replace '\|', "' ni '")'" }
            }
        }
        Write-Host "  $($refs.Count) referencias revisadas en $b"
    }

    # 5. Markdown -> LaTeX con el modelo y APA.
    Write-Host "-- Pandoc: $mdFile -> $texFile"
    Push-Location $dir
    $out = Invoke-Tool 'pandoc (tex)' 'pandoc' @("$n.md", '--from=markdown+tex_math_dollars', '--to=latex',
        "--template=$plantilla/unir.latex", '--top-level-division=chapter',
        '--citeproc', "--csl=$plantilla/apa-es.csl", "--output=$n.tex")
    Pop-Location
    Test-PandocWarnings 'pandoc (tex)' $out

    # 6. LaTeX -> PDF.
    $env:TEXINPUTS = "$((Resolve-Path $dir).Path)//;$modelo//;"
    foreach ($d in $distros) {
        $pdf = Invoke-LatexCompile $texFile $d "build/trabajos/$n/$d" $permitidas
        if ($d -eq $distros[0] -and (Test-Path $pdf)) { Copy-Item $pdf "$dir/$n.pdf" -Force }
    }
    Remove-Item Env:TEXINPUTS
    (Get-Item $texFile).LastWriteTime = (Get-Item $mdFile).LastWriteTime
}

Exit-WithSummary

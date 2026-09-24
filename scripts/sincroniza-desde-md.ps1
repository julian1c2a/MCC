<#
.SYNOPSIS
  SINCRONIZA_desde_MD: Markdown -> LaTeX -> PDF y Markdown -> HTML, con validación completa.

.DESCRIPTION
  El Markdown (markdown/<nombre>.md) es la fuente única. Para cada documento:

    1. Comprueba que ni el .tex ni el .html se han editado a mano después del
       .md (si es así, se aborta: hay que usar SINCRONIZA_desde_TEX).
    2. Actualiza la línea "Última edición" del bloque de autoría con la fecha
       de modificación del .md.
    3. Valida las fórmulas con KaTeX y las reglas de estilo automáticas
       (scripts/check-md.mjs).
    4. Genera latex/<nombre>.tex con Pandoc.
    5. Compila el .tex con latexmk + pdflatex en build/latex/<distribución>/ y
       copia el PDF a doc_out/latex/.
    6. Genera doc_out/markdown/<nombre>.pdf directamente desde el Markdown.
    7. Genera html/<nombre>.html (índice, MathJax, html/tema-1.css).
    8. Falla si hay cualquier error o advertencia: de Pandoc, de LaTeX
       (Warning, Overfull/Underfull, Missing character) o de estilo.

  El .tex y el .html generados reciben la fecha de modificación del .md; así,
  si luego se editan a mano, quedan "más recientes" que el .md y se detecta.

.PARAMETER Name
  Nombre base del documento (sin extensión). Por defecto, todos los .md de markdown/.

.PARAMETER TeX
  TeXLive (C:\msys64\ucrt64, por defecto), MiKTeX (D:\miktex) o Both (ambas).

.PARAMETER Force
  Regenera aunque el .tex o el .html sean más recientes que el .md (descarta esas ediciones).

.EXAMPLE
  pwsh scripts/sincroniza-desde-md.ps1
  pwsh scripts/sincroniza-desde-md.ps1 -Name Tema-1-Mecanica-teorica -TeX Both
#>
[CmdletBinding()]
param(
    [string[]]$Name,
    [ValidateSet('TeXLive', 'MiKTeX', 'Both')]
    [string]$TeX = 'TeXLive',
    [switch]$Force
)

. "$PSScriptRoot/comun.ps1"

$distros = Get-Distros $TeX

foreach ($n in (Get-DocNames $Name)) {
    Write-Host "== $n" -ForegroundColor Cyan
    $mdFile = "markdown/$n.md"
    $texFile = "latex/$n.tex"
    $htmlFile = "html/$n.html"
    if (-not (Test-Path $mdFile)) { throw "No existe $mdFile" }

    # 1. Protección frente a ediciones manuales de los derivados.
    $mdTime = (Get-Item $mdFile).LastWriteTimeUtc
    foreach ($derived in @($texFile, $htmlFile)) {
        if ((Test-Path $derived) -and ((Get-Item $derived).LastWriteTimeUtc -gt $mdTime) -and -not $Force) {
            throw "$derived es más reciente que $mdFile. Usa SINCRONIZA_desde_TEX (scripts/sincroniza-desde-tex.ps1) para portar sus cambios al Markdown, o -Force para descartarlos."
        }
    }

    # 2. Fecha de última edición: la línea "* **Última edición:** AAAA-MM-DD" del bloque de
    # autoría se actualiza con la fecha de modificación del .md. Solo se reescribe si cambia.
    $mdText = [IO.File]::ReadAllText((Resolve-Path $mdFile))
    $dateRe = '(?m)^(\* \*\*Última edición:\*\* )(.*?)(\r?)$'
    if (-not [regex]::IsMatch($mdText, $dateRe)) {
        Add-Problem "${mdFile}: falta la línea '* **Última edición:** ...' del bloque de autoría (REGLAS.md, 4.1)"
    } else {
        $editDate = (Get-Item $mdFile).LastWriteTime.ToString('yyyy-MM-dd')
        $newText = [regex]::Replace($mdText, $dateRe, { param($m) $m.Groups[1].Value + $editDate + $m.Groups[3].Value })
        if ($newText -ne $mdText) {
            [IO.File]::WriteAllText((Resolve-Path $mdFile), $newText, [Text.UTF8Encoding]::new($false))
            Write-Host "-- Última edición actualizada a $editDate"
        }
    }

    Set-SourceDate $mdFile

    # 3. KaTeX y estilo.
    Write-Host '-- KaTeX y reglas de estilo'
    $out = Invoke-Tool 'check-md' $NodeExe @('scripts/check-md.mjs', $mdFile)
    $out | ForEach-Object { Write-Host "  $_" }

    # 4. Markdown -> LaTeX.
    Use-TeX
    Write-Host "-- Pandoc: $mdFile -> $texFile"
    $out = Invoke-Tool 'pandoc (tex)' 'pandoc' ($PandocTex + @("--output=$texFile", $mdFile))
    Test-PandocWarnings 'pandoc (tex)' $out

    New-Item -ItemType Directory -Force 'doc_out/latex', 'doc_out/markdown' | Out-Null
    foreach ($d in $distros) {
        # Los PDF de doc_out/ salen siempre de la primera distribución (TeX Live salvo -TeX MiKTeX);
        # las demás solo validan. Así el PDF no depende de qué distribución compiló la última.
        $principal = ($d -eq $distros[0])

        # 5. LaTeX -> PDF.
        $pdf = Invoke-LatexCompile $texFile $d "build/latex/$d"
        if ($principal -and (Test-Path $pdf)) { Copy-Item $pdf "doc_out/latex/$n.pdf" -Force }

        # 6. Markdown -> PDF directo.
        $salida = if ($principal) { "doc_out/markdown/$n.pdf" } else { "build/pandoc/$d/$n.pdf" }
        New-Item -ItemType Directory -Force (Split-Path $salida) | Out-Null
        Write-Host "-- Pandoc ($d): $mdFile -> $salida"
        $out = Invoke-Tool "pandoc (pdf, $d)" 'pandoc' ($PandocCommon + @('--include-in-header=latex/pandoc-pdf-header.tex', '--pdf-engine=pdflatex', "--output=$salida", $mdFile))
        Test-PandocWarnings "pandoc (pdf, $d)" $out
    }

    # 7. Markdown -> HTML.
    Use-TeX
    $title = (Select-String -Path $mdFile -Pattern '^# (.+)$' | Select-Object -First 1).Matches[0].Groups[1].Value
    Write-Host "-- Pandoc: $mdFile -> $htmlFile"
    $out = Invoke-Tool 'pandoc (html)' 'pandoc' ($PandocCommon + @('--to=html5', '--toc', '--toc-depth=3', "--metadata=pagetitle:$title", "--mathjax=$MathJax", "--css=$Css", "--output=$htmlFile", $mdFile))
    Test-PandocWarnings 'pandoc (html)' $out

    # Los derivados quedan con la fecha del .md (ver la descripción).
    $mdLocalTime = (Get-Item $mdFile).LastWriteTime
    foreach ($derived in @($texFile, $htmlFile)) {
        if (Test-Path $derived) { (Get-Item $derived).LastWriteTime = $mdLocalTime }
    }
}

# 9. Portada de la web (html/index.html) con todos los documentos.
Update-IndiceWeb

Exit-WithSummary

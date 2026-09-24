# MCC

Apuntes de autoestudio para el Máster en Computación Cuántica, empezando por la asignatura Complementos de Mecánica Cuántica. Cada tema se escribe en Markdown y se publica también en LaTeX, PDF y HTML.

- Autor: Julián Calderón Almendros (julian.calderon.almendros at gmail.com, [@julian1c2a](https://github.com/julian1c2a))
- Licencia: [CC BY 4.0](LICENSE.md)

## Estructura

- `markdown/` — fuente de cada tema.
- `latex/` — LaTeX generado desde el Markdown.
- `html/` — páginas web generadas desde el Markdown, y su hoja de estilo.
- `doc_out/` — PDFs finales (`latex/` compilado desde el `.tex`, `markdown/` desde el `.md`).
- `figuras/` — figuras y diagramas (TikZ, draw.io/diagrams.net, imágenes exportadas).
- `scripts/` — sincronización, validación y publicación.
- `build/` — compilaciones intermedias (ignorado por git).

## Reglas y comandos

Las reglas de trabajo, la guía de estilo y los comandos están en [REGLAS.md](REGLAS.md). Comandos (en Claude Code o Copilot Chat):

| Comando | Qué hace |
| --- | --- |
| `GUARDA_y_SUBE` | Valida todo; si es correcto, commit y push en `main`; si no, guarda en la rama `edicion-actual`. |
| `SINCRONIZA` | Sincroniza cada documento desde el último archivo modificado (`.md` o `.tex`). |
| `SINCRONIZA_desde_MD` | Markdown → LaTeX, HTML y PDFs, sin errores ni advertencias. |
| `SINCRONIZA_desde_TEX` | Lleva al Markdown los cambios hechos a mano en un `.tex` y regenera todo. |
| `REPASA_BORRADOR` | Integra `BORRADOR.md` en los apuntes, sincroniza y muestra el resultado. |

Uso directo de los scripts:

```powershell
pwsh scripts/sincroniza.ps1 [-TeX TeXLive|MiKTeX|Both]
pwsh scripts/sincroniza-desde-md.ps1 [-Name <tema>] [-TeX TeXLive|MiKTeX|Both]
pwsh scripts/sincroniza-desde-tex.ps1 [-Fase Preparar|Verificar]
pwsh scripts/guarda-y-sube.ps1 -Mensaje "<mensaje>"
```

## Entorno LaTeX

- TeX Live (MSYS2 UCRT64): `/c/msys64/ucrt64/`
- MiKTeX: `/d/miktex/`

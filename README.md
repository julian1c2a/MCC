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
| `ESTADO` | Resumen: git, sincronización de cada documento, notas para la IA pendientes y borrador. |
| `ATIENDE_NOTAS` | Resuelve las notas `<!-- AI:... -->` pendientes y sincroniza. |
| `REVISA_RIGOR` | Revisión crítica (signos, dimensiones, pasos, hipótesis); informa antes de cambiar. |
| `NUEVO_TEMA` | Crea un tema nuevo con su bloque de autoría y lo sincroniza. |
| `FICHA_RESUMEN` | Genera la ficha de repaso de un tema. |
| `EJERCICIOS` | Añade ejercicios con solución completa a un tema. |
| `PUBLICA_WEB` | Publica la web en GitHub Pages (<https://julian1c2a.github.io/MCC/>). |

Uso directo de los scripts:

```powershell
pwsh scripts/sincroniza.ps1 [-TeX TeXLive|MiKTeX|Both]
pwsh scripts/sincroniza-desde-md.ps1 [-Name <tema>] [-TeX TeXLive|MiKTeX|Both]
pwsh scripts/sincroniza-desde-tex.ps1 [-Fase Preparar|Verificar]
pwsh scripts/guarda-y-sube.ps1 -Mensaje "<mensaje>"
pwsh scripts/estado.ps1 [-Fetch]
pwsh scripts/notas.ps1 [-Todas]
pwsh scripts/nuevo-tema.ps1 -Numero <n> -Titulo "<título>" [-Asignatura "<asignatura>"]
pwsh scripts/publica-web.ps1 -Mensaje "<mensaje>"
node scripts/busca-implicitos.mjs markdown/<tema>.md
```

## Entorno LaTeX

- TeX Live (MSYS2 UCRT64): `/c/msys64/ucrt64/`
- MiKTeX: `/d/miktex/`

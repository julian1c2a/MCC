# Reglas del proyecto MCC

Este documento recoge las reglas acordadas para el repositorio MCC: apuntes del máster en Computación Cuántica (empezando por la asignatura Complementos de Mecánica Cuántica). Se aplican tanto a quien edita a mano como a cualquier asistente de IA (Claude Code, GitHub Copilot, etc.).

Es un documento vivo: cada nueva regla que se acuerde se añade aquí, en la sección que corresponda.

## 1. Estructura del repositorio

| Ruta | Contenido | ¿Se edita a mano? |
| --- | --- | --- |
| `markdown/<nombre>.md` | **Fuente única** de cada documento. | Sí |
| `latex/<nombre>.tex` | LaTeX generado desde el Markdown con Pandoc. | No (ver regla 2.3) |
| `latex/pandoc-pdf-header.tex` | Cabecera que Pandoc inserta en el preámbulo LaTeX. | Sí |
| `html/<nombre>.html` | Página web generada desde el Markdown con Pandoc. | No |
| `html/tema-1.css` | Hoja de estilo de las páginas HTML. | Sí |
| `html/index.html` | Portada de la web con todos los documentos (se regenera en cada SINCRONIZA_desde_MD). | No |
| `markdown/<tema>-ficha.md`, `markdown/<tema>-ejercicios.md` | Ficha resumen y ejercicios de un tema (FICHA_RESUMEN, EJERCICIOS). Se sincronizan como cualquier documento. | Sí |
| `doc_out/latex/<nombre>.pdf` | PDF compilado desde el `.tex`. | No |
| `doc_out/markdown/<nombre>.pdf` | PDF compilado directamente desde el `.md`. | No |
| `build/` | Compilaciones intermedias (auxiliares, logs). Ignorado por git. | No |
| `scripts/` | Herramientas de sincronización y validación. | Sí |
| `figuras/` | Figuras y diagramas (TikZ, draw.io, imágenes exportadas). | Sí |
| `BORRADOR.md` | Borrador libre para REPASA_BORRADOR. Ignorado por git. | Sí |
| `.claude/commands/`, `.github/prompts/` | Los comandos de la sección 6 para Claude Code y GitHub Copilot. | Sí |
| `.github/workflows/pages.yml` | Publicación de `html/` y `doc_out/` en GitHub Pages. | Sí |

## 2. Sincronización y compilación

### 2.1. Principio

El Markdown es la fuente única. El `.tex`, el `.html` y los dos PDF son derivados y deben estar siempre sincronizados con él. Un cambio no está terminado hasta que todos los derivados se han regenerado y compilan **sin errores y sin advertencias**.

### 2.2. Regla para cambios en el Markdown

Siempre que se modifique un `markdown/<nombre>.md`, se aplica **SINCRONIZA_desde_MD** (sección 6.2) hasta que termine con `Todo correcto: sin errores ni advertencias.`

### 2.3. Regla para cambios en un `.tex`

Los `.tex` se generan desde el Markdown, por lo que una edición directa se perdería en la siguiente regeneración. Si se modifica un `latex/<nombre>.tex`, se aplica **SINCRONIZA_desde_TEX** (sección 6.3): se compila el `.tex` editado hasta que esté correcto, se porta el cambio al Markdown y desde ahí se regenera y valida todo.

`scripts/sincroniza-desde-md.ps1` se niega a sobrescribir un `.tex` o un `.html` más reciente que su Markdown, para no perder ediciones que aún no se han portado. `-Force` omite esa protección y descarta esas ediciones. (Los derivados se generan con la fecha de modificación de su Markdown, de modo que cualquier edición posterior los deja «más recientes».)

### 2.4. Qué se comprueba (`scripts/sincroniza-desde-md.ps1`)

1. Fórmulas: todas se renderizan con KaTeX (`scripts/check-md.mjs`).
2. Reglas de estilo automatizables (sección 4.3): punto de multiplicación Unicode, `\frac`, fórmulas display sin `aligned`.
3. Pandoc (`.md` → `.tex`, `.md` → PDF, `.md` → `.html`): ninguna línea `[WARNING]`.
4. LaTeX (`.tex` → PDF con latexmk + pdflatex, en `build/latex/<distribución>/`): ningún error (`! ...`), ningún `LaTeX/Package/Class Warning`, ningún `Overfull`/`Underfull \hbox`/`\vbox`, ningún `Missing character`.

Además de la comprobación automática, cuando se añaden o alargan fórmulas se revisa el PDF para confirmar que ninguna invade el margen.

Los PDF son reproducibles: la fecha interna es la de modificación del Markdown (`SOURCE_DATE_EPOCH`) y no llevan identificador aleatorio (`\pdftrailerid{}` en `latex/pandoc-pdf-header.tex`). Si el contenido no cambia, el PDF sale idéntico y git no lo ve modificado.

### 2.5. Entornos instalados

| Herramienta | Ruta | Uso |
| --- | --- | --- |
| TeX Live 2026 (MSYS2 UCRT64) | `C:\msys64\ucrt64\bin` (`/c/msys64/ucrt64/`) | Distribución por defecto: `pdflatex`, `latexmk`. |
| MiKTeX 26.5 | `D:\miktex\miktex\bin\x64` (`/d/miktex/`) | Alternativa: `-TeX MiKTeX`, o `-TeX Both` para compilar con ambas. |
| Pandoc 3.9 | `C:\msys64\usr\bin\pandoc.exe` | Conversión `.md` → `.tex` / PDF / `.html`. |
| Git for Windows | `C:\Program Files\Git\cmd\git.exe` | `git push` (su Git Credential Manager guarda las credenciales de GitHub; el `git` de MSYS2 no las tiene). |
| GitHub CLI | `C:\Program Files\GitHub CLI\gh.exe` | PUBLICA_WEB: activar GitHub Pages y lanzar el workflow. |
| Node.js 24 | `C:\msys64\ucrt64\bin\node.exe` | `scripts/check-md.mjs`, `scripts/busca-implicitos.mjs`. |
| KaTeX | Extensión de VS Code `goessner.mdmath` (o `KATEX_PATH`) | Validación de fórmulas. |

Notas:

- El motor es `pdflatex`. En TeX Live, los formatos de XeLaTeX y LuaLaTeX están dañados (comprobado el 23-09-2026); no se usan.
- `latexmk` necesita la carpeta `bin` de la distribución en el `PATH` (usa Perl); el script lo configura.
- LaTeX Workshop (VS Code) compila en `build/latex/workshop/` (`.vscode/settings.json`), nunca junto a las fuentes.

### 2.6. Git

- Remoto `origin` (`github.com/julian1c2a/MCC`).
- `main` apunta siempre al último estado **completamente correcto** (todo sincronizado, sin errores ni advertencias). Solo avanza mediante GUARDA_y_SUBE.
- `edicion-actual` guarda el trabajo en curso que aún no pasa la validación. GUARDA_y_SUBE la crea cuando hace falta y la integra en `main` (un único commit) y la borra cuando todo es correcto.
- Un commit incluye el Markdown junto con sus derivados ya regenerados (`.tex`, `.html`, PDFs de `doc_out/`), nunca el contenido de `build/` ni `BORRADOR.md`.
- Mensajes de commit en español, descriptivos.
- La IA no hace commit ni push salvo con GUARDA_y_SUBE o cuando se le pida expresamente.

## 3. Redacción

- Idioma: español.
- Tono neutro y académico, sin carga emocional:
  - sin exclamaciones ni adjetivos valorativos («maravilloso», «hermoso», «espectacular», «magistral», «elegante»...);
  - sin coloquialismos («escupir», «el truco», «engañar a la ecuación»...);
  - sin preguntas retóricas como encabezados ni apelaciones al lector («Imagina...»);
  - se admite la primera persona del plural académica («obtenemos», «definimos»).
- Autoexplicativo y detallado:
  - cada paso de una deducción se muestra o se justifica (qué regla, identidad o hipótesis se usa);
  - toda constante o símbolo nuevo se define al introducirlo;
  - se explicitan las hipótesis (regularidad, condiciones de contorno, signos que se eligen);
  - si una letra cambia de significado (por ejemplo, $k$ como constante elástica y como número de onda), se avisa.
- Precisión: «estacionario» y no «mínimo» cuando solo se garantiza estacionariedad; no afirmar más de lo que se demuestra.

## 4. Formato

### 4.1. Estructura

- Cada documento empieza con un bloque YAML con el autor (se usa para los metadatos del PDF y del HTML), seguido del título `#` y del bloque de autoría:

  ```markdown
  ---
  author: "Julián Calderón Almendros"
  ---

  # Tema N. Título

  * **Asignatura:** Complementos de Mecánica Cuántica (Máster en Computación Cuántica)
  * **Propósito:** apuntes de autoestudio elaborados para preparar la asignatura.
  * **Última edición:** AAAA-MM-DD
  * **Autor:** Julián Calderón Almendros
  * **Correo electrónico:** julian.calderon.almendros at gmail.com
  * **GitHub:** [\@julian1c2a](https://github.com/julian1c2a)
  * **Proyecto:** <https://github.com/julian1c2a/MCC>
  * **Licencia:** [Creative Commons Reconocimiento 4.0 Internacional (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.es). ...
  ```

  - La fecha de «Última edición» no se edita a mano: SINCRONIZA_desde_MD la sustituye por la fecha de modificación del `.md`, y falla si la línea no existe.
  - El correo se escribe con «at» en lugar de «@» para dificultar su recolección automática.
  - La licencia del proyecto es CC BY 4.0 (`LICENSE.md`): cualquiera puede copiar, modificar y reutilizar el material con cualquier fin, siempre que reconozca la autoría.
- Encabezados numerados: `## 1.`, `### 1.1.`, `#### 1.1.1.`.
- Subapartados auxiliares dentro de una sección: `####` sin número (por ejemplo, `#### Primer método: ...`). No se usan pseudotítulos en texto plano.

### 4.2. Fórmulas: aspectos generales

- Fórmulas en línea: `$...$`.
- Fórmulas display: `$$` en línea propia y contenido envuelto en `aligned`, sin sangría (cuatro espacios convierten el bloque en código):

  ```markdown
  $$
  \begin{aligned}
  E &= T + V
  \end{aligned}
  $$
  ```

  Dentro de una lista, la fórmula lleva la sangría del elemento de la lista.
- Fracciones: siempre `\dfrac`, nunca `\frac`.
- Una fórmula que invade el margen del PDF se parte en varias líneas con `&` y `\\` dentro de `aligned`.

### 4.3. Multiplicación: siempre `\cdot`

Toda multiplicación se escribe explícitamente con `\cdot`, rodeado de espacios. Nunca se deja implícita la yuxtaposición ni se usa el carácter Unicode `⋅`.

| Correcto | Incorrecto |
| --- | --- |
| `m \cdot \ddot{x}` | `m\ddot{x}` |
| `2 \cdot \pi` | `2\pi` |
| `\dfrac{1}{2} \cdot m \cdot v^2` | `\dfrac{1}{2}mv^2` |
| `A \cdot e^{i \cdot (\omega \cdot t - k \cdot x)}` | `Ae^{i(\omega t - kx)}` |
| `r \cdot (1 - \cos\theta)` | `r(1 - \cos\theta)` |
| `\dfrac{\partial L}{\partial q_i} \cdot dq_i` | `\dfrac{\partial L}{\partial q_i} dq_i` |

La regla rige también dentro de argumentos, exponentes, numeradores y denominadores: `\sin\left(\dfrac{m \cdot \pi \cdot x}{L_x}\right)`.

No son multiplicaciones y, por tanto, no llevan `\cdot`:

- Aplicación de una función a su argumento: `f(x)`, `y(x,t)`, `\sin(k \cdot x)`, `\cos\theta`, `J_m(x)`, `\sqrt{x}`.
- Aplicación de un operador a su operando (sección 4.4): `\hat{H}\Psi`, `\nabla^2\Psi`, `\delta f`, `\partial_t f`, `\dfrac{d}{dx}\left(\dfrac{\partial F}{\partial y'}\right)`, `\Re\{z\}`, `\sum_i a_i`.
- La notación de derivada: `\dfrac{d^2y}{dt^2}`, `\dfrac{\partial^2 \Psi}{\partial x^2}`.
- El diferencial de una integral, separado con `\,`: `\int_a^b f(x)\,dx`. Fuera de una integral, un diferencial es un factor más y lleva `\cdot`: `dH = \dot{q}_i \cdot dp_i + \dots`.
- Índices y subíndices: `A_{mn}`, `\omega_{mnp}`, `q_i`.
- El signo menos: `-k^2`.

Producto escalar de vectores (en negrita): también `\cdot`, `\mathbf{k} \cdot \mathbf{r}`. Producto vectorial: `\times`.

La regla de `⋅` se comprueba automáticamente. La de la multiplicación implícita no admite una comprobación automática fiable y se revisa a mano en cada fórmula nueva o modificada.

### 4.4. Operadores

- Los operadores abstractos, en particular los de la mecánica cuántica, se marcan con gorro: `\hat{H}`, `\hat{p}`, `\hat{x}`, `\hat{L}_z`.
- Los operadores diferenciales y variacionales estándar ya se reconocen por su símbolo y no llevan gorro: `\partial`, `\nabla`, `\nabla^2`, `\dfrac{d}{dx}`, `\delta`.
- Un operador aplicado a su operando se escribe sin `\cdot`: `\hat{H}\Psi`, `\nabla^2\Psi`, `\hat{p}\,\psi(x)`. La composición de operadores también: `\hat{A}\hat{B}`.
- Si un factor multiplica a un operador aplicado, ese producto sí lleva `\cdot`: `v^2 \cdot \nabla^2\Psi`, `\dfrac{1}{r^2} \cdot \dfrac{\partial}{\partial r}\left(r^2 \cdot \dfrac{\partial\Psi}{\partial r}\right)`.

## 5. Notas para la IA dentro del Markdown

Para dejar tareas a la IA dentro de un documento se usan comentarios HTML, que no aparecen en las versiones renderizadas:

```markdown
<!-- AI:T1-03
Tarea: qué hay que hacer.
Contexto: (opcional) dónde o con qué notación.
Criterio de terminación: (opcional) cuándo se considera hecho.
Estado: pendiente.
-->
```

- El identificador es `AI:T<tema>-<número de dos cifras>`.
- Para pedir que se resuelva: «Atiende AI:T1-03».
- Al terminar, la IA cambia `Estado: pendiente.` por `Estado: hecho.` y conserva el comentario.

## 6. Comandos

Cuando el usuario escribe uno de estos nombres (solo, como `/NOMBRE` o como `cmd: NOMBRE`, en Claude Code o en Copilot Chat), la IA ejecuta el procedimiento correspondiente. Los nombres no distinguen mayúsculas de minúsculas (`GUARDA_Y_SUBE` es `GUARDA_y_SUBE`). Si un mensaje contiene varios puntos numerados (`[[1.]]`, `[[2.]]`...), se atienden en ese orden. Los pasos mecánicos están en `scripts/`; la IA hace los que requieren criterio (redactar, portar, corregir).

Antes de ejecutar un comando, hay que guardar los archivos abiertos en el editor. Después de un comando que modifica un `.md`, hay que recargar su pestaña si estaba abierta: guardar desde una pestaña con una versión anterior sobrescribe los cambios (ocurrió el 24-09-2026).

### 6.1. GUARDA_y_SUBE [mensaje]

Publica el trabajo si todo es correcto; si no, lo guarda sin tocar `main`.

1. La IA redacta el mensaje de commit a partir de `git diff` (o usa el que se le dé).
2. Ejecuta `pwsh scripts/guarda-y-sube.ps1 -Mensaje "<mensaje>"`, que:
   - valida todo con SINCRONIZA en TeX Live y MiKTeX (`-TeX Both`);
   - **si es correcto**: commit en `main` y `git push`. Si se estaba en `edicion-actual`, integra la rama en `main` como un único commit, hace push y borra la rama (local y remota);
   - **si hay problemas**: commit `WIP: <mensaje>` en `edicion-actual` (creándola desde `main` si hace falta) y push de esa rama. `main` no cambia.
3. La IA informa del resultado y, si hubo problemas, los enumera y propone cómo corregirlos.

### 6.2. SINCRONIZA_desde_MD [nombre]

Markdown → `.tex`, `.html` y PDFs, con todas las comprobaciones de la sección 2.4.

1. Ejecutar `pwsh scripts/sincroniza-desde-md.ps1` (opcional: `-Name <nombre>`, `-TeX Both`).
2. Si hay problemas, corregirlos **en el Markdown** y repetir hasta `Todo correcto: sin errores ni advertencias.`
3. Si se han añadido o alargado fórmulas, revisar las páginas afectadas del PDF.

### 6.3. SINCRONIZA_desde_TEX [nombre]

`.tex` editado a mano → Markdown → `.tex`, `.html` y PDFs.

1. `pwsh scripts/sincroniza-desde-tex.ps1` (fase Preparar). Detecta los `.tex` más recientes que su Markdown, los compila tal como están y muestra exactamente qué se ha cambiado a mano respecto al Markdown. Si el `.tex` no compila limpio, se corrige el `.tex` y se repite.
2. Trasladar esos cambios al Markdown, con la sintaxis y el estilo del proyecto.
3. `pwsh scripts/sincroniza-desde-tex.ps1 -Fase Verificar`. Regenera y valida todo desde el Markdown y comprueba que el `.tex` regenerado reproduce la edición manual (ignorando espacios y saltos de línea). Si quedan diferencias, se ajusta el Markdown y se repite. Si una diferencia no es expresable en Markdown, se explica al usuario.

### 6.4. REPASA_BORRADOR

Integra en los apuntes lo que el usuario ha escrito en `BORRADOR.md` (raíz del repositorio, ignorado por git).

1. Leer `BORRADOR.md`. La línea `Destino:` indica el documento y la sección; si falta, la IA lo deduce del contenido y, si hay duda, pregunta.
2. Redactar el contenido en el Markdown de destino aplicando todas las reglas (secciones 3 y 4): tono neutro, pasos intermedios, `\cdot`, `\dfrac`, `aligned`, numeración de secciones. Las instrucciones del borrador dirigidas a la IA se siguen, pero no se copian.
3. Aplicar SINCRONIZA_desde_MD hasta que todo sea correcto.
4. Mostrar el resultado: abrir la página HTML en la sección modificada y resumir qué se ha añadido o cambiado y dónde.
5. Archivar el borrador procesado en `build/borradores/BORRADOR-<fecha-hora>.md` y dejar `BORRADOR.md` con la plantilla vacía.

### 6.5. SINCRONIZA

Sincroniza cada documento en la dirección que corresponde según qué archivo ha cambiado por último. Es la forma habitual de sincronizar.

1. Ejecutar `pwsh scripts/sincroniza.ps1` (opcional: `-TeX Both`). Para cada documento:
   - si el `.md` es el más reciente (o igual de reciente), aplica SINCRONIZA_desde_MD;
   - si el `.tex` es más reciente que el `.md`, aplica la fase Preparar de SINCRONIZA_desde_TEX y termina con código 2;
   - si hay una fase Preparar anterior pendiente (copia en `build/sync/`), aplica la fase Verificar.
2. Con código 2, la IA porta al Markdown los cambios mostrados y vuelve a ejecutar `scripts/sincroniza.ps1`, que ahora hará la fase Verificar.
3. Se repite hasta que termine sin problemas.

### 6.6. ESTADO

Resumen del proyecto, sin modificar nada.

1. Ejecutar `pwsh scripts/estado.ps1` (con `-Fetch` para consultar antes GitHub). Muestra:
   - la rama y su posición respecto a `origin`;
   - los cambios sin guardar;
   - si existe `edicion-actual`;
   - el estado de sincronización de cada documento;
   - las notas para la IA pendientes;
   - si `BORRADOR.md` tiene contenido.
2. La IA lo resume y propone el siguiente comando útil (por ejemplo, SINCRONIZA si hay documentos sin sincronizar, o GUARDA_y_SUBE si hay cambios correctos sin subir).

### 6.7. ATIENDE_NOTAS [identificadores]

Resuelve las notas para la IA pendientes (sección 5): todas o solo las indicadas.

1. Listarlas con `pwsh scripts/notas.ps1`.
2. Resolverlas por orden de identificador, siguiendo su Tarea, Contexto y Criterio de terminación, y con todas las reglas de redacción y formato.
3. Marcar cada una con `Estado: hecho.` y conservar el comentario.
4. Aplicar SINCRONIZA hasta que todo sea correcto.
5. Resumir qué se ha hecho en cada nota. Una nota ambigua no se resuelve a ciegas: se pregunta.

### 6.8. REVISA_RIGOR [documento] [sección]

Revisión crítica del contenido. Primero se informa y solo después se cambia lo que el usuario apruebe.

1. Ejecutar `node scripts/busca-implicitos.mjs markdown/<documento>.md` para localizar posibles multiplicaciones implícitas. Es una heurística: cada candidato se revisa a mano. La forma `r(1-\cos\theta)` (símbolo seguido de paréntesis) no se puede distinguir automáticamente de una función aplicada y se revisa leyendo.
2. Leer la parte indicada (por defecto, el documento entero) y comprobar:
   - signos, factores numéricos e índices;
   - coherencia dimensional de cada igualdad;
   - pasos omitidos o no justificados;
   - hipótesis no declaradas (regularidad, condiciones de contorno, convergencia);
   - símbolos usados antes de definirse o con dos significados;
   - referencias cruzadas a secciones que no existen;
   - afirmaciones físicas inexactas o demasiado generales;
   - casos límite que permiten comprobar un resultado.
3. Escribir el informe en `build/revisiones/<documento>-<fecha>.md` y resumirlo en el chat. Cada hallazgo va numerado, con su gravedad (error, imprecisión, falta de detalle, estilo), su ubicación y la corrección propuesta.
4. No cambiar nada hasta que el usuario indique qué aplicar («aplica 1, 3 y 5», «aplica todo»). Después, aplicar SINCRONIZA.

### 6.9. NUEVO_TEMA n "título" [asignatura]

1. Ejecutar `pwsh scripts/nuevo-tema.ps1 -Numero <n> -Titulo "<título>"` (y `-Asignatura "<asignatura>"` si no es Complementos de Mecánica Cuántica). Crea `markdown/Tema-<n>-<Titulo-Sin-Tildes>.md` con el bloque YAML, el título y el bloque de autoría, y lo sincroniza.
2. Si el usuario da un índice o un temario, la IA crea las secciones numeradas correspondientes y vuelve a aplicar SINCRONIZA.

### 6.10. FICHA_RESUMEN [tema]

Hoja de repaso de un tema, en `markdown/<tema>-ficha.md`.

1. Leer el tema completo.
2. Escribir la ficha con el título `# Tema n. <título>: ficha resumen` y el bloque de autoría del tema. Contenido, en este orden:
   - notación (tabla de símbolos y su significado);
   - definiciones clave;
   - resultados y ecuaciones principales, cada una con la referencia a su apartado del tema («véase 3.1.2»);
   - hipótesis de validez de cada resultado;
   - errores frecuentes y distinciones importantes.
3. Debe ser breve (orientativamente, no más de 4 o 5 páginas de PDF) y no introducir nada que no esté en el tema.
4. La ficha se regenera entera cada vez a partir del tema; lo que se quiera conservar debe estar en el tema.
5. Aplicar SINCRONIZA y mostrar el resultado (página HTML).

### 6.11. EJERCICIOS [tema] [cantidad] [nivel]

Ejercicios con solución completa, en `markdown/<tema>-ejercicios.md`.

1. Si el archivo no existe, se crea con el título `# Tema n. <título>: ejercicios` y el bloque de autoría. Si existe, los ejercicios nuevos se añaden a continuación sin modificar los anteriores, siguiendo la numeración.
2. Cada ejercicio indica su nivel (básico, intermedio o avanzado) y el apartado del tema en que se basa. Por defecto se crean 5, de niveles variados.
3. Los enunciados van en la sección `## Enunciados` y las soluciones en `## Soluciones`, para poder intentarlos antes de ver la respuesta.
4. Cada solución desarrolla todos los pasos con las reglas del proyecto y termina con una comprobación: dimensiones, un caso límite o una sustitución en la ecuación de partida.
5. Aplicar SINCRONIZA y mostrar el resultado.

### 6.12. PUBLICA_WEB [mensaje]

Publica la web en GitHub Pages: <https://julian1c2a.github.io/MCC/>.

1. La IA redacta el mensaje de commit, como en GUARDA_y_SUBE.
2. Ejecutar `pwsh scripts/publica-web.ps1 -Mensaje "<mensaje>"`, que:
   - activa GitHub Pages la primera vez;
   - ejecuta GUARDA_y_SUBE y, si falla, no publica;
   - lanza el workflow `.github/workflows/pages.yml`, espera a que termine y muestra la URL.
3. Una vez activado Pages, cada GUARDA_y_SUBE que cambie `html/` o `doc_out/` publica la web automáticamente; PUBLICA_WEB sirve para forzar la publicación y comprobarla.

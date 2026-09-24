# Instrucciones para GitHub Copilot

Antes de modificar cualquier archivo de este repositorio, lee y aplica `REGLAS.md` (en la raíz). En resumen:

- `markdown/<nombre>.md` es la fuente única; `latex/`, `html/` y `doc_out/` son derivados.
- Comandos (REGLAS.md, sección 6; también disponibles como prompts en `.github/prompts/`): **GUARDA_y_SUBE**, **SINCRONIZA**, **SINCRONIZA_desde_MD**, **SINCRONIZA_desde_TEX**, **REPASA_BORRADOR**, **ESTADO**, **ATIENDE_NOTAS**, **REVISA_RIGOR**, **NUEVO_TEMA**, **FICHA_RESUMEN**, **EJERCICIOS**, **PUBLICA_WEB**. Cuando el usuario escriba uno de esos nombres, ejecuta el procedimiento de REGLAS.md.
- Tras cualquier cambio en un Markdown se aplica SINCRONIZA_desde_MD hasta obtener `Todo correcto: sin errores ni advertencias.`; tras editar un `.tex`, SINCRONIZA_desde_TEX.
- `main` solo avanza con GUARDA_y_SUBE y siempre queda en un estado completamente correcto.
- Estilo: tono neutro y autoexplicativo; fórmulas display en `$$` + `aligned`; `\dfrac`; toda multiplicación con `\cdot`; operadores abstractos con gorro (`\hat{H}`) y aplicados sin `\cdot`.

Si se acuerda una regla nueva, se añade a `REGLAS.md`, no a este archivo.

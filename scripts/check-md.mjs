// Comprueba las fórmulas de un Markdown del proyecto MCC.
//
// Uso: node scripts/check-md.mjs <archivo.md> [<archivo.md> ...]
//
// 1. Renderiza con KaTeX cada fórmula ($...$ y $$...$$) y falla si alguna
//    no compila.
// 2. Aplica las reglas de estilo verificables automáticamente (REGLAS.md):
//    - no se usa el carácter Unicode "⋅" (U+22C5) ni "·" (U+00B7): la
//      multiplicación se escribe siempre \cdot;
//    - no se usa \frac: se usa \dfrac;
//    - toda fórmula display ($$ en línea propia) envuelve su contenido en
//      \begin{aligned} ... \end{aligned}.
//
// KaTeX se busca en KATEX_PATH o, si no está definida, en las extensiones de
// VS Code (goessner.mdmath, markdown-math...).

import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);

function findKatex() {
  if (process.env.KATEX_PATH && fs.existsSync(process.env.KATEX_PATH)) {
    return process.env.KATEX_PATH;
  }
  const extDir = path.join(os.homedir(), ".vscode", "extensions");
  if (fs.existsSync(extDir)) {
    for (const ext of fs.readdirSync(extDir).sort().reverse()) {
      const candidate = path.join(extDir, ext, "node_modules", "katex", "dist", "katex.js");
      if (fs.existsSync(candidate)) return candidate;
    }
  }
  return null;
}

const katexPath = findKatex();
if (!katexPath) {
  console.error("ERROR: no se encuentra katex.js. Define KATEX_PATH.");
  process.exit(2);
}
const katex = require(katexPath);

const files = process.argv.slice(2);
if (files.length === 0) {
  console.error("Uso: node scripts/check-md.mjs <archivo.md> ...");
  process.exit(2);
}

let failures = 0;

for (const file of files) {
  const text = fs.readFileSync(file, "utf8").replace(/\r\n/g, "\n");
  const lineAt = (offset) => text.slice(0, offset).split("\n").length;
  const errors = [];
  let checked = 0;

  const check = (math, offset, display) => {
    checked++;
    try {
      katex.renderToString(math, { throwOnError: true, displayMode: display });
    } catch (error) {
      errors.push(`línea ${lineAt(offset)}: KaTeX: ${error.message}`);
    }
    if (/[⋅·]/.test(math)) {
      errors.push(`línea ${lineAt(offset)}: estilo: punto Unicode de multiplicación; usa \\cdot`);
    }
    if (/(?<!d)\\frac\b/.test(math)) {
      errors.push(`línea ${lineAt(offset)}: estilo: \\frac; usa \\dfrac`);
    }
    if (display && !/^\s*\\begin\{aligned\}[\s\S]*\\end\{aligned\}\s*$/.test(math)) {
      errors.push(`línea ${lineAt(offset)}: estilo: fórmula display sin \\begin{aligned}...\\end{aligned}`);
    }
  };

  // Fórmulas display. Se sustituyen por espacios para no volver a verlas
  // al buscar las fórmulas en línea.
  const withoutDisplay = text.replace(/\$\$([\s\S]*?)\$\$/g, (whole, math, offset) => {
    check(math, offset, true);
    return " ".repeat(whole.length);
  });

  // Fórmulas en línea.
  for (const match of withoutDisplay.matchAll(/(?<!\$)\$([^$\n]+?)\$(?!\$)/g)) {
    check(match[1], match.index, false);
  }

  // Punto de multiplicación Unicode fuera de fórmulas (texto normal).
  withoutDisplay.split("\n").forEach((line, i) => {
    if (/[⋅]/.test(line.replace(/(?<!\$)\$[^$\n]+?\$(?!\$)/g, ""))) {
      errors.push(`línea ${i + 1}: estilo: carácter "⋅" fuera de una fórmula`);
    }
  });

  console.log(`${file}: ${checked} fórmulas comprobadas, ${errors.length} problemas`);
  for (const e of errors) console.error(`  ${e}`);
  failures += errors.length;
}

process.exit(failures ? 1 : 0);

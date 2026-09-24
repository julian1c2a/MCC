// Busca en las fórmulas de un Markdown posibles multiplicaciones implícitas (sin \cdot).
//
// Uso: node scripts/busca-implicitos.mjs <archivo.md> [...]
//
// Es una heurística para REVISA_RIGOR (REGLAS.md, 6.8): lista candidatos para revisar a
// mano, no errores, y siempre termina con código 0. Descarta los casos que la regla de
// REGLAS.md 4.3 considera correctos sin \cdot: aplicación de funciones y operadores,
// límites de \int y \sum, diferenciales de integración, notación de derivada.

import fs from "node:fs";

const greek = "alpha|beta|gamma|delta|epsilon|varepsilon|zeta|eta|theta|kappa|lambda|mu|nu|xi|pi|rho|sigma|tau|phi|varphi|chi|psi|omega|Gamma|Lambda|Phi|Psi|Omega|ell";
const valueCmd = `sqrt|dfrac|sin|cos|tan|sinh|cosh|exp|ln|log|hat|dot|ddot|mathbf|tilde|${greek}`;
const bigOps = /\\(int|iint|oint|sum|prod|lim)\s*$/;
const accents = /\\(dot|ddot|hat|tilde|bar|vec|mathbf|mathcal|mathrm)\s*$/;

// Índice de la llave "{" que abre la "}" situada en close.
function openingBrace(s, close) {
  let depth = 0;
  for (let i = close; i >= 0; i--) {
    if (s[i] === "}" && s[i - 1] !== "\\") depth++;
    else if (s[i] === "{" && s[i - 1] !== "\\") { depth--; if (depth === 0) return i; }
  }
  return -1;
}

// ¿La "}" en close cierra el denominador de un \dfrac que es una derivada u operador?
function derivativeFraction(s, close) {
  const denOpen = openingBrace(s, close);
  if (denOpen <= 0 || s[denOpen - 1] !== "}") return false;
  const numOpen = openingBrace(s, denOpen - 1);
  if (numOpen < 0 || !/\\dfrac\s*$/.test(s.slice(0, numOpen))) return false;
  const num = s.slice(numOpen + 1, denOpen - 1).trim();
  return /^(\\partial|d)(\^\{?\d+\}?)?(\s|\\|[A-Za-z]|$)/.test(num);
}

function isFalsePositive(s, i, next) {
  const after = s.slice(i + 1);
  if (/^\s*(\\,\s*)?d[A-Za-z\\]/.test(after) && /^\s*\\,/.test(after)) return true; // \,dx
  if (s[i] !== "}") return false;
  const open = openingBrace(s, i);
  if (open < 0) return false;
  const before = s.slice(0, open);
  if (/[_^]\s*$/.test(before)) {
    // Grupo de subíndice o superíndice: buscar la base.
    let base = before.replace(/[_^]\s*$/, "");
    base = base.replace(/([_^](\{[^{}]*\}|\S))+\s*$/, "");
    if (bigOps.test(base)) return true;             // límites de \int, \sum...
    if (next === "(") return true;                  // y_{real}(x), F^{**}(v)
    return false;
  }
  if (accents.test(before) && next === "(") return true; // \dot{k}(t), \mathbf{A}(\mathbf{r},t)
  if (derivativeFraction(s, i)) return true;             // \dfrac{\partial}{\partial t}(...)
  if (/\\(begin|end)\s*$/.test(before)) return true;
  return false;
}

for (const file of process.argv.slice(2)) {
  const text = fs.readFileSync(file, "utf8").replace(/\r\n/g, "\n");
  const lineAt = (o) => text.slice(0, o).split("\n").length;
  const segs = [];
  const rest = text.replace(/\$\$([\s\S]*?)\$\$/g, (w, m, o) => { segs.push([m, o + 2]); return " ".repeat(w.length); });
  for (const m of rest.matchAll(/(?<!\$)\$([^$\n]+?)\$(?!\$)/g)) segs.push([m[1], m.index + 1]);

  const hits = [];
  for (const [math, offset] of segs) {
    const m = math.replace(/\\text\{[^}]*\}/g, (w) => " ".repeat(w.length));

    // 1. Letras o dígitos pegados que no forman un comando: "kx", "2A", "mv".
    const plain = m
      .replace(/\\(begin|end)\{[a-z]*\}/g, (w) => " ".repeat(w.length))
      .replace(/\\[a-zA-Z]+/g, (w) => " ".repeat(w.length))
      .replace(/_\{[^}]*\}|_[a-zA-Z0-9]/g, (w) => " ".repeat(w.length))
      .replace(/\bd\^?\d*[a-zA-Z]\b/g, (w) => " ".repeat(w.length))
      .replace(/\^\{[^}]*\}|\^\d/g, (w) => " ".repeat(w.length));
    for (const g of plain.matchAll(/(?<![a-zA-Z])[a-zA-Z0-9][a-zA-Z]+|[0-9][a-zA-Z]/g)) {
      hits.push([offset + g.index, g[0]]);
    }

    // 2. Cierre de grupo seguido de un factor: "}\sin", ")x", "]e", "}2".
    const re = new RegExp(String.raw`[)}\]](\s*)(?:\\,\s*)?([a-zA-Z0-9(]|\\(?:${valueCmd})\b)`, "g");
    for (const g of m.matchAll(re)) {
      const next = g[2][0];
      if (isFalsePositive(m, g.index, next)) continue;
      hits.push([offset + g.index, g[0]]);
    }

    // 3. Variable con subíndice simple seguida de un factor: "p_i \dot{q}_i", "A_1 \cos".
    const re3 = new RegExp(String.raw`(?:(?<![\\a-zA-Z])[a-zA-Z]|\\(?:${greek}))_[a-zA-Z0-9]\s+([a-zA-Z]|\\(?:${valueCmd})\b)`, "g");
    for (const g of m.matchAll(re3)) {
      if (/^d[A-Za-z\\]/.test(m.slice(g.index + g[0].length - g[1].length)) && /\\,\s*$/.test(m.slice(0, g.index + g[0].length - g[1].length))) continue;
      hits.push([offset + g.index, g[0]]);
    }
  }

  hits.sort((a, b) => a[0] - b[0]);
  const lines = text.split("\n");
  for (const [o, s] of hits) {
    const line = lineAt(o);
    const src = lines[line - 1].trim();
    console.log(`${file}:${line}: «${s.replace(/\s+/g, " ").trim()}»  ${src.length > 110 ? src.slice(0, 110) + "…" : src}`);
  }
  console.log(`${file}: ${hits.length} candidato(s) a multiplicación implícita.`);
}

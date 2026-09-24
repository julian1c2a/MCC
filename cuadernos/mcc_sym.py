"""Herramientas simbólicas comunes para los cuadernos del proyecto MCC.

Se importan desde cualquier cuaderno con ``from mcc_sym import *``. Reglas de uso en
REGLAS.md, sección 7.

- ``latex_mcc``, ``mostrar``: salida en LaTeX con el estilo del proyecto (``\\cdot``,
  ``\\dfrac``, ``\\arcsin``), lista para copiar al Markdown.
- ``comprobar``, ``es_cero``: comprobaciones que hacen fallar el cuaderno si no se cumplen
  (``scripts/comprueba-cuadernos.ps1`` los ejecuta todos).
- ``legendre``, ``legendre_multi``, ``hessiana``: transformada de Legendre.
- ``euler_lagrange``, ``hamiltoniano``: mecánica analítica.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field

import sympy as sp

__all__ = [
    "sp", "latex_mcc", "mostrar", "es_cero", "comprobar",
    "hessiana", "legendre", "legendre_multi", "Legendre",
    "euler_lagrange", "hamiltoniano",
]


# --- Salida ---------------------------------------------------------------------------

def latex_mcc(expr) -> str:
    """LaTeX de ``expr`` con las convenciones de REGLAS.md 4.3: ``\\cdot`` en toda
    multiplicación, ``\\dfrac`` en lugar de ``\\frac`` y ``\\arcsin`` en lugar de ``\\operatorname{asin}``."""
    s = sp.latex(expr, mul_symbol="dot", inv_trig_style="full")
    return re.sub(r"\\frac(?=\{)", r"\\dfrac", s)


def _en_ipython() -> bool:
    try:
        from IPython import get_ipython
        return get_ipython() is not None
    except ImportError:
        return False


def mostrar(nombre: str, expr) -> None:
    """Muestra ``nombre = expr``: renderizado en la ventana interactiva de VS Code y como
    LaTeX de texto en una ejecución normal (scripts/comprueba-cuadernos.ps1)."""
    texto = f"{nombre} = {latex_mcc(expr)}" if nombre else latex_mcc(expr)
    if _en_ipython():
        from IPython.display import Math, display
        display(Math(texto))
    else:
        print(texto)


# --- Comprobaciones -------------------------------------------------------------------

def es_cero(expr) -> bool:
    """True si ``expr`` se simplifica a 0 (prueba varias estrategias de simplificación)."""
    expr = sp.sympify(expr)
    for f in (sp.simplify, lambda e: sp.simplify(sp.expand(e)), sp.trigsimp,
              lambda e: sp.simplify(sp.powsimp(sp.expand_log(e, force=True), force=True))):
        try:
            if f(expr) == 0:
                return True
        except Exception:  # noqa: BLE001 - una estrategia puede no aplicarse
            continue
    return False


def comprobar(condicion, mensaje: str) -> None:
    """Comprueba una condición del cuaderno. ``condicion`` puede ser un booleano o una
    expresión de SymPy que debe ser 0. Si falla, el cuaderno se detiene con AssertionError."""
    if isinstance(condicion, sp.logic.boolalg.Boolean) or not isinstance(condicion, sp.Basic):
        ok = bool(condicion)       # desigualdades de SymPy (a < b) y booleanos de Python
    else:
        ok = es_cero(condicion)
    if not ok:
        raise AssertionError(f"Comprobación fallida: {mensaje}")
    print(f"✓ {mensaje}")


# --- Transformada de Legendre ---------------------------------------------------------

def hessiana(f, variables):
    """Matriz hessiana de ``f`` respecto de ``variables`` y su determinante simplificado."""
    H = sp.hessian(f, variables)
    return H, sp.simplify(H.det())


@dataclass
class Legendre:
    """Resultado de una transformada de Legendre g = Σ p_i·x_i − f."""
    f: sp.Expr
    variables: tuple
    conjugadas: tuple
    pendientes: tuple          # p_i = ∂f/∂x_i, como funciones de las x
    inversa: dict              # x_i como funciones de las p (rama elegida)
    g: sp.Expr                 # transformada, en función de las p y de las variables pasivas
    ramas: list = field(default_factory=list)  # todas las soluciones halladas (una variable)

    def comprobar(self, pasivas=()) -> None:
        """Comprueba ∂g/∂p_i = x_i y, para cada variable pasiva t, ∂g/∂t = −∂f/∂t."""
        for x, p in zip(self.variables, self.conjugadas):
            comprobar(sp.diff(self.g, p) - self.inversa[x], f"∂g/∂{p} = {x}")
        for t in pasivas:
            comprobar(sp.diff(self.g, t) + sp.diff(self.f, t).subs(self.inversa),
                      f"∂g/∂{t} = −∂f/∂{t} (variable pasiva)")


def legendre(f, x, p, rama=None) -> Legendre:
    """Transformada de Legendre de ``f`` respecto de una variable ``x``, con conjugada ``p``.

    Resuelve p = ∂f/∂x para x. Si hay varias soluciones (ramas), ``rama`` elige una: un
    índice de la lista ``ramas`` o directamente la expresión x(p). Las demás variables de
    ``f`` actúan como parámetros (variables pasivas).
    """
    pendiente = sp.diff(f, x)
    ramas = sp.solve(sp.Eq(p, pendiente), x)
    if rama is None:
        if len(ramas) != 1:
            raise ValueError(f"p = ∂f/∂x tiene {len(ramas)} soluciones: {ramas}. Elige una con rama=.")
        xp = ramas[0]
    elif isinstance(rama, int):
        xp = ramas[rama]
    else:
        xp = sp.sympify(rama)
    g = sp.simplify(p * xp - f.subs(x, xp))
    return Legendre(f, (x,), (p,), (pendiente,), {x: xp}, g, ramas)


def legendre_multi(f, variables, conjugadas, inversa=None) -> Legendre:
    """Transformada de Legendre respecto de varias variables a la vez.

    Si SymPy no sabe invertir el sistema p_i = ∂f/∂x_i, se puede dar la inversa a mano con
    ``inversa={x: ..., t: ...}``; en ese caso se comprueba que realmente lo es.
    """
    variables, conjugadas = tuple(variables), tuple(conjugadas)
    pendientes = tuple(sp.diff(f, v) for v in variables)
    if inversa is None:
        sols = sp.solve([sp.Eq(p, d) for p, d in zip(conjugadas, pendientes)], variables, dict=True)
        if len(sols) != 1:
            raise ValueError(f"El sistema tiene {len(sols)} soluciones; da la inversa con inversa=.")
        inversa = sols[0]
    else:
        for x, p, d in zip(variables, conjugadas, pendientes):
            comprobar(sp.simplify(d.subs(inversa)) - p, f"la inversa dada cumple {p} = ∂f/∂{x}")
    g = sp.simplify(sum(p * inversa[v] for v, p in zip(variables, conjugadas)) - f.subs(inversa))
    return Legendre(f, variables, conjugadas, pendientes, dict(inversa), g)


# --- Mecánica analítica ---------------------------------------------------------------

def euler_lagrange(L, qs, t):
    """Ecuaciones de Euler-Lagrange d/dt(∂L/∂q̇) − ∂L/∂q = 0 para las funciones ``qs`` de ``t``."""
    qs = list(qs) if isinstance(qs, (list, tuple)) else [qs]
    return [sp.Eq(sp.simplify(sp.diff(sp.diff(L, sp.diff(q, t)), t) - sp.diff(L, q)), 0) for q in qs]


def hamiltoniano(L, qs, t, ps):
    """Hamiltoniano H(q, p, t) = Σ p·q̇ − L obtenido por transformada de Legendre en las velocidades.

    ``qs`` son funciones de ``t`` y ``ps`` los símbolos de los momentos conjugados. Devuelve
    (H, momentos) con momentos = [∂L/∂q̇_i].
    """
    qs = list(qs) if isinstance(qs, (list, tuple)) else [qs]
    ps = list(ps) if isinstance(ps, (list, tuple)) else [ps]
    v = sp.symbols(f"v0:{len(qs)}")
    cambio = {sp.diff(q, t): vi for q, vi in zip(qs, v)}
    Lv = L.subs(cambio)
    momentos = [sp.diff(Lv, vi) for vi in v]
    sol = sp.solve([sp.Eq(p, m) for p, m in zip(ps, momentos)], v, dict=True)
    if len(sol) != 1:
        raise ValueError(f"No se pueden despejar las velocidades de forma única: {sol}")
    H = sp.simplify(sum(p * sol[0][vi] for p, vi in zip(ps, v)) - Lv.subs(sol[0]))
    return H, [m.subs({vi: sp.diff(q, t) for q, vi in zip(qs, v)}) for m in momentos]

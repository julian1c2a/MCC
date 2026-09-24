# %% [markdown]
# # Tema 1, sección 7: significado físico del Hamiltoniano
#
# Ejemplos de la sección 7.5, comprobados con SymPy:
#
# 1. Cuenta en una varilla que gira con velocidad angular constante: $H$ se conserva, pero
#    $H \neq E$ ($E - H = 2 \cdot T_0$).
# 2. Oscilador con constante elástica variable $k(t)$: $H = E$, pero $H$ no se conserva
#    ($dH/dt = \partial H/\partial t$).

# %%
from mcc_sym import *

t = sp.Symbol("t", real=True)
m, w = sp.symbols("m omega", positive=True)
p = sp.Symbol("p", real=True)
r = sp.Function("r")(t)
rp, rpp = sp.diff(r, t), sp.diff(r, t, 2)

# %% [markdown]
# ## 1. Cuenta en una varilla que gira
#
# Coordenadas cartesianas de la cuenta, a distancia $r$ del eje: $x = r \cdot \cos(\omega \cdot t)$,
# $y = r \cdot \sin(\omega \cdot t)$. Dependen explícitamente de $t$: el sistema es reónomo.

# %%
X = r * sp.cos(w * t)
Y = r * sp.sin(w * t)
T = sp.simplify(sp.Rational(1, 2) * m * (sp.diff(X, t)**2 + sp.diff(Y, t)**2))
mostrar("T", T)
comprobar(T - (sp.Rational(1, 2) * m * rp**2 + sp.Rational(1, 2) * m * w**2 * r**2),
          "T = ½·m·ṙ² + ½·m·ω²·r²")

T2 = sp.Rational(1, 2) * m * rp**2          # parte homogénea de grado 2 en ṙ
T0 = sp.Rational(1, 2) * m * w**2 * r**2    # parte de grado 0
L = T                                       # varilla horizontal: V = 0

# %% [markdown]
# Ecuación de movimiento (Euler-Lagrange) y Hamiltoniano $H = p \cdot \dot{r} - L$.

# %%
(ecuacion,) = euler_lagrange(L, [r], t)
mostrar("", ecuacion)
comprobar(ecuacion.lhs - (m * rpp - m * w**2 * r), "m·r̈ − m·ω²·r = 0")

H, (momento,) = hamiltoniano(L, [r], t, [p])
mostrar("H(r,p)", H)
mostrar("p", momento)
comprobar(H - (p**2 / (2 * m) - sp.Rational(1, 2) * m * w**2 * r**2), "H = p²/(2·m) − ½·m·ω²·r²")

# %% [markdown]
# En función de las velocidades, $H = T_2 - T_0$, y la energía es $E = T = T_2 + T_0$.

# %%
H_v = H.subs(p, momento)
E = T
comprobar(H_v - (T2 - T0), "H = T₂ − T₀ (sección 7.3)")
comprobar(E - H_v - 2 * T0, "E − H = 2·T₀ = m·ω²·r²")

# %% [markdown]
# Derivadas temporales a lo largo del movimiento: se sustituye $\ddot{r} = \omega^2 \cdot r$.

# %%
en_movimiento = {rpp: w**2 * r}
dH = sp.diff(H_v, t).subs(en_movimiento)
dE = sp.diff(E, t).subs(en_movimiento)
mostrar("\\dfrac{dH}{dt}", sp.simplify(dH))
mostrar("\\dfrac{dE}{dt}", sp.simplify(dE))
comprobar(dH, "H se conserva (L no depende explícitamente de t)")
comprobar(dE - 2 * m * w**2 * r * rp, "dE/dt = 2·m·ω²·r·ṙ ≠ 0: la varilla realiza trabajo")

# %% [markdown]
# Comprobación con la solución general $r(t) = A \cdot e^{\omega \cdot t} + B \cdot e^{-\omega \cdot t}$.

# %%
A, B = sp.symbols("A B", real=True)
sol = A * sp.exp(w * t) + B * sp.exp(-w * t)
comprobar(ecuacion.lhs.subs(r, sol).doit(), "r = A·e^{ωt} + B·e^{−ωt} cumple la ecuación")
H_sol = sp.simplify(H_v.subs(r, sol).doit())
mostrar("H\\big|_{\\text{solución}}", H_sol)
comprobar(sp.diff(H_sol, t), "H es constante sobre la solución")
comprobar(H_sol + 2 * m * w**2 * A * B, "H = −2·m·ω²·A·B")

# %% [markdown]
# ## 2. Oscilador con constante elástica variable
#
# $L = \frac{1}{2} \cdot m \cdot \dot{x}^2 - \frac{1}{2} \cdot k(t) \cdot x^2$. La relación
# entre $x$ y la posición no depende de $t$ (esclerónomo), pero el potencial sí.

# %%
x = sp.Function("x")(t)
k = sp.Function("k")(t)
L2 = sp.Rational(1, 2) * m * sp.diff(x, t)**2 - sp.Rational(1, 2) * k * x**2
H2, (momento2,) = hamiltoniano(L2, [x], t, [p])
mostrar("H(x,p,t)", H2)
E2 = sp.Rational(1, 2) * m * sp.diff(x, t)**2 + sp.Rational(1, 2) * k * x**2
comprobar(H2.subs(p, momento2) - E2, "H = T + V = E")

# %% [markdown]
# $dH/dt$ con las ecuaciones de Hamilton: $\dot{x} = \partial H/\partial p$,
# $\dot{p} = -\partial H/\partial x$. Se trata $x$ como símbolo.

# %%
xs = sp.Symbol("x", real=True)
H2s = H2.subs(x, xs)
dH2 = (sp.diff(H2s, xs) * sp.diff(H2s, p) + sp.diff(H2s, p) * (-sp.diff(H2s, xs))
       + sp.diff(H2s, t))
mostrar("\\dfrac{dH}{dt}", sp.simplify(dH2))
comprobar(dH2 - sp.Rational(1, 2) * sp.diff(k, t) * xs**2,
          "dH/dt = ∂H/∂t = ½·k̇·x²: la energía cambia si k varía")

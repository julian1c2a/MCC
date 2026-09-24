# %% [markdown]
# # Tema 1, secciones 1.4 y 4.1: la ecuación de ondas desde una densidad lagrangiana
#
# 1. Densidad lagrangiana de una cuerda, $\mathcal{L} = \frac{1}{2} \cdot \mu \cdot f_t^2 - \frac{1}{2} \cdot \tau \cdot f_x^2$,
#    y su ecuación de Euler-Lagrange: la ecuación de ondas con $v^2 = \tau/\mu$.
# 2. La solución de d'Alembert la cumple para funciones $F$ y $G$ arbitrarias.
# 3. Onda estacionaria: suma de dos ondas viajeras y relación de dispersión $\omega = v \cdot k$.

# %%
from mcc_sym import *

x, t = sp.symbols("x t", real=True)
mu, tau, A, k, w, L = sp.symbols("mu tau A k omega L", positive=True)
f = sp.Function("f")(x, t)

# %% [markdown]
# ## 1. De la densidad lagrangiana a la ecuación de ondas
#
# $\mu$ es la densidad lineal de masa y $\tau$ la tensión de la cuerda. El primer término es la
# densidad de energía cinética y el segundo, la de energía potencial elástica.

# %%
densidad = sp.Rational(1, 2) * mu * sp.diff(f, t)**2 - sp.Rational(1, 2) * tau * sp.diff(f, x)**2
ecuacion = euler_lagrange_campo(densidad, f, [x, t])
mostrar("\\text{E-L}", ecuacion)
v = sp.sqrt(tau / mu)
comprobar(ecuacion / mu - (sp.diff(f, x, 2) * v**2 - sp.diff(f, t, 2)),
          "Euler-Lagrange da ∂²f/∂t² = (τ/μ)·∂²f/∂x²: ecuación de ondas con v² = τ/μ")

def onda(expr):
    """Lado izquierdo de la ecuación de ondas, f_tt − v²·f_xx, evaluado en expr."""
    return sp.diff(expr, t, 2) - v**2 * sp.diff(expr, x, 2)

# %% [markdown]
# ## 2. Solución de d'Alembert
#
# $f(x,t) = F(x - v \cdot t) + G(x + v \cdot t)$ con $F$ y $G$ arbitrarias (dos veces derivables).

# %%
F, G = sp.Function("F"), sp.Function("G")
dalembert = F(x - v * t) + G(x + v * t)
comprobar(onda(dalembert), "F(x − v·t) + G(x + v·t) cumple la ecuación de ondas")

pulso = sp.exp(-(x - v * t)**2)
comprobar(onda(pulso), "un pulso gaussiano que viaja hacia la derecha también")
comprobar(sp.simplify(onda(sp.exp(-(x - 2 * v * t)**2))) != 0,
          "con velocidad 2·v no es solución: la velocidad la fija la ecuación")

# %% [markdown]
# ## 3. Onda estacionaria
#
# Suma de dos ondas de igual amplitud en sentidos opuestos (sección 1.2.1).

# %%
suma = A * sp.sin(k * x - w * t) + A * sp.sin(k * x + w * t)
estacionaria = 2 * A * sp.sin(k * x) * sp.cos(w * t)
comprobar(sp.expand_trig(suma - estacionaria), "A·sin(kx − ωt) + A·sin(kx + ωt) = 2·A·sin(kx)·cos(ωt)")

residuo = sp.simplify(onda(estacionaria) / estacionaria)
mostrar("\\dfrac{f_{tt} - v^2 \\cdot f_{xx}}{f}", residuo)
comprobar(residuo.subs(w, v * k), "es solución si y solo si ω = v·k (relación de dispersión)")

# Modos de la cuerda fija en x = 0 y x = L: sin(k·L) = 0.
n = sp.Symbol("n", integer=True, positive=True)
kn = n * sp.pi / L
comprobar(sp.sin(kn * L), "k_n = n·π/L anula la onda en x = L")
mostrar("\\omega_n", v * kn)

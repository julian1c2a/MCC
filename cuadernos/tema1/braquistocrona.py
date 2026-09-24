# %% [markdown]
# # Tema 1, sección 3.2: la braquistócrona
#
# 1. Funcional del tiempo e identidad de Beltrami.
# 2. La cicloide cumple la ecuación de primer orden $y \cdot (1 + (y')^2) = 2 \cdot r$ y la
#    ecuación de Euler-Lagrange completa.
# 3. Tiempo de descenso por la cicloide, $T = \theta_B \cdot \sqrt{r/g}$, comparado con el
#    de la recta.

# %%
from mcc_sym import *

x = sp.Symbol("x", real=True)
g, r = sp.symbols("g r", positive=True)
th = sp.Symbol("theta", positive=True)
y = sp.Function("y")(x)
yp, ypp = sp.diff(y, x), sp.diff(y, x, 2)

# %% [markdown]
# ## 1. Funcional e identidad de Beltrami
#
# $\mathcal{L}(y, y') = \sqrt{1 + (y')^2} / \sqrt{2 \cdot g \cdot y}$ no depende explícitamente de $x$.

# %%
Lb = sp.sqrt(1 + yp**2) / sp.sqrt(2 * g * y)
beltrami = sp.simplify(Lb - yp * sp.diff(Lb, yp))
mostrar("\\mathcal{L} - y' \\cdot \\dfrac{\\partial \\mathcal{L}}{\\partial y'}", beltrami)
comprobar(beltrami - 1 / (sp.sqrt(2 * g) * sp.sqrt(y) * sp.sqrt(1 + yp**2)),
          "la expresión de Beltrami es 1/(√(2·g)·√y·√(1 + y'²))")

(el,) = euler_lagrange(Lb, [y], x)
EL = el.lhs      # d/dx(∂L/∂y') − ∂L/∂y
comprobar(sp.diff(beltrami, x) + yp * EL,
          "d/dx(L − y'·∂L/∂y') = −y'·(ecuación de Euler-Lagrange): Beltrami es una primera integral")

# %% [markdown]
# ## 2. La cicloide
#
# $x(\theta) = r \cdot (\theta - \sin\theta)$, $y(\theta) = r \cdot (1 - \cos\theta)$. Las
# derivadas respecto de $x$ se obtienen con la regla de la cadena: $y' = (dy/d\theta)/(dx/d\theta)$.

# %%
xc = r * (th - sp.sin(th))
yc = r * (1 - sp.cos(th))
yp_c = sp.simplify(sp.diff(yc, th) / sp.diff(xc, th))
ypp_c = sp.simplify(sp.diff(yp_c, th) / sp.diff(xc, th))
mostrar("y'", yp_c)
mostrar("y''", ypp_c)

comprobar(sp.simplify(yc * (1 + yp_c**2)) - 2 * r, "y·(1 + y'²) = 2·r sobre la cicloide")
EL_c = EL.subs({ypp: ypp_c}).subs({yp: yp_c}).subs({y: yc})
comprobar(EL_c, "la cicloide cumple la ecuación de Euler-Lagrange completa")

# %% [markdown]
# ## 3. Tiempo de descenso
#
# Con $ds = \sqrt{(dx/d\theta)^2 + (dy/d\theta)^2} \cdot d\theta$ y $v = \sqrt{2 \cdot g \cdot y}$,
# el integrando del tiempo es constante: $ds/v = \sqrt{r/g} \cdot d\theta$. SymPy no simplifica
# $\sqrt{1 - \cos\theta}$ sin saber que $1 - \cos\theta > 0$, así que se comprueba en dos puntos.

# %%
integrando = sp.sqrt(sp.diff(xc, th)**2 + sp.diff(yc, th)**2) / sp.sqrt(2 * g * yc)
comprobar(integrando.subs(th, sp.Rational(9, 10)) - sp.sqrt(r / g), "ds/v = √(r/g)·dθ (θ = 0,9)")
comprobar(integrando.subs(th, 3) - sp.sqrt(r / g), "ds/v = √(r/g)·dθ (θ = 3)")

thB = sp.Symbol("theta_B", positive=True)
T_cicloide = sp.integrate(sp.sqrt(r / g), (th, 0, thB))
mostrar("T_{\\text{cicloide}}", T_cicloide)

# %% [markdown]
# Comparación con la recta de $A = (0, 0)$ a $B = (x_B, y_B)$: por ella la aceleración es
# constante, $g \cdot y_B / L$, con $L = \sqrt{x_B^2 + y_B^2}$, y el tiempo es
# $\sqrt{2 \cdot L^2 / (g \cdot y_B)}$. Se toma $B$ en $\theta_B = \pi$ (punto más bajo de la cicloide).

# %%
xB, yB = xc.subs(th, sp.pi), yc.subs(th, sp.pi)
T_recta = sp.sqrt(2 * (xB**2 + yB**2) / (g * yB))
Tc = T_cicloide.subs(thB, sp.pi)
mostrar("T_{\\text{cicloide}}", Tc)
mostrar("T_{\\text{recta}}", sp.simplify(T_recta))
cociente = sp.N((T_recta / Tc).subs({r: 1, g: sp.Rational(981, 100)}))
print(f"T_recta / T_cicloide = {cociente:.4f}")
comprobar(cociente > 1, "la cicloide es más rápida que la recta")

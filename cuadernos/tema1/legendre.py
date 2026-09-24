# %% [markdown]
# # Tema 1, sección 5: transformada de Legendre
#
# Ejemplos simbólicos de la transformada de Legendre $g = \sum_i p_i \cdot x_i - f$.
#
# 1. Comprobación con el ejemplo de los apuntes (5.2): $F(v) = v^2$.
# 2. $f(x,t) = \cos(k \cdot x) \cdot e^{\omega \cdot t}$ respecto de $x$, con $t$ como variable pasiva.
# 3. La misma $f$ respecto de $x$ y de $t$ a la vez.
#
# Se ejecuta celda a celda en la ventana interactiva de VS Code (Mayús+Intro) o entero con
# `scripts/comprueba-cuadernos.ps1`.

# %%
from mcc_sym import *

x, t, p, v = sp.symbols("x t p v", real=True)
k, w = sp.symbols("k omega", positive=True)

# %% [markdown]
# ## 1. Ejemplo de los apuntes: $F(v) = v^2$
#
# Debe salir $G(p) = p^2/4$, y la doble transformada debe devolver $F$.

# %%
F = v**2
L1 = legendre(F, v, p)
mostrar("G(p)", L1.g)
comprobar(L1.g - p**2 / 4, "G(p) = p²/4, como en la sección 5.2")
L1.comprobar()

doble = legendre(L1.g, p, v)
mostrar("F^{**}(v)", doble.g)
comprobar(doble.g - F, "la doble transformada devuelve F")

# %% [markdown]
# ## 2. $f(x,t) = \cos(k \cdot x) \cdot e^{\omega \cdot t}$ respecto de $x$
#
# $t$ no se transforma: es una variable pasiva, como $q$ y $t$ al pasar de $L(q, \dot{q}, t)$ a
# $H(q, p, t)$.

# %%
f = sp.cos(k * x) * sp.exp(w * t)
mostrar("p = \\dfrac{\\partial f}{\\partial x}", sp.diff(f, x))
mostrar("\\dfrac{\\partial^2 f}{\\partial x^2}", sp.diff(f, x, 2))

# %% [markdown]
# $\partial^2 f / \partial x^2$ cambia de signo, así que $f$ no es convexa ni cóncava en $x$ y la
# ecuación $p = \partial f/\partial x$ no tiene una única solución: hay varias ramas.

# %%
L2 = legendre(f, x, p, rama=1)   # se elige la rama con k·x en (−π/2, π/2)
for i, r in enumerate(L2.ramas):
    mostrar(f"x_{{{i}}}(p,t)", r)

# %%
mostrar("x(p,t)", L2.inversa[x])
mostrar("g(p,t)", L2.g)
L2.comprobar(pasivas=[t])

# %% [markdown]
# La rama solo existe si $|p| \le k \cdot e^{\omega \cdot t}$ (argumento del arcoseno). La
# variable pasiva cambia de signo al transformar: $\partial g/\partial t = -\partial f/\partial t$,
# que es la relación $\partial H/\partial t = -\partial L/\partial t$ de la sección 6.2.
#
# Doble transformada: SymPy devuelve $\arcsin(\sin(k \cdot x))$ y $|\cos(k \cdot x)|$, que solo
# valen $k \cdot x$ y $\cos(k \cdot x)$ dentro de la rama elegida.

# %%
doble2 = legendre(L2.g, p, x)
mostrar("f^{**}(x,t)", doble2.g)

# Dentro de la rama coincide con f; fuera, no.
dentro = {k: 2, w: sp.Rational(1, 3), t: sp.Rational(1, 2), x: sp.Rational(3, 10)}    # k·x = 0.6
fuera = {k: 2, w: sp.Rational(1, 3), t: sp.Rational(1, 2), x: sp.Rational(12, 10)}    # k·x = 2.4
comprobar(abs(sp.N((doble2.g - f).subs(dentro))) < 1e-12,
          "dentro de la rama, la doble transformada devuelve f")
comprobar(abs(sp.N((doble2.g - f).subs(fuera))) > 1e-3,
          "fuera de la rama, no la devuelve")

# %%
print("LaTeX para los apuntes:")
print(latex_mcc(L2.g))

# %% [markdown]
# ## 3. La misma $f$ respecto de $x$ y de $t$
#
# Variables conjugadas: $p = \partial f/\partial x$ y $s = \partial f/\partial t$.

# %%
H, detH = hessiana(f, (x, t))
mostrar("\\det H", detH)
comprobar(detH + k**2 * w**2 * sp.exp(2 * w * t), "det H = −k²·ω²·e^{2ωt} (nunca se anula)")

# %% [markdown]
# El determinante nunca se anula, así que la transformación es localmente invertible en todo
# punto; pero es negativo, así que la hessiana es indefinida: $f$ no es convexa en ninguna
# región (tiene forma de silla). SymPy no invierte este sistema por sí solo; la inversa se
# obtiene a mano: $(p/k)^2 + (s/\omega)^2 = e^{2 \cdot \omega \cdot t}$ y
# $\tan(k \cdot x) = -(\omega \cdot p)/(k \cdot s)$. Se toma la rama $s > 0$.

# %%
s_pos = sp.Symbol("s", positive=True)   # rama s > 0
inversa = {
    x: sp.atan2(-p / k, s_pos / w) / k,
    t: sp.log(p**2 / k**2 + s_pos**2 / w**2) / (2 * w),
}
L3 = legendre_multi(f, (x, t), (p, s_pos), inversa=inversa)
mostrar("G(p,s)", L3.g)
L3.comprobar()

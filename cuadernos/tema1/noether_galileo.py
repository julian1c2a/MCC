# %% [markdown]
# # Tema 1, sección 4.2: simetrías de Galileo y cantidades conservadas (teorema de Noether)
#
# Sistema de $N = 3$ partículas en el espacio con lagrangiano
# $L = \sum_a \frac{1}{2} \cdot m_a \cdot |\dot{\vec{x}}_a|^2 - V(r_{12}, r_{13}, r_{23})$, donde el
# potencial $V$ es una función cualquiera de las distancias $r_{ab} = |\vec{x}_a - \vec{x}_b|$.
#
# 1. Cada generador del grupo de Galileo (traslación temporal y espacial, rotación y cambio de
#    velocidad) deja el lagrangiano invariante, salvo una derivada total en el cambio de velocidad.
# 2. La cantidad de Noether $Q = \sum_a \vec{p}_a \cdot \vec{\xi}_a - F$ de cada generador es la
#    que se espera: momento lineal, momento angular y $\vec{G} = M \cdot \vec{X}_{cm} - \vec{P} \cdot t$.
# 3. Las 10 cantidades (energía, $\vec{P}$, $\vec{J}$ y $\vec{G}$) se conservan sobre las soluciones
#    de las ecuaciones de Euler-Lagrange.

# %%
from mcc_sym import *

t = sp.Symbol("t", real=True)
eps = sp.Symbol("epsilon", real=True)
N = 3
m = sp.symbols(f"m1:{N + 1}", positive=True)
x = [sp.Matrix([sp.Function(f"x{a + 1}{i + 1}")(t) for i in range(3)]) for a in range(N)]
xd = [xa.diff(t) for xa in x]
xdd = [xa.diff(t, 2) for xa in x]

pares = [(a, b) for a in range(N) for b in range(a + 1, N)]
r = {(a, b): sp.sqrt((x[a] - x[b]).dot(x[a] - x[b])) for a, b in pares}
V = sp.Function("V")(*[r[p] for p in pares])

T = sum(sp.Rational(1, 2) * m[a] * xd[a].dot(xd[a]) for a in range(N))
L = T - V
p = [m[a] * xd[a] for a in range(N)]            # momentos lineales de cada partícula
M = sum(m)
P = sum(p, sp.zeros(3, 1))                      # momento lineal total

# %% [markdown]
# Ecuaciones de Euler-Lagrange: $m_a \cdot \ddot{\vec{x}}_a = -\partial V/\partial \vec{x}_a$. Se
# guardan como sustitución de las aceleraciones, para evaluar derivadas temporales sobre las
# soluciones.

# %%
sobre_soluciones = {}
for a in range(N):
    for i in range(3):
        sobre_soluciones[xdd[a][i]] = -sp.diff(V, x[a][i]) / m[a]

def en_solucion(expr):
    """Derivada temporal evaluada sobre las soluciones (sustituye las aceleraciones)."""
    return sp.expand(expr.subs(sobre_soluciones))

# %% [markdown]
# ## 1. Invariancia del lagrangiano bajo cada generador
#
# Para una transformación infinitesimal $\vec{x}_a \to \vec{x}_a + \varepsilon \cdot \vec{\xi}_a$,
# el cambio de primer orden del lagrangiano es $\delta L = \varepsilon \cdot \frac{d}{d\varepsilon}
# L\big|_{\varepsilon=0}$.

# %%
def variacion(xi):
    """dL/dε en ε = 0 para la transformación x_a -> x_a + ε·ξ_a (ξ puede depender de t)."""
    cambio = {}
    for a in range(N):
        for i in range(3):
            cambio[x[a][i]] = x[a][i] + eps * xi[a][i]
    Lt = L.subs(cambio, simultaneous=True).doit()
    return sp.expand(sp.diff(Lt, eps).subs(eps, 0).doit())

e = sp.Matrix(sp.symbols("e1:4", real=True))     # dirección de traslación
n = sp.Matrix(sp.symbols("n1:4", real=True))     # eje de rotación
u = sp.Matrix(sp.symbols("u1:4", real=True))     # cambio de velocidad

dL_tras = variacion([e] * N)
comprobar(dL_tras, "traslación espacial: δL = 0")

dL_rot = variacion([n.cross(x[a]) for a in range(N)])
comprobar(dL_rot, "rotación: δL = 0")

dL_boost = variacion([u * t] * N)
F = sum(m[a] * u.dot(x[a]) for a in range(N))
comprobar(dL_boost - F.diff(t), "cambio de velocidad: δL = dF/dt, con F = Σ m_a·u·x_a")
mostrar("F", F)

# %% [markdown]
# ## 2. Cantidades de Noether $Q = \sum_a \vec{p}_a \cdot \vec{\xi}_a - F$

# %%
J = sum((x[a].cross(p[a]) for a in range(N)), sp.zeros(3, 1))
X_cm = sum((m[a] * x[a] for a in range(N)), sp.zeros(3, 1)) / M
G = M * X_cm - P * t

Q_tras = sum(p[a].dot(e) for a in range(N))
Q_rot = sum(p[a].dot(n.cross(x[a])) for a in range(N))
Q_boost = sum(p[a].dot(u * t) for a in range(N)) - F

comprobar(Q_tras - e.dot(P), "traslación: Q = e·P (momento lineal)")
comprobar(sp.expand(Q_rot - n.dot(J)), "rotación: Q = n·J (momento angular)")
comprobar(sp.expand(Q_boost + u.dot(G)), "cambio de velocidad: Q = −u·G, con G = M·X_cm − P·t")

# %% [markdown]
# ## 3. Las 10 cantidades se conservan sobre las soluciones

# %%
E = T + V
comprobar(en_solucion(E.diff(t)), "energía: dE/dt = 0 (V no depende explícitamente de t)")
for i, nombre in enumerate("xyz"):
    comprobar(en_solucion(P[i].diff(t)), f"momento lineal P_{nombre} se conserva")
    comprobar(en_solucion(J[i].diff(t)), f"momento angular J_{nombre} se conserva")
    comprobar(en_solucion(G[i].diff(t)), f"G_{nombre} = (M·X_cm − P·t)_{nombre} se conserva")
print("Total: 1 + 3 + 3 + 3 = 10 cantidades conservadas.")

# %% [markdown]
# # Tema 1, sección 4.2: álgebra de Lie del grupo de Galileo (SageMath)
#
# Cuaderno de SageMath (REGLAS.md 7.5): se ejecuta con el entorno de Sage en WSL.
# Complementa `noether_galileo.py`, que obtiene las 10 cantidades conservadas; aquí se estudia
# la estructura del grupo que las produce.
#
# 1. Los 10 generadores del grupo de Galileo como matrices $5 \times 5$ que actúan sobre
#    $(x_1, x_2, x_3, t, 1)$, y la comprobación de que su exponencial da las transformaciones
#    finitas (rotación y cambio de velocidad).
# 2. Todos los conmutadores $[A, B] = A \cdot B - B \cdot A$ entre generadores.
# 3. El álgebra de Lie que forman: dimensión, centro, álgebra derivada, radical resoluble y
#    forma de Killing.
# 4. Los corchetes de Poisson de las cantidades de Noether reproducen los conmutadores salvo
#    en uno: $\{G_i, P_j\} = M \cdot \delta_{ij}$ en lugar de $0$ (extensión central).

# %%
from sage.all import *

from mcc_sym import comprobar, mostrar


def E(i, j):
    """Matriz 5×5 con un 1 en la posición (i, j). Índices 0, 1, 2: espacio; 3: tiempo; 4: fila homogénea."""
    m = matrix(QQ, 5, 5)
    m[i, j] = 1
    return m


def levi_civita(i, j, k):
    """Símbolo de Levi-Civita ε_ijk para i, j, k ∈ {0, 1, 2}."""
    return QQ((i - j) * (j - k) * (k - i)) / 2


def conmutador(A, B):
    return A * B - B * A


# Generadores: (J_k)_ab = -ε_kab, de modo que J_k·x = e_k × x (rotación alrededor del eje k);
# K_i = E_i3 (x_i -> x_i + u·t), P_i = E_i4 (x_i -> x_i + a), H = E_34 (t -> t + b).
J = [sum(-levi_civita(k, a, b) * E(a, b) for a in range(3) for b in range(3)) for k in range(3)]
K = [E(i, 3) for i in range(3)]
P = [E(i, 4) for i in range(3)]
H = E(3, 4)

# %% [markdown]
# ## 1. Transformaciones finitas como exponenciales de los generadores

# %%
theta, u = var("theta u", domain="real")
# Maxima da la exponencial en forma compleja; demoivre la pasa a senos y cosenos.
R3 = (theta * J[2].change_ring(SR)).exp().apply_map(
    lambda e: e.maxima_methods().demoivre().expand().simplify_full())
mostrar("e^{\\theta \\cdot J_3}", R3)
R3_esperada = matrix(SR, [[cos(theta), -sin(theta), 0, 0, 0],
                          [sin(theta), cos(theta), 0, 0, 0],
                          [0, 0, 1, 0, 0], [0, 0, 0, 1, 0], [0, 0, 0, 0, 1]])
comprobar((R3 - R3_esperada).simplify_full(), "exp(θ·J_3) es la rotación R_3(θ)")

B1 = (u * K[0].change_ring(SR)).exp()
comprobar(B1 - (identity_matrix(SR, 5) + u * E(0, 3)), "exp(u·K_1) es el cambio de velocidad x_1 -> x_1 + u·t")

# %% [markdown]
# ## 2. Conmutadores de los generadores

# %%
cero = matrix(QQ, 5, 5)
for i in range(3):
    for j in range(3):
        eps_J = sum(levi_civita(i, j, k) * J[k] for k in range(3))
        eps_K = sum(levi_civita(i, j, k) * K[k] for k in range(3))
        eps_P = sum(levi_civita(i, j, k) * P[k] for k in range(3))
        comprobar(conmutador(J[i], J[j]) - eps_J, f"[J_{i+1}, J_{j+1}] = ε_{i+1}{j+1}k·J_k")
        comprobar(conmutador(J[i], K[j]) - eps_K, f"[J_{i+1}, K_{j+1}] = ε_{i+1}{j+1}k·K_k")
        comprobar(conmutador(J[i], P[j]) - eps_P, f"[J_{i+1}, P_{j+1}] = ε_{i+1}{j+1}k·P_k")
        comprobar(conmutador(K[i], K[j]), f"[K_{i+1}, K_{j+1}] = 0")
        comprobar(conmutador(P[i], P[j]), f"[P_{i+1}, P_{j+1}] = 0")
        comprobar(conmutador(K[i], P[j]), f"[K_{i+1}, P_{j+1}] = 0")
    comprobar(conmutador(J[i], H), f"[J_{i+1}, H] = 0")
    comprobar(conmutador(P[i], H), f"[P_{i+1}, H] = 0")
    comprobar(conmutador(K[i], H) - P[i], f"[K_{i+1}, H] = P_{i+1}")

# %% [markdown]
# ## 3. El álgebra de Lie del grupo de Galileo
#
# Se construye el álgebra abstracta a partir de las constantes de estructura: las
# coordenadas de cada conmutador en la base de los 10 generadores.

# %%
nombres = ["J1", "J2", "J3", "K1", "K2", "K3", "P1", "P2", "P3", "H"]
base = J + K + P + [H]
coordenadas = matrix(QQ, [b.list() for b in base])       # 10 × 25, de rango 10
comprobar(coordenadas.rank() == 10, "los 10 generadores son linealmente independientes")

constantes = {}
for a in range(10):
    for b in range(a + 1, 10):
        c = coordenadas.solve_left(vector(QQ, conmutador(base[a], base[b]).list()))
        if c:
            constantes[(nombres[a], nombres[b])] = {nombres[k]: c[k] for k in range(10) if c[k]}
g = LieAlgebra(QQ, constantes, names=",".join(nombres))
comprobar(g.dimension() == 10, "dim g = 10 (tantos parámetros como el grupo)")

comprobar(g.center().dimension() == 0, "el centro de g es trivial")
comprobar(g.derived_subalgebra().dimension() == 9,
          "[g, g] tiene dimensión 9: H no es conmutador de ningún par de generadores")
comprobar(not g.is_solvable(), "g no es resoluble (contiene so(3))")
rad = g.solvable_radical()
comprobar(rad.dimension() == 7, "el radical resoluble es ⟨K, P, H⟩ (dimensión 7)")
KPH = matrix(QQ, [e.to_vector() for e in g.gens()[3:]])   # K_1, K_2, K_3, P_1, P_2, P_3, H
comprobar(rad.basis_matrix().stack(KPH).rank() == 7, "el radical está generado por K_i, P_i y H")
comprobar(g.killing_form_matrix().rank() == 3,
          "la forma de Killing solo es no degenerada sobre so(3): rango 3")

# %% [markdown]
# Descomposición de Levi: $\mathfrak{g} = \mathfrak{so}(3) \ltimes \langle K, P, H \rangle$. Las
# rotaciones forman la parte semisimple; los cambios de velocidad, las traslaciones y la
# traslación temporal, el radical resoluble.
#
# ## 4. Corchetes de Poisson de las cantidades de Noether
#
# Para $N = 2$ partículas libres en el espacio, con $\vec{P} = \sum_a \vec{p}_a$,
# $\vec{J} = \sum_a \vec{x}_a \times \vec{p}_a$ y $\vec{G} = \sum_a m_a \cdot \vec{x}_a - \vec{P} \cdot t$
# (véase `noether_galileo.py`), y $\{f, g\} = \sum \left(\dfrac{\partial f}{\partial x} \cdot
# \dfrac{\partial g}{\partial p} - \dfrac{\partial f}{\partial p} \cdot \dfrac{\partial g}{\partial x}\right)$.

# %%
t = var("t", domain="real")
m = [var(f"m{a+1}", domain="positive") for a in range(2)]
x = [vector(SR, [var(f"x{a+1}{i+1}", domain="real") for i in range(3)]) for a in range(2)]
p = [vector(SR, [var(f"p{a+1}{i+1}", domain="real") for i in range(3)]) for a in range(2)]
M = m[0] + m[1]


def poisson(f, h):
    return sum(diff(f, x[a][i]) * diff(h, p[a][i]) - diff(f, p[a][i]) * diff(h, x[a][i])
               for a in range(2) for i in range(3))


Pt = p[0] + p[1]
Jt = x[0].cross_product(p[0]) + x[1].cross_product(p[1])
Gt = m[0] * x[0] + m[1] * x[1] - Pt * t

for i in range(3):
    for j in range(3):
        eps_P = sum(levi_civita(i, j, k) * Pt[k] for k in range(3))
        eps_G = sum(levi_civita(i, j, k) * Gt[k] for k in range(3))
        comprobar((poisson(Jt[i], Pt[j]) - eps_P).expand(), f"{{J_{i+1}, P_{j+1}}} = ε_{i+1}{j+1}k·P_k")
        comprobar((poisson(Jt[i], Gt[j]) - eps_G).expand(), f"{{J_{i+1}, G_{j+1}}} = ε_{i+1}{j+1}k·G_k")
        comprobar(poisson(Gt[i], Gt[j]).expand(), f"{{G_{i+1}, G_{j+1}}} = 0")
        delta = M if i == j else 0
        comprobar((poisson(Gt[i], Pt[j]) - delta).expand(),
                  f"{{G_{i+1}, P_{j+1}}} = M·δ_{i+1}{j+1} (el conmutador [K_{i+1}, P_{j+1}] es 0)")

# %% [markdown]
# El término $M \cdot \delta_{ij}$ es una constante que conmuta con todo: el álgebra de las
# cantidades conservadas es una extensión central del álgebra de Lie del grupo (álgebra de
# Bargmann). La masa total aparece así como una carga central.

# Tema 1. Mecánica teórica

## 1. Mecánica ondulatoria

La mecánica ondulatoria estudia cómo se propagan las perturbaciones a través de un medio (o el vacío) en forma de ondas. Para comprender matemáticamente esta propagación espacial y temporal, es útil comenzar analizando el comportamiento de un único oscilador y luego expandirlo a un sistema continuo.

### 1.1. El oscilador simple: masa atada a un elástico (o muelle) en el techo

Imaginemos un sistema básico: una masa $m$ suspendida del techo mediante un elástico o resorte ideal con una constante elástica $k$. Si tiramos de la masa hacia abajo separándola de su punto de equilibrio y la soltamos, comenzará a oscilar verticalmente.

Este sistema describe un Movimiento Armónico Simple (MAS). Aplicando la Segunda Ley de Newton y la Ley de Hooke, obtenemos la siguiente ecuación diferencial para el movimiento:

$$
\begin{aligned}
m ⋅ \dfrac{d^2y}{dt^2} = -k ⋅ y
\end{aligned}
$$

La solución a esta ecuación nos da la posición $y$ de la masa en función de una única variable, el tiempo ($t$):

$$
\begin{aligned}
y(t) = A ⋅ \cos(\omega ⋅ t + \phi)
\end{aligned}
$$

En esta función:

* $A$ es la amplitud (el desplazamiento máximo desde el equilibrio).
* $\omega$ es la frecuencia angular, relacionada con las propiedades del sistema ($\omega = \sqrt{\dfrac{k}{m}}$).
* $\phi$ es la constante de fase inicial.

Este ejemplo ilustra una oscilación local; la energía se transforma de potencial a cinética, pero no se propaga a través del espacio.

### 1.2. Movimiento ondulatorio: cuerda elástica horizontal entre dos puntos fijos

Para pasar al movimiento ondulatorio, consideremos ahora una cuerda elástica tensada horizontalmente entre dos paredes (dos puntos fijos). Podemos imaginar esta cuerda como una cadena infinita de pequeñas masas conectadas por pequeños elásticos.

Si perturbamos un punto de la cuerda, esa oscilación no se queda en un solo lugar (como la masa en el techo), sino que tira de los fragmentos vecinos de la cuerda, haciendo que la perturbación viaje a lo largo del eje $x$.

En este caso, el desplazamiento transversal (la altura de la cuerda), que llamaremos $y$, ya no depende solo del momento en que lo miremos, sino también de en qué parte de la cuerda nos fijemos. Por tanto, la función es bivariable: $y(x,t)$.

Una perturbación viajera (onda armónica) moviéndose a lo largo de la cuerda se describe matemáticamente como:

$$
\begin{aligned}
y(x,t) = A \sin(k ⋅ x \pm \omega ⋅ t)
\end{aligned}
$$

Donde se introduce una nueva variable espacial:

* $k$ es el número de onda ($k = \dfrac{2 \cdot \pi}{\lambda}$), que describe la periodicidad en el espacio ($\lambda$ es la longitud de onda).

#### 1.2.1. Ondas estacionarias

Dado que nos has indicado que la cuerda está entre dos puntos fijos (por ejemplo, en $x=0$ y $x=L$), la onda viaja, rebota en un extremo y se superpone consigo misma. Esta interferencia crea una onda estacionaria. Matemáticamente, al aplicar las condiciones de contorno (los extremos no pueden moverse, $y=0$), la función $y(x,t)$ toma esta forma específica:

$$
\begin{aligned}
y(x,t) = 2 ⋅ A \cdot \sin(k ⋅ x) ⋅ \cos(\omega ⋅ t)
\end{aligned}
$$

Esta hermosa ecuación separa la parte espacial de la temporal y nos dice que cada punto $x$ de la cuerda realiza un Movimiento Armónico Simple en el tiempo ($\cos(\omega ⋅ t)$), pero la amplitud de esa oscilación depende de su posición espacial ($2 ⋅ A \sin(k ⋅ x)$). Los puntos donde $\sin(k ⋅ x) = 0$ nunca se mueven; se llaman nodos.

### 1.3. Generalización: representación compleja

En física, es extremadamente común y conveniente generalizar la función de onda utilizando notación compleja. Apoyándonos en la fórmula de Euler ($e^{i ⋅ \theta} = \cos(\theta) + i\sin(\theta)$), una onda viajera puede expresarse en su forma compleja como:

$$
\begin{aligned}
y(x,t) = A \cdot e^{i ⋅ (\omega ⋅ t - k ⋅ x)}
\end{aligned}
$$

Dado que las magnitudes físicas observables en mecánica clásica (como el desplazamiento real de una cuerda) deben ser números reales, la onda física se entiende simplemente como la parte real (o imaginaria) de esta expresión compleja:

$$
\begin{aligned}
y_{real}(x,t) = \Re\{A ⋅ e^{i ⋅ (\omega ⋅ t - k ⋅ x)}\} = A ⋅ \cos(\omega ⋅ t - k ⋅ x)
\end{aligned}
$$

¿Por qué usar una notación compleja?

1. Simplicidad matemática: Operar con funciones exponenciales es mucho más fácil que con senos y cosenos. Al derivar o integrar (por ejemplo, al introducir la función en la Ecuación de Ondas), la exponencial mantiene su forma y solo "escupirá" constantes hacia afuera (derivadas respecto al tiempo multiplican por $i ⋅ \omega$, y respecto a la posición por $-i ⋅ k$). Además, sumar ondas (para calcular interferencias) se reduce a factorizar exponenciales.
2. Fase inicial: Cualquier desfase inicial $\phi$ se puede absorber fácilmente definiendo una amplitud compleja $\tilde{A} = A ⋅ e^{i ⋅ \phi}$.
3. Puente a la mecánica cuántica: Mientras que en la mecánica clásica la parte imaginaria es solo una herramienta matemática y tomamos la parte real al final, en la mecánica ondulatoria cuántica, la función de onda de una partícula $\Psi(x,t)$ es intrínsecamente compleja.

### 1.4. La ecuación de ondas

Cualquier perturbación física que se propague en forma de onda (ya sea el desplazamiento de nuestra cuerda elástica, la presión del aire en el sonido, o los campos eléctricos y magnéticos en la luz) debe obedecer a una ecuación diferencial específica: la ecuación de ondas.

#### 1.4.1. La ecuación diferencial en una dimensión

Para una perturbación $y(x,t)$ que viaja a lo largo de una sola dimensión (el eje $x$), la ecuación clásica de ondas es una ecuación diferencial en derivadas parciales, lineal y de segundo orden, expresada como:

$$
\begin{aligned}
\dfrac{\partial^2 y}{\partial x^2} = \dfrac{1}{v^2} ⋅ \dfrac{\partial^2 y}{\partial t^2}
\end{aligned}
$$

Aquí, $v$ representa la velocidad de propagación (o velocidad de fase) de la onda en el medio. Esta ecuación nos dice, fundamentalmente, que la curvatura espacial de la onda en un punto (segunda derivada respecto a $x$) es proporcional a la aceleración de ese punto (segunda derivada respecto a $t$).

#### 1.4.2. Comprobación con la representación compleja

Podemos demostrar fácilmente por qué la solución compleja que vimos en el apartado anterior, $y(x,t) = A \cdot e^{i ⋅ (\omega ⋅ t - k ⋅ x)}$, es una solución válida. Gracias a las propiedades de la función exponencial, calcular las segundas derivadas parciales es un proceso directo:

1. Derivada temporal: Al derivar dos veces respecto al tiempo, multiplicamos por $i ⋅ \omega$ cada vez.
   $$
   \begin{aligned}
   \dfrac{\partial^2 y}{\partial t^2} = (i ⋅ \omega)^2 ⋅ A ⋅ e^{i ⋅ (\omega ⋅ t - k ⋅ x)} = -\omega^2 ⋅ y
   \end{aligned}
   $$
2. Derivada espacial: Al derivar dos veces respecto a la posición, multiplicamos por $-i ⋅ k$ cada vez.
   $$
   \begin{aligned}
   \dfrac{\partial^2 y}{\partial x^2} = (-i ⋅ k)^2 ⋅ A ⋅ e^{i ⋅ (\omega ⋅ t - k ⋅ x)} = -k^2 ⋅ y
   \end{aligned}
   $$

Si sustituimos estos resultados de nuevo en la ecuación de ondas general, obtenemos:

$$
\begin{aligned}
-k^2 ⋅ y = \dfrac{1}{v^2} ⋅ (-\omega^2 ⋅ y)
\end{aligned}
$$

Simplificando (dividiendo entre $-y$), llegamos a una relación fundamental entre los parámetros de la onda:

$$
\begin{aligned}
k^2 = \dfrac{\omega^2}{v^2} \implies v = \dfrac{\omega}{k}
\end{aligned}
$$

Antes de interpretar este resultado, conviene precisar dos conceptos. Una **relación de dispersión** es una ecuación que vincula la frecuencia angular $\omega$ de una onda con su número de onda $k$, es decir, que indica cómo depende $\omega$ de $k$. En este caso, la ecuación anterior puede escribirse como $\omega = v k$: la relación es lineal y la velocidad de fase $v = \omega/k$ no depende de la frecuencia. Por ello, las distintas componentes de frecuencia de un pulso viajan todas a la misma velocidad y el pulso conserva su forma; a estas ondas se las llama **no dispersivas**. Si la velocidad dependiera de $\omega$ o de $k$, cada componente avanzaría a una velocidad distinta y el pulso se deformaría al propagarse: habría dispersión.

Esta es la relación de dispersión para ondas no dispersivas, que define la velocidad de la onda en función de su frecuencia angular ($\omega$) y su número de onda ($k$).

<!-- AI:T1-01
Tarea: aclarar los conceptos de relación de dispersión y ondas no dispersivas.
Estado: hecho.
-->

#### 1.4.3. La solución de d'Alembert (ondas viajeras arbitrarias)

Aunque las soluciones armónicas (senos, cosenos o exponenciales complejas) son las más comunes, Jean le Rond d'Alembert demostró que la ecuación de ondas admite soluciones mucho más generales.

Definamos los argumentos de las dos ondas viajeras como $u_- = \omega ⋅ t - k ⋅ x$ y $u_+ = \omega ⋅ t + k ⋅ x$. Si $f$ y $g$ son funciones arbitrarias dos veces diferenciables, la solución general de d'Alembert es:

$$
\begin{aligned}
y(x,t) = f(u_-) + g(u_+) = f(\omega ⋅ t - k ⋅ x) + g(\omega ⋅ t + k ⋅ x)
\end{aligned}
$$

<!-- AI:T1-02
Tarea: presentar la solución completa como suma de dos ondas viajeras independientes.
Estado: hecho.
-->

Comprobémoslo aplicando la regla de la cadena a ambas funciones:

$$
\begin{aligned}
\dfrac{\partial^2 y}{\partial t^2} &= \omega^2 ⋅ \left[f''(u_-) + g''(u_+)\right], \\
\dfrac{\partial^2 y}{\partial x^2} &= k^2 ⋅ \left[f''(u_-) + g''(u_+)\right].
\end{aligned}
$$

Como la relación de dispersión obtenida antes es $\omega = v k$, se cumple:

$$
\begin{aligned}
\dfrac{\partial^2 y}{\partial x^2}
&= \dfrac{\omega^2}{v^2} ⋅ \left[f''(u_-) + g''(u_+)\right] \\
&= \dfrac{1}{v^2} \dfrac{\partial^2 y}{\partial t^2}.
\end{aligned}
$$

Por tanto, cualquier par de funciones suaves $f$ y $g$ produce una solución. La primera componente, $f(\omega ⋅ t - k ⋅ x)$, viaja hacia la derecha, mientras que $g(\omega ⋅ t + k ⋅ x)$ viaja hacia la izquierda. Esto permite describir, por ejemplo, un pulso que se propaga y otro que regresa tras reflejarse en un extremo de la cuerda.

#### 1.4.4. Solución general por separación de variables

La forma más sistemática de resolver la ecuación de ondas (especialmente cuando hay condiciones de contorno fijas, como en nuestra cuerda) es el método de separación de variables. Asumimos como hipótesis que la solución $y(x,t)$ puede expresarse como el producto de dos funciones independientes, una que depende solo de la posición $X(x)$ y otra solo del tiempo $T(t)$:

$$
\begin{aligned}
y(x,t) = X(x) ⋅ T(t)
\end{aligned}
$$

Si calculamos las segundas derivadas y las sustituimos en la ecuación de ondas original, obtenemos:

$$
\begin{aligned}
X''(x) ⋅ T(t) = \dfrac{1}{v^2} \cdot X(x) ⋅ T''(t)
\end{aligned}
$$

Dividiendo toda la ecuación por $X(x) ⋅ T(t)$, separamos las variables a cada lado de la igualdad:

$$
\begin{aligned}
\dfrac{X''(x)}{X(x)} = \dfrac{1}{v^2} ⋅ \dfrac{T''(t)}{T(t)}
\end{aligned}
$$

Dado que el lado izquierdo depende exclusivamente de $x$ y el lado derecho exclusivamente de $t$, la única forma de que esta igualdad se cumpla para cualquier valor de $x$ y $t$ es que ambos lados sean iguales a una misma constante. Para obtener soluciones oscilatorias (y no exponenciales que divergen), esta constante de separación debe ser negativa, y la llamaremos $-k^2$:

$$
\begin{aligned}
\dfrac{X''(x)}{X(x)} = -k^2 \quad \text{y} \quad \dfrac{1}{v^2} ⋅ \dfrac{T''(t)}{T(t)} = -k^2
\end{aligned}
$$

Esto descompone la ecuación en derivadas parciales en dos Ecuaciones Diferenciales Ordinarias (EDOs) simples:

1. Ecuación espacial: $X''(x) + k^2 ⋅ X(x) = 0$
2. Ecuación temporal: $T''(t) + \omega^2 ⋅ T(t) = 0 \quad$ (donde hemos definido $\omega = k ⋅ v$)

La solución general para estas ecuaciones son combinaciones lineales de senos y cosenos (o exponenciales complejas):

$$
\begin{aligned}
X(x) = A_1 ⋅ \cos(k ⋅ x) + B_1 ⋅ \sin(k ⋅ x)
\end{aligned}
$$
$$
\begin{aligned}
T(t) = A_2 ⋅ \cos(\omega ⋅ t) + B_2 ⋅ \sin(\omega ⋅ t)
\end{aligned}
$$

Por lo tanto, la solución general para un modo normal de vibración es el producto de ambas:

$$
\begin{aligned}
y(x,t) = \left( A_1 ⋅ \cos(k ⋅ x) + B_1 ⋅ \sin(k ⋅ x) \right) ⋅ \left( A_2 ⋅ \cos(\omega ⋅ t) + B_2 ⋅ \sin(\omega ⋅ t) \right)
\end{aligned}
$$

Aplicando las condiciones de contorno (como $y(0,t)=0$ en la cuerda), muchas de estas constantes se anulan, llegándose a las ecuaciones de ondas estacionarias que vimos en el apartado 1.2.1.

#### 1.4.5. Generalización a dos dimensiones: membranas y series de Fourier

Para una superficie, como una membrana tensa, el desplazamiento transversal $y(x,z,t)$ depende de dos coordenadas espaciales. La ecuación de ondas bidimensional es:

$$
\begin{aligned}
\dfrac{\partial^2 y}{\partial t^2}
= v^2 \left( \dfrac{\partial^2 y}{\partial x^2} + \dfrac{\partial^2 y}{\partial z^2} \right).
\end{aligned}
$$

En este caso, la fórmula de d'Alembert no proporciona la solución general: una perturbación puede propagarse en infinitas direcciones sobre la superficie. Para una membrana rectangular con lados $L_x$ y $L_z$ fijados, $y(0,z,t)=y(L_x,z,t)=y(x,0,t)=y(x,L_z,t)=0$, sí se puede construir la solución general mediante una **serie doble de Fourier**:

$$
\begin{aligned}
y(x,z,t)
= \sum_{m=1}^{\infty} \sum_{n=1}^{\infty}
\left[A_{mn}\cos(\omega_{mn}t) + B_{mn}\sin(\omega_{mn}t)\right]
\sin\left(\dfrac{m\pi x}{L_x}\right)
\sin\left(\dfrac{n\pi z}{L_z}\right).
\end{aligned}
$$

Cada par de enteros positivos $(m,n)$ identifica un modo normal de vibración. Las frecuencias angulares permitidas son:

$$
\begin{aligned}
\omega_{mn} = v\pi\sqrt{\left(\dfrac{m}{L_x}\right)^2 + \left(\dfrac{n}{L_z}\right)^2}.
\end{aligned}
$$

Para determinar los coeficientes, fijamos el desplazamiento inicial $y_0(x,z)=y(x,z,0)$ y la velocidad inicial $u_0(x,z)=\left.\dfrac{\partial y}{\partial t}\right|_{t=0}$. La ortogonalidad de las funciones seno en el rectángulo da directamente:

$$
\begin{aligned}
A_{mn}
= \dfrac{4}{L_xL_z}
\int_0^{L_x}\int_0^{L_z}
y_0(x,z)
\sin\left(\dfrac{m\pi x}{L_x}\right)
\sin\left(\dfrac{n\pi z}{L_z}\right)
\, dz\, dx,
\\
B_{mn}
= \dfrac{4}{L_xL_z\omega_{mn}}
\int_0^{L_x}\int_0^{L_z}
u_0(x,z)
\sin\left(\dfrac{m\pi x}{L_x}\right)
\sin\left(\dfrac{n\pi z}{L_z}\right)
\, dz\, dx.
\end{aligned}
$$

La primera fórmula es la proyección del desplazamiento inicial sobre el modo $(m,n)$. Para la segunda, se deriva la expansión respecto del tiempo, se evalúa en $t=0$ y se proyecta la velocidad inicial; de ahí el factor adicional $1/\omega_{mn}$. Por tanto, las series de Fourier no son un recurso adicional opcional en este problema: son el mecanismo que combina todos los modos normales para reproducir una forma inicial arbitraria compatible con los bordes.

#### 1.4.6. Generalización a tres dimensiones

Si la perturbación se propaga en el espacio tridimensional (como el sonido en una habitación o la luz de una estrella), la función dependerá de tres coordenadas espaciales y el tiempo: $\Psi(x,y,z,t)$. En este caso, la derivada espacial de la ecuación unidimensional se sustituye por el operador Laplaciano ($\nabla^2$ o $\Delta$):

$$
\begin{aligned}
\nabla^2 \Psi = \dfrac{1}{v^2} \cdot \dfrac{\partial^2 \Psi}{\partial t^2}
\end{aligned}
$$

Donde el operador Laplaciano en coordenadas cartesianas se define como la suma de las segundas derivadas parciales espaciales: $\nabla^2 = \dfrac{\partial^2}{\partial x^2} + \dfrac{\partial^2}{\partial y^2} + \dfrac{\partial^2}{\partial z^2}$.

## 2. Modos normales y expansiones de Fourier en tres dimensiones

### 2.1. Modos normales en una cavidad rectangular

En una región tridimensional acotada, las condiciones de contorno seleccionan un conjunto discreto de modos normales. Consideremos una cavidad rectangular de lados $L_x$, $L_y$ y $L_z$, con el campo $\Psi$ anulado en todas sus paredes. Cada modo espacial permitido tiene la forma:

$$
\begin{aligned}
\Phi_{mnp}(x,y,z)
= \sin\left(\dfrac{m\pi x}{L_x}\right)
\sin\left(\dfrac{n\pi y}{L_y}\right)
\sin\left(\dfrac{p\pi z}{L_z}\right),
\end{aligned}
$$

donde $m$, $n$ y $p$ son enteros positivos. Al combinar esta parte espacial con una oscilación temporal, la frecuencia angular de cada modo es:

$$
\begin{aligned}
\omega_{mnp}
= v\pi\sqrt{
\left(\dfrac{m}{L_x}\right)^2
+ \left(\dfrac{n}{L_y}\right)^2
+ \left(\dfrac{p}{L_z}\right)^2}.
\end{aligned}
$$

Cada terna $(m,n,p)$ representa un patrón de vibración independiente, con nodos determinados por las paredes y por los ceros de las funciones seno. Estos modos son los análogos tridimensionales de los armónicos de una cuerda fija.

### 2.2. Expansión triple de Fourier y condiciones iniciales

La solución general se obtiene superponiendo todos los modos normales:

$$
\begin{aligned}
\Psi(x,y,z,t)
= \sum_{m=1}^{\infty} \sum_{n=1}^{\infty} \sum_{p=1}^{\infty}
\left[A_{mnp}\cos(\omega_{mnp}t)
+ B_{mnp}\sin(\omega_{mnp}t)\right]
\Phi_{mnp}(x,y,z).
\end{aligned}
$$

Para expresarlos de forma explícita, definimos el campo inicial $\Psi_0(x,y,z)=\Psi(x,y,z,0)$ y la velocidad inicial $V_0(x,y,z)=\left.\dfrac{\partial\Psi}{\partial t}\right|_{t=0}$. La ortogonalidad de los modos seno sobre la cavidad da:

$$
\begin{aligned}
A_{mnp} &= \dfrac{8}{L_xL_yL_z}
\int_0^{L_x}\int_0^{L_y}\int_0^{L_z}
\Psi_0(x,y,z) \\
&\quad \cdot \sin\left(\dfrac{m\pi x}{L_x}\right)
\sin\left(\dfrac{n\pi y}{L_y}\right) \\
&\quad \cdot
\sin\left(\dfrac{p\pi z}{L_z}\right)
\, dz\, dy\, dx,
\\
B_{mnp} &= \dfrac{8}{L_xL_yL_z\omega_{mnp}}
\int_0^{L_x}\int_0^{L_y}\int_0^{L_z}
V_0(x,y,z) \\
&\quad \cdot \sin\left(\dfrac{m\pi x}{L_x}\right)
\sin\left(\dfrac{n\pi y}{L_y}\right) \\
&\quad \cdot
\sin\left(\dfrac{p\pi z}{L_z}\right)
\, dz\, dy\, dx.
\end{aligned}
$$

La primera integral proyecta el campo inicial sobre el modo $(m,n,p)$. La segunda se obtiene derivando la expansión temporal, evaluándola en $t=0$ y proyectando la velocidad inicial; por eso incorpora el factor $1/\omega_{mnp}$. Cada coeficiente queda así determinado de manera independiente.

Por tanto, las expansiones de Fourier convierten el problema de una ecuación diferencial parcial en una familia infinita de osciladores armónicos independientes, uno por cada modo normal. En dominios con otra geometría se usan las funciones propias del Laplaciano adecuadas: funciones de Bessel en cavidades cilíndricas o esféricas, por ejemplo.

### 2.3. Geometría y elección de coordenadas

Las coordenadas naturales no se eligen por la dimensión del problema, sino por la geometría del dominio y de sus condiciones de contorno. Para una membrana rectangular o una cavidad paralelepipédica, las coordenadas cartesianas y las series de senos son las más adecuadas. En cambio, una frontera circular o cilíndrica sugiere coordenadas polares o cilíndricas; una frontera esférica sugiere coordenadas esféricas. En cada caso, las funciones propias del Laplaciano se adaptan a los bordes y forman la base de la expansión modal.

#### 2.3.1. Membrana circular: coordenadas polares y series de Fourier-Bessel

Para una membrana circular, con coordenadas polares $(r,\theta)$, el Laplaciano es:

$$
\begin{aligned}
\nabla^2 y
= \dfrac{\partial^2 y}{\partial r^2}
+ \dfrac{1}{r}\dfrac{\partial y}{\partial r}
+ \dfrac{1}{r^2}\dfrac{\partial^2 y}{\partial \theta^2}.
\end{aligned}
$$

La ecuación de ondas sigue siendo $\dfrac{\partial^2 y}{\partial t^2}=v^2\nabla^2y$, pero la separación de variables ya no genera senos en la coordenada radial, sino funciones de Bessel. Si el borde circular de radio $R$ está fijo, los modos espaciales tienen la forma:

$$
\begin{aligned}
J_m\left(\dfrac{\alpha_{mn}r}{R}\right)
\left[C_{mn}\cos(m\theta) + D_{mn}\sin(m\theta)\right],
\end{aligned}
$$

donde $J_m$ es la función de Bessel de primera especie y $\alpha_{mn}$ es el enésimo cero positivo de $J_m$. La condición $y(R,\theta,t)=0$ exige precisamente $J_m(\alpha_{mn})=0$. La frecuencia de cada modo es:

$$
\begin{aligned}
\omega_{mn} = \dfrac{v\alpha_{mn}}{R}.
\end{aligned}
$$

Una superposición de estos modos, con coeficientes temporales de seno y coseno, constituye una expansión de Fourier-Bessel. Es el análogo circular de la serie doble de Fourier usada para una membrana rectangular.

#### 2.3.2. Cavidad esférica: armónicos esféricos y Bessel esféricas

Para una cavidad esférica se usan coordenadas $(r,\theta,\varphi)$. El Laplaciano adopta la forma:

$$
\begin{aligned}
\nabla^2 \Psi
= \dfrac{1}{r^2}\dfrac{\partial}{\partial r}
\left(r^2\dfrac{\partial \Psi}{\partial r}\right)
+ \dfrac{1}{r^2\sin\theta}\dfrac{\partial}{\partial\theta}
\left(\sin\theta\dfrac{\partial\Psi}{\partial\theta}\right)
+ \dfrac{1}{r^2\sin^2\theta}\dfrac{\partial^2\Psi}{\partial\varphi^2}.
\end{aligned}
$$

La parte angular de los modos separados está descrita por los armónicos esféricos $Y_\ell^m(\theta,\varphi)$, mientras que la parte radial regular en el origen está descrita por las funciones de Bessel esféricas $j_\ell(kr)$. Para una esfera de radio $R$ con frontera fija, una base modal es:

$$
\begin{aligned}
j_\ell\left(\dfrac{\beta_{\ell n}r}{R}\right)
Y_\ell^m(\theta,\varphi),
\end{aligned}
$$

donde $\beta_{\ell n}$ es el enésimo cero positivo de $j_\ell$. Las frecuencias permitidas son $\omega_{\ell n}=v\beta_{\ell n}/R$. La solución se obtiene sumando estos modos con amplitudes determinadas por el campo y la velocidad iniciales.

#### 2.3.3. Espacio ilimitado: ondas planas y transformada de Fourier

Cuando no hay fronteras que impongan modos discretos, las ondas planas son la base más simple. Una componente plana en cualquier dimensión tiene la forma:

$$
\begin{aligned}
\Psi(\mathbf{r},t)
= A\,e^{i(\mathbf{k}\cdot\mathbf{r}-\omega t)},
\qquad \omega = v|\mathbf{k}|.
\end{aligned}
$$

La solución general se expresa entonces mediante una transformada de Fourier, es decir, una superposición continua de vectores de onda $\mathbf{k}$ en lugar de una suma discreta de modos. Así, las series de Fourier son apropiadas para dominios acotados, mientras que la transformada de Fourier es la formulación natural en espacio ilimitado.

## 3. Funcionales y cálculo de variaciones

### 3.1. Funcionales y optimización variacional

El cálculo de variaciones estudia problemas en los que no se busca el mejor número, sino la mejor función. Para ello se usa un **funcional**: una regla que recibe una función completa como entrada y devuelve un número real. Por ejemplo, una expresión de la forma

$$
\begin{aligned}
J[y] = \int_a^b F(x, y(x), y'(x)) \, dx
\end{aligned}
$$

asigna un número $J[y]$ a cada curva admisible $y(x)$. Las condiciones de contorno, como fijar $y(a)$ e $y(b)$, delimitan qué funciones pueden considerarse.

El problema de optimización variacional consiste en encontrar la función admisible para la cual el funcional alcanza un valor mínimo, máximo o, más generalmente, estacionario. El último caso es el análogo funcional de imponer que una derivada ordinaria sea cero.

#### 3.1.1. El problema de optimización variacional: funcionales frente a funciones

Antes de aplicar estas ideas a la mecánica, conviene distinguir con precisión entre funciones y funcionales. A menudo se dice coloquialmente que "minimizamos la función $f$ con respecto a $\mathcal{L}$", pero esto es una imprecisión.

En el cálculo diferencial ordinario, optimizamos una función (ej. $y(x)$): buscamos un número $x$ que nos devuelva el valor mínimo de $y$, haciendo $\dfrac{dy}{dx} = 0$.

En el cálculo de variaciones, sin embargo, optimizamos un funcional (en este caso, la Acción $S$). Un funcional toma como argumento una función entera y devuelve un número real. El espacio de búsqueda no es la recta de los números reales, sino un espacio de dimensión infinita que contiene todas las posibles formas que podría adoptar el campo $f(x,t)$ entre las fronteras fijadas.

No minimizamos la función $f$ punto a punto; buscamos cuál es el "camino" o "superficie" completa que hace estacionario el número global producido por el funcional. En mecánica, ese funcional recibirá el nombre de acción y se aplicará el Principio de Hamilton: $\delta S = 0$.

#### 3.1.2. Primera variación de un funcional y ecuación de Euler-Lagrange

Veamos de dónde surge la condición que debe satisfacer una curva estacionaria para el funcional general:

$$
\begin{aligned}
J[y] = \int_a^b F(x,y(x),y'(x))\,dx.
\end{aligned}
$$

Partimos de una curva candidata $y(x)$ cuyos extremos están fijados. Para compararla con curvas próximas, elegimos una función suave arbitraria $\eta(x)$ que se anula en los extremos, $\eta(a)=\eta(b)=0$, e introducimos una familia de variaciones:

$$
\begin{aligned}
y_\epsilon(x) = y(x) + \epsilon\eta(x),
\qquad
y_\epsilon'(x) = y'(x) + \epsilon\eta'(x),
\end{aligned}
$$

donde $\epsilon$ es un número real pequeño. Ahora el funcional deja de depender directamente de una función y pasa a ser una función ordinaria del parámetro $\epsilon$:

$$
\begin{aligned}
\Phi(\epsilon)
= J[y_\epsilon]
= \int_a^b F\left(x,y(x)+\epsilon\eta(x),y'(x)+\epsilon\eta'(x)\right)\,dx.
\end{aligned}
$$

Si $y$ hace estacionario el funcional, entonces $\Phi$ debe ser estacionaria en $\epsilon=0$. La primera variación se define como $\delta J=\Phi'(0)$; por tanto, la condición de estacionariedad es $\delta J=0$. Derivando bajo el signo integral y aplicando la regla de la cadena se obtiene:

$$
\begin{aligned}
\delta J
= \left.\dfrac{d\Phi}{d\epsilon}\right|_{\epsilon=0} \\
&= \int_a^b
\left[
\dfrac{\partial F}{\partial y}\eta
+ \dfrac{\partial F}{\partial y'}\eta'
\right]dx.
\end{aligned}
$$

El segundo término contiene la derivada de la variación. Lo reescribimos mediante integración por partes:

$$
\begin{aligned}
\int_a^b \dfrac{\partial F}{\partial y'}\eta'\,dx
= \left[\dfrac{\partial F}{\partial y'}\eta\right]_a^b
- \int_a^b \dfrac{d}{dx}\left(\dfrac{\partial F}{\partial y'}\right)\eta\,dx.
\end{aligned}
$$

El término de borde es nulo porque $\eta(a)=\eta(b)=0$. Al sustituirlo en la primera variación queda:

$$
\begin{aligned}
\delta J
= \int_a^b
\left[
\dfrac{\partial F}{\partial y}
- \dfrac{d}{dx}\left(\dfrac{\partial F}{\partial y'}\right)
\right]\eta(x)\,dx.
\end{aligned}
$$

La función $\eta(x)$ puede escogerse arbitrariamente en el interior del intervalo. Por el lema fundamental del cálculo de variaciones, la única forma de que esta integral sea cero para toda variación admisible es que el corchete se anule punto a punto:

$$
\begin{aligned}
\dfrac{\partial F}{\partial y}
- \dfrac{d}{dx}\left(\dfrac{\partial F}{\partial y'}\right) = 0.
\end{aligned}
$$

Esta es la ecuación de Euler-Lagrange unidimensional. Es la expresión general de la condición $\delta J=0$ y será la ecuación que aplicaremos al funcional de tiempo de la braquistócrona.

#### 3.1.3. Extensión a campos: funcionales de $f(x,t)$

En los problemas de ondas no buscamos una curva $y(x)$, sino un campo $f(x,t)$ que asigna un valor a cada punto del espacio-tiempo. El análogo bidimensional del funcional anterior integra sobre una región $\Omega$ del plano $(x,t)$:

$$
\begin{aligned}
S[f]
= \int_{t_1}^{t_2}\int_{x_1}^{x_2}
\mathcal{L}\left(
f,
\dfrac{\partial f}{\partial t},
\dfrac{\partial f}{\partial x},
x,t
\right)\,dx\,dt.
\end{aligned}
$$

Este funcional se llama **acción** cuando $\mathcal{L}$ es una densidad lagrangiana. Para variar el campo, elegimos una perturbación suave $\eta(x,t)$ que se anula en el borde de la región $\Omega$, y definimos:

$$
\begin{aligned}
f_\epsilon(x,t) = f(x,t) + \epsilon\eta(x,t).
\end{aligned}
$$

Sus derivadas varían de forma coherente:

$$
\begin{aligned}
\dfrac{\partial f_\epsilon}{\partial t}
= \dfrac{\partial f}{\partial t}
+ \epsilon\dfrac{\partial\eta}{\partial t},
\\
\dfrac{\partial f_\epsilon}{\partial x}
= \dfrac{\partial f}{\partial x}
+ \epsilon\dfrac{\partial\eta}{\partial x}.
\end{aligned}
$$

Como antes, introducimos $\Phi(\epsilon)=S[f_\epsilon]$ y exigimos que $\Phi'(0)=\delta S=0$. La regla de la cadena aplicada al integrando proporciona:

$$
\begin{aligned}
\delta S
= \int_{t_1}^{t_2}\int_{x_1}^{x_2}
\Bigg[
\dfrac{\partial\mathcal{L}}{\partial f}\eta
+ \dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial t}\right)}
\dfrac{\partial\eta}{\partial t}
+ \dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial x}\right)}
\dfrac{\partial\eta}{\partial x}
\Bigg]dx\,dt.
\end{aligned}
$$

Integramos por partes los dos términos que contienen derivadas de $\eta$. Los términos de borde se anulan porque la variación es nula en el contorno. Por tanto:

$$
\begin{aligned}
\delta S
= \int_{t_1}^{t_2}\int_{x_1}^{x_2}
\Bigg[
\dfrac{\partial\mathcal{L}}{\partial f}
- \dfrac{\partial}{\partial t}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial t}\right)}\right)
- \dfrac{\partial}{\partial x}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial x}\right)}\right)
\Bigg]\eta(x,t)\,dx\,dt.
\end{aligned}
$$

Puesto que $\eta(x,t)$ es arbitraria en el interior de $\Omega$, el lema fundamental conduce a la ecuación de Euler-Lagrange para un campo en una dimensión espacial:

$$
\begin{aligned}
\dfrac{\partial\mathcal{L}}{\partial f}
- \dfrac{\partial}{\partial t}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial t}\right)}\right)
- \dfrac{\partial}{\partial x}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial x}\right)}\right)
= 0.
\end{aligned}
$$

La expresión unidimensional anterior se recupera si el campo depende sólo de $x$. En más dimensiones espaciales aparecen un término análogo por cada derivada espacial del campo.

#### 3.1.4. Ecuación de Euler-Lagrange en tres dimensiones espaciales

Si el campo depende de las tres coordenadas espaciales y del tiempo, $f=f(x,y,z,t)$, la acción se integra sobre un volumen espacial y un intervalo temporal:

$$
\begin{aligned}
S[f]
= \int_{t_1}^{t_2}\int_V
\mathcal{L}\left(
f,
\dfrac{\partial f}{\partial t},
\dfrac{\partial f}{\partial x},
\dfrac{\partial f}{\partial y},
\dfrac{\partial f}{\partial z},
x,y,z,t
\right)\,dV\,dt.
\end{aligned}
$$

A la vista del resultado para $x$ y $t$, no hace falta repetir toda la deducción: se integra por partes una vez por cada derivada de la variación. Si $\eta$ se anula en la frontera espacial y en los instantes extremos, los cuatro términos de borde desaparecen. La ecuación resultante es:

$$
\begin{aligned}
\dfrac{\partial\mathcal{L}}{\partial f}
&- \dfrac{\partial}{\partial t}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial t}\right)}\right)
- \dfrac{\partial}{\partial x}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial x}\right)}\right) \\
&- \dfrac{\partial}{\partial y}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial y}\right)}\right)
- \dfrac{\partial}{\partial z}
\left(\dfrac{\partial\mathcal{L}}{\partial\left(\dfrac{\partial f}{\partial z}\right)}\right)
= 0.
\end{aligned}
$$

La pauta es transparente: además del término temporal ya conocido, aparece un término de Euler-Lagrange por cada dirección espacial. Para varios campos $f_a$, se obtiene una ecuación de esta forma para cada índice $a$.

### 3.2. Ejemplo: la braquistócrona

Para comprender la optimización de funcionales fuera del contexto abstracto de la mecánica analítica, consideremos uno de los problemas históricos que dio origen al cálculo de variaciones en 1696: el problema de la braquistócrona.

Imagina dos puntos $A$ (origen $0,0$) y $B$ (donde $B$ está más abajo y desplazado horizontalmente). Buscamos la forma exacta de un alambre, definido por una curva $y(x)$, por el cual una cuenta resbalará sin fricción bajo el efecto de la gravedad en el menor tiempo posible. Para simplificar los signos, diremos que la gravedad actúa en el eje $+y$ (hacia abajo).

Buscamos una función $y(x)$ que minimice el funcional del Tiempo total ($T$). Sabemos que el tiempo es la integral de la distancia sobre la velocidad ($dt = ds / v$). Usando el teorema de Pitágoras para el elemento de arco infinitesimal ($ds = \sqrt{dx^2 + dy^2} = \sqrt{1 + (y')^2} dx$, donde $y' = \dfrac{dy}{dx}$) y la conservación de energía para aislar la velocidad ($E_{cinetica} = E_{potencial} \implies \dfrac{1}{2}mv^2 = mgy \implies v = \sqrt{2gy}$), el funcional del tiempo queda como:

$$
\begin{aligned}
T[y(x)] = \int_{0}^{x_B} \dfrac{\sqrt{1 + (y')^2}}{\sqrt{2gy}} dx
\end{aligned}
$$

En este problema estrictamente matemático y geométrico, el integrando es nuestra función objetivo, comportándose analíticamente igual que una densidad Lagrangiana:

$$
\begin{aligned}
\mathcal{L}(y, y', x) = \dfrac{\sqrt{1 + (y')^2}}{\sqrt{2gy}}
\end{aligned}
$$

Resolución paso a paso: La Identidad de Beltrami

Para encontrar la curva $y(x)$ que minimiza este funcional, debemos aplicar la Ecuación de Euler-Lagrange unidimensional:

$$
\begin{aligned}
\dfrac{d}{dx}\left( \dfrac{\partial \mathcal{L}}{\partial y'} \right) - \dfrac{\partial \mathcal{L}}{\partial y} = 0
\end{aligned}
$$

Sin embargo, calcular estas derivadas completas directamente conduce a un álgebra extremadamente tediosa. Afortunadamente, notamos una propiedad crucial en nuestra $\mathcal{L}$: no depende explícitamente de la coordenada $x$ (la $x$ no aparece en la fórmula, solo $y$ y $y'$).

Cuando esto ocurre en el cálculo de variaciones, la Ecuación de Euler-Lagrange se simplifica en una constante de movimiento (una primera integral) conocida como la Identidad de Beltrami:

$$
\begin{aligned}
\mathcal{L} - y' \dfrac{\partial \mathcal{L}}{\partial y'} = C
\end{aligned}
$$

Vamos a aplicar esto paso a paso. Primero, calculemos la derivada parcial de $\mathcal{L}$ respecto a $y'$:

$$
\begin{aligned}
\dfrac{\partial \mathcal{L}}{\partial y'} = \dfrac{1}{\sqrt{2gy}} \cdot \dfrac{1}{2\sqrt{1 + (y')^2}} \cdot 2y' = \dfrac{y'}{\sqrt{2gy}\sqrt{1 + (y')^2}}
\end{aligned}
$$

Ahora introducimos $\mathcal{L}$ y esta derivada en la Identidad de Beltrami:

$$
\begin{aligned}
\dfrac{\sqrt{1 + (y')^2}}{\sqrt{2gy}} - y' \left( \dfrac{y'}{\sqrt{2gy}\sqrt{1 + (y')^2}} \right) = C
\end{aligned}
$$

Podemos agrupar la constante de gravedad $\dfrac{1}{\sqrt{2g}}$ junto con la constante arbitraria $C$ del lado derecho (creando una nueva constante $C_1$), dejándonos con:

$$
\begin{aligned}
\dfrac{\sqrt{1 + (y')^2}}{\sqrt{y}} - \dfrac{(y')^2}{\sqrt{y}\sqrt{1 + (y')^2}} = C_1
\end{aligned}
$$

Para restar estas fracciones, multiplicamos el primer término arriba y abajo por $\sqrt{1 + (y')^2}$ para buscar un denominador común:

$$
\begin{aligned}
\dfrac{1 + (y')^2 - (y')^2}{\sqrt{y}\sqrt{1 + (y')^2}} = C_1 \implies \dfrac{1}{\sqrt{y(1 + (y')^2)}} = C_1
\end{aligned}
$$

Si elevamos al cuadrado ambos lados e invertimos la fracción, la constante al cuadrado e invertida seguirá siendo una constante, que por conveniencia geométrica llamaremos $2r$:

$$
\begin{aligned}
y(1 + (y')^2) = \dfrac{1}{C_1^2} = 2r
\end{aligned}
$$

¡Hemos llegado a la ecuación diferencial de la curva óptima! Despejando la pendiente $y'$ (que es $\dfrac{dy}{dx}$):

$$
\begin{aligned}
(y')^2 = \dfrac{2r - y}{y} \implies \dfrac{dy}{dx} = \sqrt{\dfrac{2r - y}{y}}
\end{aligned}
$$

Esta no es la ecuación de una línea recta, ni de una parábola. Esta es la clásica ecuación diferencial de una cicloide invertida. La solución paramétrica que satisface esta ecuación es:

$$
\begin{aligned}
x(\theta) = r(\theta - \sin \theta)
\end{aligned}
$$

$$
\begin{aligned}
y(\theta) = r(1 - \cos \theta)
\end{aligned}
$$

Físicamente, una cicloide es la curva trazada por un punto en el borde de una rueda de radio $r$ a medida que rueda sin deslizar. Resulta que la naturaleza "sabe" calcular variaciones: el camino más rápido para caer bajo la gravedad no es la distancia más corta (línea recta), sino dejarse caer de forma más pronunciada al principio para ganar velocidad rápidamente, siguiendo una cicloide.

(Nota: De forma análoga, el problema isoperimétrico busca la curva cerrada $y(x)$ que maximice el funcional del Área contenida, dado un perímetro constante, cuya solución variacional resulta ser un círculo).

### 3.3. Variaciones y derivada funcional

Para estudiar si un funcional es estacionario, se compara una función candidata $f_0$ con funciones próximas de la forma $f_\epsilon = f_0 + \epsilon \eta$, donde $\epsilon$ es un parámetro real pequeño y $\eta$ es una perturbación suave que respeta las condiciones de contorno. La **primera variación** es el cambio lineal del funcional al variar $\epsilon$ alrededor de cero.

La derivada funcional $\dfrac{\delta J}{\delta f}$ desempeña para un funcional $J[f]$ el papel que la derivada ordinaria desempeña para una función de una variable. La condición $\delta J = 0$ expresa que ninguna perturbación admisible cambia el valor de $J$ en primer orden. En el caso de la acción mecánica, esta condición conduce a las ecuaciones de Euler-Lagrange.

## 4. El formalismo lagrangiano

El formalismo lagrangiano es una reformulación de la mecánica clásica que, en lugar de basarse en fuerzas vectoriales, se fundamenta en principios energéticos y variacionales. Resulta especialmente potente al extenderse a medios continuos y campos, como en la propagación de ondas.

Para un sistema continuo, por ejemplo el desplazamiento transversal de una cuerda, el estado está descrito por un campo $f(x,t)$. La densidad lagrangiana $\mathcal{L}$ asigna una expresión local a cada punto del espacio-tiempo a partir del campo, de sus derivadas y, en el caso general, de la posición y del tiempo de forma explícita:

$$
\begin{aligned}
\mathcal{L}
= \mathcal{L}\left(
f,
\dfrac{\partial f}{\partial t},
\dfrac{\partial f}{\partial x},
x,t
\right).
\end{aligned}
$$

La dependencia explícita de $x$ o $t$ no debe confundirse con la dependencia implícita que ya aparece a través de $f(x,t)$. Si $\mathcal{L}$ no depende explícitamente de $x$, el sistema es homogéneo en el espacio; si no depende explícitamente de $t$, es homogéneo en el tiempo. Esta última simetría está asociada, por el teorema de Noether, a la conservación de la energía. Una cuerda cuyo tensado cambia externamente con el tiempo es un ejemplo de sistema con dependencia explícita de $t$.

La acción $S$ es el funcional que se obtiene al integrar esa densidad sobre la región de espacio-tiempo considerada:

$$
\begin{aligned}
S[f]
= \int_{t_1}^{t_2} \int_{x_1}^{x_2}
\mathcal{L}\left(
f,
\dfrac{\partial f}{\partial t},
\dfrac{\partial f}{\partial x},
x,t
\right)dx \, dt.
\end{aligned}
$$

El Principio de Hamilton establece que el campo físico es aquel para el que esta acción es estacionaria: $\delta S = 0$.

### 4.1. Ecuaciones de Euler-Lagrange para campos continuos

Volviendo a nuestro sistema físico continuo, para encontrar esa función $f$ óptima, sometemos el campo a una variación infinitesimal $f \rightarrow f + \delta f$. Asumimos que esta variación se anula en los bordes de integración espaciales y temporales (es decir, el sistema empieza y acaba en estados fijos conocidos, por lo que $\delta f = 0$ en $x_1, x_2, t_1, t_2$).

La variación total de la Acción $S$ ante este pequeño cambio arbitrario de la función viene dada por la regla de la cadena para múltiples variables, aplicada al integrando $\mathcal{L}$:

$$
\begin{aligned}
\delta S = \int \int \left[ \dfrac{\partial \mathcal{L}}{\partial f}\delta f + \dfrac{\partial \mathcal{L}}{\partial \left( \dfrac{\partial f}{\partial t} \right)}\delta \left( \dfrac{\partial f}{\partial t} \right) + \dfrac{\partial \mathcal{L}}{\partial \left( \dfrac{\partial f}{\partial x} \right)}\delta \left( \dfrac{\partial f}{\partial x} \right) \right] dx \, dt = 0
\end{aligned}
$$

Justificación matemática: Conmutación de $\delta$ y $\partial$

Para continuar operando matemáticamente, necesitamos poder intercambiar el operador variación ($\delta$) con la derivada espacial o temporal (por ejemplo, asumiendo que $\delta(\partial_t f) = \partial_t (\delta f)$).

Para justificar esto de forma rigurosa, definamos qué es exactamente una "variación" $\delta f$. Imaginemos la función del campo real (la solución física) $f_0(x,t)$ y perturbémosla sumándole una función suave y totalmente arbitraria $\eta(x,t)$ (que se anula en las fronteras), ponderada por un parámetro escalar minúsculo $\epsilon$:

$$
\begin{aligned}
f(x,t,\epsilon) = f_0(x,t) + \epsilon \cdot \eta(x,t)
\end{aligned}
$$

El operador variación $\delta$ representa matemáticamente la diferencial respecto a este nuevo parámetro $\epsilon$, evaluada en cero:

$$
\begin{aligned}
\delta f = \left. \dfrac{\partial f}{\partial \epsilon} \right\vert{}_{\epsilon=0} d\epsilon = \eta(x,t) \, d\epsilon
\end{aligned}
$$

Dado que las coordenadas del espacio ($x$), el tiempo ($t$) y el parámetro de variación abstracta ($\epsilon$) son variables completamente independientes, sus derivadas parciales mixtas conmutan según el Teorema de Clairaut-Schwarz (siempre que las funciones sean suficientemente continuas). Por lo tanto:

$$
\begin{aligned}
\delta \left( \dfrac{\partial f}{\partial t} \right) = \dfrac{\partial}{\partial \epsilon} \left( \dfrac{\partial f}{\partial t} \right) d\epsilon = \dfrac{\partial}{\partial t} \left( \dfrac{\partial f}{\partial \epsilon} \right) d\epsilon = \dfrac{\partial}{\partial t} (\delta f)
\end{aligned}
$$

Esta independencia lineal entre el espacio-tiempo y el "espacio de las variaciones" es lo que nos garantiza el derecho a sacar la derivada fuera de la variación.

Integración por partes y la Derivada Funcional

Volviendo a la ecuación original $\delta S=0$ y sabiendo que podemos conmutar operadores, reescribimos el segundo y tercer término, para luego aplicar integración por partes (la regla del producto de derivadas a la inversa).

Al integrar por partes, aparecen términos evaluados en las fronteras de integración. Sin embargo, como hemos establecido como restricción fundamental que la variación es nula en los bordes ($\delta f = 0$), esos términos evaluados en la frontera matemática desaparecen. Solo nos quedan los nuevos integrandos con un signo menos:

$$
\begin{aligned}
\delta S = \int \int \left[ \dfrac{\partial \mathcal{L}}{\partial f} - \dfrac{\partial}{\partial t}\left( \dfrac{\partial \mathcal{L}}{\partial \left(\dfrac{\partial f}{\partial t}\right)} \right) - \dfrac{\partial}{\partial x}\left( \dfrac{\partial \mathcal{L}}{\partial \left(\dfrac{\partial f}{\partial x}\right)} \right) \right] \delta f \, dx \, dt = 0
\end{aligned}
$$

Al corchete de esta integral se le conoce matemáticamente como la derivada funcional de la Acción $S$ respecto al campo $f(x,t)$ (denotada comúnmente como $\dfrac{\delta S}{\delta f}$).

Para que esta integral doble sea idénticamente igual a cero, independientemente de la forma caprichosa que tenga la variación arbitraria $\delta f$ que hayamos elegido, el corchete entero (la derivada funcional) debe ser forzosamente nulo en todo punto del espacio-tiempo. Este es el Lema Fundamental del Cálculo de Variaciones.

Esto nos conduce a la magistral Ecuación de Euler-Lagrange para campos continuos:

$$
\begin{aligned}
\dfrac{\partial}{\partial t}\left( \dfrac{\partial \mathcal{L}}{\partial \left(\dfrac{\partial f}{\partial t}\right)} \right) + \dfrac{\partial}{\partial x}\left( \dfrac{\partial \mathcal{L}}{\partial \left(\dfrac{\partial f}{\partial x}\right)} \right) - \dfrac{\partial \mathcal{L}}{\partial f} = 0
\end{aligned}
$$

Cualquier sistema físico continuo descrito por una densidad lagrangiana $\mathcal{L}$ obedecerá esta ecuación diferencial, asegurando así que la Acción del sistema se mantenga minimizada/estacionaria.

### 4.2. Sistemas discretos de partículas

Hasta ahora hemos tratado medios continuos mediante una densidad lagrangiana ($\mathcal{L}$) integrada sobre el volumen. Sin embargo, en mecánica clásica es muy habitual tratar con sistemas discretos compuestos por $N$ puntos materiales (partículas puntuales) con masa.

Para este tipo de sistemas, ya no integramos sobre el espacio, sino que definimos la posición del sistema mediante un conjunto de coordenadas generalizadas $q_i$. Si tenemos $N$ partículas moviéndose en 3 dimensiones, necesitaremos $3N$ coordenadas (por ejemplo, $q_1 = x_1, q_2 = y_1, q_3 = z_1, q_4 = x_2...$ hasta $q_{3N}$).

Las derivadas temporales de estas coordenadas se denominan velocidades generalizadas, expresadas mediante la notación de punto de Newton:

$$
\begin{aligned}
\dot{q}_i = \dfrac{dq_i}{dt}
\end{aligned}
$$

En este contexto discreto, el operador que define al sistema se convierte en una función escalar llamada el Lagrangiano ($L$), que depende explícitamente de las coordenadas generalizadas, las velocidades generalizadas y, opcionalmente, del tiempo:

$$
\begin{aligned}
L = L(q_1, q_2, ..., q_{3N}, \dot{q}_1, \dot{q}_2, ..., \dot{q}_{3N}, t) \equiv L(q_i, \dot{q}_i, t)
\end{aligned}
$$

La Acción se define ahora como una única integral en el tiempo del Lagrangiano a lo largo de la trayectoria del sistema entre un estado inicial $t_1$ y uno final $t_2$:

$$
\begin{aligned}
S = \int_{t_1}^{t_2} L(q_i, \dot{q}_i, t) dt
\end{aligned}
$$

Aplicando el Principio de Hamilton ($\delta S = 0$) y la misma maquinaria de cálculo de variaciones (integración por partes en una sola variable, el tiempo), obtenemos un conjunto de $3N$ ecuaciones diferenciales ordinarias acopladas:

$$
\begin{aligned}
\dfrac{d}{dt}\left( \dfrac{\partial L}{\partial \dot{q}_i} \right) - \dfrac{\partial L}{\partial q_i} = 0
\end{aligned}
$$

Estas son las Ecuaciones de Euler-Lagrange para sistemas discretos. Cada término tiene un significado físico directo:

1. El término $\dfrac{\partial L}{\partial \dot{q}_i}$ se define como el momento generalizado (o momento conjugado) $p_i$. (Si $L = \dfrac{1}{2}m\dot{x}^2 - V(x)$, entonces $\dfrac{\partial L}{\partial \dot{x}} = m\dot{x} = p_x$).
2. El término $\dfrac{\partial L}{\partial q_i}$ se define como la fuerza generalizada $F_i$. (Si $V$ solo depende de $x$, entonces $\dfrac{\partial L}{\partial x} = -\dfrac{\partial V}{\partial x} = F_x$).

Sustituyendo estas definiciones, la ecuación se lee como $\dfrac{d p_i}{dt} = F_i$, lo que demuestra que el formalismo lagrangiano recupera maravillosamente la Segunda Ley de Newton, pero con la enorme ventaja de que las ecuaciones de Euler-Lagrange mantienen exactamente la misma forma matemática independientemente del sistema de coordenadas elegido (cartesianas, polares, cilíndricas o variables abstractas).

### 4.3. Por qué $L = T - V$: el puente desde Newton

Es común ver definido el Lagrangiano como la diferencia entre la Energía Cinética Total ($T$) y la Energía Potencial ($V$):

$$
\begin{aligned}
L = T - V
\end{aligned}
$$

Pero, ¿de dónde sale esta estructura exacta? No es un capricho; es la consecuencia matemática de obligar a las ecuaciones de Euler-Lagrange a ser idénticas a la Segunda Ley de Newton en presencia de fuerzas conservativas.

Veámoslo para una única partícula en una dimensión (coordenada $x$). La Segunda Ley de Newton nos dice:

$$
\begin{aligned}
m \ddot{x} = F_x
\end{aligned}
$$

Si la fuerza es conservativa, deriva de un potencial $V(x)$, de modo que $F_x = -\dfrac{\partial V}{\partial x}$. Sustituyendo:

$$
\begin{aligned}
m \ddot{x} = -\dfrac{\partial V}{\partial x}
\end{aligned}
$$

Por otro lado, la energía cinética de la partícula es $T = \dfrac{1}{2}m\dot{x}^2$. Notemos dos propiedades matemáticas de $T$:

1. Si derivamos $T$ respecto a la velocidad $\dot{x}$, obtenemos el momento: $\dfrac{\partial T}{\partial \dot{x}} = m\dot{x}$. Si a esto le aplicamos la derivada temporal, recuperamos la fuerza inercial (masa por aceleración): $\dfrac{d}{dt}\left( \dfrac{\partial T}{\partial \dot{x}} \right) = m\ddot{x}$.
2. Si derivamos $T$ respecto a la posición $x$, el resultado es cero (en coordenadas cartesianas, la energía cinética no depende de dónde estés, solo de lo rápido que vayas): $\dfrac{\partial T}{\partial x} = 0$.

Con esto en mente, podemos reescribir el término $m\ddot{x}$ de la ley de Newton usando exclusivamente derivadas de la energía cinética:

$$
\begin{aligned}
\dfrac{d}{dt}\left( \dfrac{\partial T}{\partial \dot{x}} \right) = -\dfrac{\partial V}{\partial x}
\end{aligned}
$$

Reagrupemos todos los términos en el lado izquierdo:

$$
\begin{aligned}
\dfrac{d}{dt}\left( \dfrac{\partial T}{\partial \dot{x}} \right) + \dfrac{\partial V}{\partial x} = 0
\end{aligned}
$$

Aquí viene el truco final. Dado que la energía potencial $V(x)$ depende únicamente de la posición y no de la velocidad, su derivada parcial respecto a la velocidad es cero ($\dfrac{\partial V}{\partial \dot{x}} = 0$). Y, como ya vimos, $\dfrac{\partial T}{\partial x} = 0$. Esto nos permite "engañar" a la ecuación agrupando ambas energías bajo las mismas derivadas sin alterar el resultado matemático:

$$
\begin{aligned}
\dfrac{d}{dt}\left( \dfrac{\partial (T - V)}{\partial \dot{x}} \right) - \dfrac{\partial (T - V)}{\partial x} = 0
\end{aligned}
$$

¡Esta es exactamente la ecuación de Euler-Lagrange! Si comparamos esta expresión con la forma general $\dfrac{d}{dt}\left( \dfrac{\partial L}{\partial \dot{x}} \right) - \dfrac{\partial L}{\partial x} = 0$, la conclusión es inevitable: el operador $L$ que hace que el principio variacional reproduzca la dinámica newtoniana conservativa debe ser, por definición, $L = T - V$.

(Nota: En sistemas mecánicos complejos con vínculos y coordenadas generalizadas abstractas $q_i$, se utiliza el Principio de d'Alembert (o de los Trabajos Virtuales) para demostrar de forma más rigurosa que esta misma estructura $L = T - V$ se mantiene inviolable).

## 5. Introducción a la transformada de Legendre

La transformada de Legendre permite sustituir una variable por la derivada de una función respecto de esa variable. Para una función diferenciable $F(v)$, se introduce la variable conjugada $p = \dfrac{dF}{dv}$ y se define una nueva función:

$$
\begin{aligned}
G(p) = p v - F(v),
\end{aligned}
$$

entendiendo que $v$ se expresa en función de $p$ cuando la relación puede invertirse. Esta transformación conserva la información de $F$, pero la describe mediante la variable conjugada $p$.

## 6. Introducción al formalismo hamiltoniano

El formalismo lagrangiano $L(q_i, \dot{q}_i, t)$ formula la dinámica en el espacio de configuración, definido por las coordenadas generalizadas $q_i$. La mecánica hamiltoniana aplica la transformada de Legendre a las velocidades $\dot{q}_i$ para usar, en su lugar, los momentos conjugados $p_i$. Así se obtiene una descripción en el espacio de fases, cuyas coordenadas son los pares $(q_i,p_i)$.

### 6.1. Construcción del Hamiltoniano mediante la transformada de Legendre

Como vimos en la sección anterior, el momento generalizado o momento conjugado se define a partir del Lagrangiano como:

$$
\begin{aligned}
p_i = \dfrac{\partial L}{\partial \dot{q}_i}
\end{aligned}
$$

Nuestro objetivo ahora es crear una nueva función, el Hamiltoniano ($H$), que dependa exclusivamente de posiciones, momentos y del tiempo: $H(q_i, p_i, t)$. Para lograr este cambio de variables, las matemáticas nos ofrecen una herramienta específica: la Transformada de Legendre.

La transformada de Legendre nos permite pasar de una función que depende de una variable (en este caso, $\dot{q}_i$) a otra función que dependa de la derivada de esa variable respecto a la función original (es decir, $p_i$). La definición general del Hamiltoniano se construye así:

$$
\begin{aligned}
H(q_i, p_i, t) = \sum_{i} p_i \dot{q}_i - L(q_i, \dot{q}_i, t)
\end{aligned}
$$

### 6.2. Deducción de las ecuaciones canónicas de Hamilton

Para descubrir qué forma toman las ecuaciones de movimiento en este nuevo marco, vamos a calcular la diferencial total (el cambio infinitesimal) del Hamiltoniano de dos maneras distintas y compararlas.

#### Primer método: usando la definición de la transformada de Legendre

Si diferenciamos la ecuación $H = \sum p_i \dot{q}_i - L$, aplicando la regla del producto y la regla de la cadena para la diferencial de $L(q_i, \dot{q}_i, t)$, obtenemos:

$$
\begin{aligned}
dH = \sum_{i} (\dot{q}_i dp_i + p_i d\dot{q}_i) - \left[ \sum_{i} \left( \dfrac{\partial L}{\partial q_i} dq_i + \dfrac{\partial L}{\partial \dot{q}_i} d\dot{q}_i \right) + \dfrac{\partial L}{\partial t} dt \right]
\end{aligned}
$$

Ahora usamos nuestras dos definiciones clave provenientes del formalismo lagrangiano:

1. $p_i = \dfrac{\partial L}{\partial \dot{q}_i}$ (definición de momento).
2. $\dot{p}_i = \dfrac{\partial L}{\partial q_i}$ (es la propia Ecuación de Euler-Lagrange, $\dfrac{d p_i}{dt} = \dfrac{\partial L}{\partial q_i}$).

Sustituyendo esto en el corchete:

$$
\begin{aligned}
dH = \sum_{i} (\dot{q}_i dp_i + p_i d\dot{q}_i) - \sum_{i} (\dot{p}_i dq_i + p_i d\dot{q}_i) - \dfrac{\partial L}{\partial t} dt
\end{aligned}
$$

Notamos que el término $p_i d\dot{q}_i$ aparece sumando y restando, por lo que se cancela de forma espectacular. Esto es el núcleo de la transformada de Legendre: elimina la dependencia de los diferenciales de velocidad ($d\dot{q}_i$). Nos queda:

$$
\begin{aligned}
dH = \sum_{i} (\dot{q}_i dp_i - \dot{p}_i dq_i) - \dfrac{\partial L}{\partial t} dt
\end{aligned}
$$

#### Segundo método: diferenciando el Hamiltoniano como función de sus propias variables

Sabemos por definición que $H$ es una función de $q_i$, $p_i$ y $t$. Su diferencial total formal en cálculo multivariable es:

$$
\begin{aligned}
dH = \sum_{i} \left( \dfrac{\partial H}{\partial q_i} dq_i + \dfrac{\partial H}{\partial p_i} dp_i \right) + \dfrac{\partial H}{\partial t} dt
\end{aligned}
$$

Igualando coeficientes:

Como ambos métodos deben darnos el mismo diferencial $dH$, podemos igualar término a término los coeficientes que acompañan a $dq_i$, $dp_i$ y $dt$. Esto nos proporciona el sistema de ecuaciones fundamentales de la mecánica hamiltoniana, conocidas como Ecuaciones Canónicas de Hamilton:

$$
\begin{aligned}
\dot{q}_i = \dfrac{\partial H}{\partial p_i}
\end{aligned}
$$

$$
\begin{aligned}
\dot{p}_i = -\dfrac{\partial H}{\partial q_i}
\end{aligned}
$$

Y adicionalmente: $\dfrac{\partial H}{\partial t} = -\dfrac{\partial L}{\partial t}$.

A diferencia del formalismo lagrangiano, que nos daba $N$ ecuaciones diferenciales de segundo orden, el formalismo hamiltoniano nos proporciona $2N$ ecuaciones diferenciales acopladas de primer orden. Estas ecuaciones dictan cómo fluye el sistema trazando una única e inequívoca trayectoria a través del espacio de las fases de $2N$ dimensiones.

## 7. Significado físico del Hamiltoniano

En la inmensa mayoría de los sistemas mecánicos convencionales (específicamente aquellos donde las fuerzas son conservativas, la energía potencial $V$ no depende de las velocidades, y las ecuaciones de transformación entre las coordenadas espaciales y las generalizadas no dependen explícitamente del tiempo), el Hamiltoniano resulta ser idéntico a la Energía Mecánica Total del sistema.

Veamos por qué. Si la energía cinética $T$ es una función cuadrática de las velocidades (como es habitual, ej. $T = \dfrac{1}{2}m\dot{x}^2$), se cumple una propiedad matemática del Teorema de Euler para funciones homogéneas que establece que:

$$
\begin{aligned}
\sum_{i} \dot{q}_i \dfrac{\partial T}{\partial \dot{q}_i} = 2T
\end{aligned}
$$

Como el momento es $p_i = \dfrac{\partial L}{\partial \dot{q}_i}$ y $L = T - V$ (donde $V$ no depende de las velocidades), entonces $\dfrac{\partial L}{\partial \dot{q}_i} = \dfrac{\partial T}{\partial \dot{q}_i}$. Por tanto:

$$
\begin{aligned}
\sum_{i} p_i \dot{q}_i = \sum_{i} \dot{q}_i \dfrac{\partial T}{\partial \dot{q}_i} = 2T
\end{aligned}
$$

Sustituyendo esto en nuestra definición original del Hamiltoniano ($H = \sum p_i \dot{q}_i - L$):

$$
\begin{aligned}
H = 2T - (T - V) = T + V = E_{total}
\end{aligned}
$$

Esta es la razón por la que en mecánica cuántica (que toma la mecánica hamiltoniana como punto de partida clásico), el "Operador Hamiltoniano" $\hat{H}$ es precisamente el operador asociado a la energía total del sistema.

&nbsp;

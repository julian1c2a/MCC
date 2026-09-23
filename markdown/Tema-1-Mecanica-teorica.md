# Tema 1. Mecánica teórica

## 1.1. La mecánica ondulatoria

La mecánica ondulatoria estudia cómo se propagan las perturbaciones a través de un medio (o el vacío) en forma de ondas. Para comprender matemáticamente esta propagación espacial y temporal, es útil comenzar analizando el comportamiento de un único oscilador y luego expandirlo a un sistema continuo.

### 1.1.1. El oscilador simple: masa atada a un elástico (o muelle) en el techo

Imaginemos un sistema básico: una masa $m$ suspendida del techo mediante un elástico o resorte ideal con una constante elástica $k$. Si tiramos de la masa hacia abajo separándola de su punto de equilibrio y la soltamos, comenzará a oscilar verticalmente.

Este sistema describe un Movimiento Armónico Simple (MAS). Aplicando la Segunda Ley de Newton y la Ley de Hooke, obtenemos la siguiente ecuación diferencial para el movimiento:

$$m ⋅ \dfrac{d^2y}{dt^2} = -k ⋅ y$$

La solución a esta ecuación nos da la posición $y$ de la masa en función de una única variable, el tiempo ($t$):

$$y(t) = A ⋅ \cos(\omega ⋅ t + \phi)$$

En esta función:

* $A$ es la amplitud (el desplazamiento máximo desde el equilibrio).
* $\omega$ es la frecuencia angular, relacionada con las propiedades del sistema ($\omega = \sqrt{\dfrac{k}{m}}$).
* $\phi$ es la constante de fase inicial.

Este ejemplo ilustra una oscilación local; la energía se transforma de potencial a cinética, pero no se propaga a través del espacio.

### 1.1.2.Movimiento ondulatorio: Cuerda elástica horizontal entre dos puntos fijos

Para pasar al movimiento ondulatorio, consideremos ahora una cuerda elástica tensada horizontalmente entre dos paredes (dos puntos fijos). Podemos imaginar esta cuerda como una cadena infinita de pequeñas masas conectadas por pequeños elásticos.

Si perturbamos un punto de la cuerda, esa oscilación no se queda en un solo lugar (como la masa en el techo), sino que tira de los fragmentos vecinos de la cuerda, haciendo que la perturbación viaje a lo largo del eje $x$.

En este caso, el desplazamiento transversal (la altura de la cuerda), que llamaremos $y$, ya no depende solo del momento en que lo miremos, sino también de en qué parte de la cuerda nos fijemos. Por tanto, la función es bivariable: $y(x,t)$.

Una perturbación viajera (onda armónica) moviéndose a lo largo de la cuerda se describe matemáticamente como:

$$y(x,t) = A \sin(k ⋅ x \pm \omega ⋅ t)$$

Donde se introduce una nueva variable espacial:

* $k$ es el número de onda ($k = \dfrac{2 \cdot \pi}{\lambda}$), que describe la periodicidad en el espacio ($\lambda$ es la longitud de onda).

#### Ondas Estacionarias

Dado que nos has indicado que la cuerda está entre dos puntos fijos (por ejemplo, en $x=0$ y $x=L$), la onda viaja, rebota en un extremo y se superpone consigo misma. Esta interferencia crea una onda estacionaria. Matemáticamente, al aplicar las condiciones de contorno (los extremos no pueden moverse, $y=0$), la función $y(x,t)$ toma esta forma específica:

$$y(x,t) = \left( 2 ⋅ A \sin(k ⋅ x) \right) ⋅ \cos(\omega ⋅ t)$$

Esta hermosa ecuación separa la parte espacial de la temporal y nos dice que cada punto $x$ de la cuerda realiza un Movimiento Armónico Simple en el tiempo ($\cos(\omega ⋅ t)$), pero la amplitud de esa oscilación depende de su posición espacial ($2 ⋅ A \sin(k ⋅ x)$). Los puntos donde $\sin(k ⋅ x) = 0$ nunca se mueven; se llaman nodos.

### 1.1.3. Generalización: Representación compleja

En física, es extremadamente común y conveniente generalizar la función de onda utilizando notación compleja. Apoyándonos en la fórmula de Euler ($e^{i ⋅ \theta} = \cos(\theta) + i\sin(\theta)$), una onda viajera puede expresarse en su forma compleja como:

$$y(x,t) = A e^{i ⋅ (\omega ⋅ t - k ⋅ x)}$$

Dado que las magnitudes físicas observables en mecánica clásica (como el desplazamiento real de una cuerda) deben ser números reales, la onda física se entiende simplemente como la parte real (o imaginaria) de esta expresión compleja:

$$y_{real}(x,t) = \Re\{A ⋅ e^{i ⋅ (\omega ⋅ t - k ⋅ x)}\} = A ⋅ \cos(\omega ⋅ t - k ⋅ x)$$

¿Por qué usar una notación compleja?

1. Simplicidad matemática: Operar con funciones exponenciales es mucho más fácil que con senos y cosenos. Al derivar o integrar (por ejemplo, al introducir la función en la Ecuación de Ondas), la exponencial mantiene su forma y solo "escupirá" constantes hacia afuera (derivadas respecto al tiempo multiplican por $i ⋅ \omega$, y respecto a la posición por $-i ⋅ k$). Además, sumar ondas (para calcular interferencias) se reduce a factorizar exponenciales.
2. Fase inicial: Cualquier desfase inicial $\phi$ se puede absorber fácilmente definiendo una amplitud compleja $\tilde{A} = A ⋅ e^{i ⋅ \phi}$.
3. Puente a la mecánica cuántica: Mientras que en la mecánica clásica la parte imaginaria es solo una herramienta matemática y tomamos la parte real al final, en la mecánica ondulatoria cuántica, la función de onda de una partícula $\Psi(x,t)$ es intrínsecamente compleja.

### 1.1.4. La Ecuación de ondas

Cualquier perturbación física que se propague en forma de onda (ya sea el desplazamiento de nuestra cuerda elástica, la presión del aire en el sonido, o los campos eléctricos y magnéticos en la luz) debe obedecer a una ecuación diferencial específica: la ecuación de ondas.

#### 1.1.4.1. La ecuación diferencial en una dimensión

Para una perturbación $y(x,t)$ que viaja a lo largo de una sola dimensión (el eje $x$), la ecuación clásica de ondas es una ecuación diferencial en derivadas parciales, lineal y de segundo orden, expresada como:

$$\dfrac{\partial^2 y}{\partial x^2} = \dfrac{1}{v^2} ⋅ \dfrac{\partial^2 y}{\partial t^2}$$

Aquí, $v$ representa la velocidad de propagación (o velocidad de fase) de la onda en el medio. Esta ecuación nos dice, fundamentalmente, que la curvatura espacial de la onda en un punto (segunda derivada respecto a $x$) es proporcional a la aceleración de ese punto (segunda derivada respecto a $t$).

#### 1.1.4.2. Comprobación con la representación compleja

Podemos demostrar fácilmente por qué la solución compleja que vimos en el apartado anterior, $y(x,t) = A e^{i ⋅ (\omega ⋅ t - k ⋅ x)}$, es una solución válida. Gracias a las propiedades de la función exponencial, calcular las segundas derivadas parciales es un proceso directo:

1. Derivada temporal: Al derivar dos veces respecto al tiempo, multiplicamos por $i ⋅ \omega$ cada vez.
   $$\dfrac{\partial^2 y}{\partial t^2} = (i ⋅ \omega)^2 ⋅ A ⋅ e^{i ⋅ (\omega ⋅ t - k ⋅ x)} = -\omega^2 ⋅ y$$
2. Derivada espacial: Al derivar dos veces respecto a la posición, multiplicamos por $-i ⋅ k$ cada vez.
   $$\dfrac{\partial^2 y}{\partial x^2} = (-i ⋅ k)^2 ⋅ A ⋅ e^{i ⋅ (\omega ⋅ t - k ⋅ x)} = -k^2 ⋅ y$$

Si sustituimos estos resultados de nuevo en la ecuación de ondas general, obtenemos:

$$-k^2 ⋅ y = \dfrac{1}{v^2} ⋅ (-\omega^2 ⋅ y)$$

Simplificando (dividiendo entre $-y$), llegamos a una relación fundamental entre los parámetros de la onda:

$$k^2 = \dfrac{\omega^2}{v^2} \implies v = \dfrac{\omega}{k}$$

Esta es la relación de dispersión para ondas no dispersivas, que define la velocidad de la onda en función de su frecuencia angular ($\omega$) y su número de onda ($k$).

#### 1.1.4.3. La solución de d'Alembert (ondas viajeras arbitrarias)

Aunque las soluciones armónicas (senos, cosenos o exponenciales complejas) son las más comunes, Jean le Rond d'Alembert demostró que la ecuación de ondas admite soluciones mucho más generales.

Cualquier función escalar arbitraria $f$ que sea dos veces diferenciable (una "derivada suave") es solución de la ecuación de ondas si su argumento adopta la forma de una onda viajera. Si definimos una variable $u = \omega ⋅ t \pm k ⋅ x$, podemos proponer como solución $y(x,t) = f(u)$.

Comprobémoslo aplicando la regla de la cadena:

1. Derivadas respecto al tiempo:
   $$\dfrac{\partial y}{\partial t} = \dfrac{df}{du} \dfrac{\partial u}{\partial t} = \omega ⋅ f'(u)$$
   $$\dfrac{\partial^2 y}{\partial t^2} = \omega^2 ⋅ f''(u)$$
2. Derivadas respecto a la posición:
   $$\dfrac{\partial y}{\partial x} = \dfrac{df}{du} \dfrac{\partial u}{\partial x} = \pm k ⋅ f'(u)$$
   $$\dfrac{\partial^2 y}{\partial x^2} = (\pm k)^2 ⋅ f''(u) = k^2 ⋅ f''(u)$$

Al sustituir esto en la ecuación de ondas $\left( \dfrac{\partial^2 y}{\partial x^2} = \dfrac{1}{v^2} \dfrac{\partial^2 y}{\partial t^2} \right)$, obtenemos:

$$k^2 ⋅ f''(u) = \dfrac{1}{v^2} ⋅ \omega^2 ⋅ f''(u)$$

Siempre que $f''(u) \neq 0$, podemos dividir ambos lados de la ecuación, recuperando de nuevo la relación $v = \dfrac{\omega}{k}$.

Esto es un resultado extraordinario: nos dice que un pulso electromagnético con una forma totalmente arbitraria o un sonido complejo propagándose por el aire seguirán las mismas reglas físicas fundamentales que una onda armónica simple, siempre y cuando la perturbación mantenga su forma inalterada mientras se desplaza. La solución general completa de d'Alembert es una superposición de una onda viajando hacia la derecha y otra hacia la izquierda:

$$y(x,t) = f(\omega ⋅ t - k ⋅ x) + g(\omega ⋅ t + k ⋅ x)$$

#### 1.1.4.4. Solución general por separación de variables

La forma más sistemática de resolver la ecuación de ondas (especialmente cuando hay condiciones de contorno fijas, como en nuestra cuerda) es el método de separación de variables. Asumimos como hipótesis que la solución $y(x,t)$ puede expresarse como el producto de dos funciones independientes, una que depende solo de la posición $X(x)$ y otra solo del tiempo $T(t)$:

$$y(x,t) = X(x) ⋅ T(t)$$

Si calculamos las segundas derivadas y las sustituimos en la ecuación de ondas original, obtenemos:

$$X''(x) ⋅ T(t) = \dfrac{1}{v^2} \cdot X(x) ⋅ T''(t)$$

Dividiendo toda la ecuación por $X(x) ⋅ T(t)$, separamos las variables a cada lado de la igualdad:

$$\dfrac{X''(x)}{X(x)} = \dfrac{1}{v^2} ⋅ \dfrac{T''(t)}{T(t)}$$

Dado que el lado izquierdo depende exclusivamente de $x$ y el lado derecho exclusivamente de $t$, la única forma de que esta igualdad se cumpla para cualquier valor de $x$ y $t$ es que ambos lados sean iguales a una misma constante. Para obtener soluciones oscilatorias (y no exponenciales que divergen), esta constante de separación debe ser negativa, y la llamaremos $-k^2$:

$$\dfrac{X''(x)}{X(x)} = -k^2 \quad \text{y} \quad \dfrac{1}{v^2} ⋅ \dfrac{T''(t)}{T(t)} = -k^2$$

Esto descompone la ecuación en derivadas parciales en dos Ecuaciones Diferenciales Ordinarias (EDOs) simples:

1. Ecuación espacial: $X''(x) + k^2 ⋅ X(x) = 0$
2. Ecuación temporal: $T''(t) + \omega^2 ⋅ T(t) = 0 \quad$ (donde hemos definido $\omega = k ⋅ v$)

La solución general para estas ecuaciones son combinaciones lineales de senos y cosenos (o exponenciales complejas):

$$X(x) = A_1 ⋅ \cos(k ⋅ x) + B_1 ⋅ \sin(k ⋅ x)$$
$$T(t) = A_2 ⋅ \cos(\omega ⋅ t) + B_2 ⋅ \sin(\omega ⋅ t)$$

Por lo tanto, la solución general para un modo normal de vibración es el producto de ambas:

$$y(x,t) = \left( A_1 ⋅ \cos(k ⋅ x) + B_1 ⋅ \sin(k ⋅ x) \right) ⋅ \left( A_2 ⋅ \cos(\omega ⋅ t) + B_2 ⋅ \sin(\omega ⋅ t) \right)$$

Aplicando las condiciones de contorno (como $y(0,t)=0$ en la cuerda), muchas de estas constantes se anulan, llegándose a las ecuaciones de ondas estacionarias que vimos en el apartado 1.2.

#### 1.1.4.5. Generalización a tres dimensiones

Si la perturbación se propaga en el espacio tridimensional (como el sonido en una habitación o la luz de una estrella), la función dependerá de tres coordenadas espaciales y el tiempo: $\Psi(x,y,z,t)$. En este caso, la derivada espacial de la ecuación unidimensional se sustituye por el operador Laplaciano ($\nabla^2$ o $\Delta$):

$$\nabla^2 \Psi = \dfrac{1}{v^2} \cdot \dfrac{\partial^2 \Psi}{\partial t^2}$$

Donde el operador Laplaciano en coordenadas cartesianas se define como la suma de las segundas derivadas parciales espaciales: $\nabla^2 = \dfrac{\partial^2}{\partial x^2} + \dfrac{\partial^2}{\partial y^2} + \dfrac{\partial^2}{\partial z^2}$.

# 2. Conceptos básicos de mecánica

(Sección vacía)

## 2.1. El formalismo lagrangiano

El formalismo lagrangiano es una reformulación de la mecánica clásica que, en lugar de basarse en fuerzas vectoriales (como la mecánica newtoniana), se fundamenta en principios energéticos y variacionales. Resulta ser una herramienta extraordinariamente potente, especialmente al extenderse a medios continuos y campos, como es el caso de la propagación de ondas.

La Acción y la Densidad Lagrangiana

Para un sistema continuo (por ejemplo, el desplazamiento transversal de nuestra cuerda elástica), su estado está descrito por una función continua o campo $f(x,t)$.

Definimos un operador $\mathcal{L}$, conocido como densidad lagrangiana, que asigna un número a cada punto del espacio-tiempo a partir del valor local del campo $f$ y sus derivadas parciales:

$$\mathcal{L} = \mathcal{L}\left( f, \frac{\partial f}{\partial t}, \frac{\partial f}{\partial x} \right)$$

A partir de este operador, construimos una magnitud global del sistema llamada Acción ($S$). La Acción se define como la integral definida de la densidad lagrangiana extendida a todo el espacio y entre dos instantes de tiempo $t_1$ y $t_2$:

$$S = \int_{t_1}^{t_2} \int_{x_1}^{x_2} \mathcal{L}\left( f, \frac{\partial f}{\partial t}, \frac{\partial f}{\partial x} \right) dx \, dt$$

El problema de optimización variacional: Funcionales vs. Funciones

Antes de deducir las ecuaciones de movimiento, es vital aclarar matemáticamente qué estamos intentando optimizar. A menudo se dice coloquialmente que "minimizamos la función $f$ con respecto a $\mathcal{L}$", pero esto es una imprecisión.

El problema real pertenece a la rama matemática del Cálculo de Variaciones.

En el cálculo diferencial ordinario, optimizamos una función (ej. $y(x)$): buscamos un número $x$ que nos devuelva el valor mínimo de $y$, haciendo $\frac{dy}{dx} = 0$.

En el cálculo de variaciones, sin embargo, optimizamos un funcional (en este caso, la Acción $S$). Un funcional toma como argumento una función entera y devuelve un número real. El espacio de búsqueda no es la recta de los números reales, sino un espacio de dimensión infinita que contiene todas las posibles formas que podría adoptar el campo $f(x,t)$ entre las fronteras fijadas.

No minimizamos $f$, sino que buscamos cuál es el "camino" o "superficie" específica $f_{real}(x,t)$ que hace que el número global $S$ sea mínimo (o estacionario).

El postulado central de la física en este contexto es el Principio de Hamilton (o Principio de Mínima Acción). Este establece que el campo físico real evoluciona precisamente adoptando aquella función $f(x,t)$ que anula la primera variación de la Acción: $\delta S = 0$. Esta variación nula es el equivalente funcional de igualar una derivada a cero.

Un ejemplo ilustrativo clásico: La Braquistócrona

Para comprender la optimización de funcionales fuera del contexto abstracto de la mecánica analítica, consideremos uno de los problemas históricos que dio origen al cálculo de variaciones en 1696: el problema de la braquistócrona.

Imagina dos puntos $A$ (origen $0,0$) y $B$ (donde $B$ está más abajo y desplazado horizontalmente). Buscamos la forma exacta de un alambre, definido por una curva $y(x)$, por el cual una cuenta resbalará sin fricción bajo el efecto de la gravedad en el menor tiempo posible. Para simplificar los signos, diremos que la gravedad actúa en el eje $+y$ (hacia abajo).

Buscamos una función $y(x)$ que minimice el funcional del Tiempo total ($T$). Sabemos que el tiempo es la integral de la distancia sobre la velocidad ($dt = ds / v$). Usando el teorema de Pitágoras para el elemento de arco infinitesimal ($ds = \sqrt{dx^2 + dy^2} = \sqrt{1 + (y')^2} dx$, donde $y' = \frac{dy}{dx}$) y la conservación de energía para aislar la velocidad ($E_{cinetica} = E_{potencial} \implies \frac{1}{2}mv^2 = mgy \implies v = \sqrt{2gy}$), el funcional del tiempo queda como:

$$T[y(x)] = \int_{0}^{x_B} \frac{\sqrt{1 + (y')^2}}{\sqrt{2gy}} dx$$

En este problema estrictamente matemático y geométrico, el integrando es nuestra función objetivo, comportándose analíticamente igual que una densidad Lagrangiana:

$$\mathcal{L}(y, y', x) = \frac{\sqrt{1 + (y')^2}}{\sqrt{2gy}}$$

Resolución paso a paso: La Identidad de Beltrami

Para encontrar la curva $y(x)$ que minimiza este funcional, debemos aplicar la Ecuación de Euler-Lagrange unidimensional:

$$\frac{d}{dx}\left( \frac{\partial \mathcal{L}}{\partial y'} \right) - \frac{\partial \mathcal{L}}{\partial y} = 0$$

Sin embargo, calcular estas derivadas completas directamente conduce a un álgebra extremadamente tediosa. Afortunadamente, notamos una propiedad crucial en nuestra $\mathcal{L}$: no depende explícitamente de la coordenada $x$ (la $x$ no aparece en la fórmula, solo $y$ y $y'$).

Cuando esto ocurre en el cálculo de variaciones, la Ecuación de Euler-Lagrange se simplifica en una constante de movimiento (una primera integral) conocida como la Identidad de Beltrami:

$$\mathcal{L} - y' \frac{\partial \mathcal{L}}{\partial y'} = C$$

Vamos a aplicar esto paso a paso. Primero, calculemos la derivada parcial de $\mathcal{L}$ respecto a $y'$:

$$\frac{\partial \mathcal{L}}{\partial y'} = \frac{1}{\sqrt{2gy}} \cdot \frac{1}{2\sqrt{1 + (y')^2}} \cdot 2y' = \frac{y'}{\sqrt{2gy}\sqrt{1 + (y')^2}}$$

Ahora introducimos $\mathcal{L}$ y esta derivada en la Identidad de Beltrami:

$$\frac{\sqrt{1 + (y')^2}}{\sqrt{2gy}} - y' \left( \frac{y'}{\sqrt{2gy}\sqrt{1 + (y')^2}} \right) = C$$

Podemos agrupar la constante de gravedad $\frac{1}{\sqrt{2g}}$ junto con la constante arbitraria $C$ del lado derecho (creando una nueva constante $C_1$), dejándonos con:

$$\frac{\sqrt{1 + (y')^2}}{\sqrt{y}} - \frac{(y')^2}{\sqrt{y}\sqrt{1 + (y')^2}} = C_1$$

Para restar estas fracciones, multiplicamos el primer término arriba y abajo por $\sqrt{1 + (y')^2}$ para buscar un denominador común:

$$\frac{1 + (y')^2 - (y')^2}{\sqrt{y}\sqrt{1 + (y')^2}} = C_1 \implies \frac{1}{\sqrt{y(1 + (y')^2)}} = C_1$$

Si elevamos al cuadrado ambos lados e invertimos la fracción, la constante al cuadrado e invertida seguirá siendo una constante, que por conveniencia geométrica llamaremos $2r$:

$$y(1 + (y')^2) = \frac{1}{C_1^2} = 2r$$

¡Hemos llegado a la ecuación diferencial de la curva óptima! Despejando la pendiente $y'$ (que es $\frac{dy}{dx}$):

$$(y')^2 = \frac{2r - y}{y} \implies \frac{dy}{dx} = \sqrt{\frac{2r - y}{y}}$$

Esta no es la ecuación de una línea recta, ni de una parábola. Esta es la clásica ecuación diferencial de una cicloide invertida. La solución paramétrica que satisface esta ecuación es:

$$x(\theta) = r(\theta - \sin \theta)$$

$$y(\theta) = r(1 - \cos \theta)$$

Físicamente, una cicloide es la curva trazada por un punto en el borde de una rueda de radio $r$ a medida que rueda sin deslizar. Resulta que la naturaleza "sabe" calcular variaciones: el camino más rápido para caer bajo la gravedad no es la distancia más corta (línea recta), sino dejarse caer de forma más pronunciada al principio para ganar velocidad rápidamente, siguiendo una cicloide.

(Nota: De forma análoga, el problema isoperimétrico busca la curva cerrada $y(x)$ que maximice el funcional del Área contenida, dado un perímetro constante, cuya solución variacional resulta ser un círculo).

Deducción de las ecuaciones de Euler-Lagrange para campos continuos

Volviendo a nuestro sistema físico continuo, para encontrar esa función $f$ óptima, sometemos el campo a una variación infinitesimal $f \rightarrow f + \delta f$. Asumimos que esta variación se anula en los bordes de integración espaciales y temporales (es decir, el sistema empieza y acaba en estados fijos conocidos, por lo que $\delta f = 0$ en $x_1, x_2, t_1, t_2$).

La variación total de la Acción $S$ ante este pequeño cambio arbitrario de la función viene dada por la regla de la cadena para múltiples variables, aplicada al integrando $\mathcal{L}$:

$$\delta S = \int \int \left[ \frac{\partial \mathcal{L}}{\partial f}\delta f + \frac{\partial \mathcal{L}}{\partial \left( \frac{\partial f}{\partial t} \right)}\delta \left( \frac{\partial f}{\partial t} \right) + \frac{\partial \mathcal{L}}{\partial \left( \frac{\partial f}{\partial x} \right)}\delta \left( \frac{\partial f}{\partial x} \right) \right] dx \, dt = 0$$

Justificación matemática: Conmutación de $\delta$ y $\partial$

Para continuar operando matemáticamente, necesitamos poder intercambiar el operador variación ($\delta$) con la derivada espacial o temporal (por ejemplo, asumiendo que $\delta(\partial_t f) = \partial_t (\delta f)$).

Para justificar esto de forma rigurosa, definamos qué es exactamente una "variación" $\delta f$. Imaginemos la función del campo real (la solución física) $f_0(x,t)$ y perturbémosla sumándole una función suave y totalmente arbitraria $\eta(x,t)$ (que se anula en las fronteras), ponderada por un parámetro escalar minúsculo $\epsilon$:

$$f(x,t,\epsilon) = f_0(x,t) + \epsilon \cdot \eta(x,t)$$

El operador variación $\delta$ representa matemáticamente la diferencial respecto a este nuevo parámetro $\epsilon$, evaluada en cero:

$$\delta f = \left. \frac{\partial f}{\partial \epsilon} \right\vert{}_{\epsilon=0} d\epsilon = \eta(x,t) \, d\epsilon$$

Dado que las coordenadas del espacio ($x$), el tiempo ($t$) y el parámetro de variación abstracta ($\epsilon$) son variables completamente independientes, sus derivadas parciales mixtas conmutan según el Teorema de Clairaut-Schwarz (siempre que las funciones sean suficientemente continuas). Por lo tanto:

$$\delta \left( \frac{\partial f}{\partial t} \right) = \frac{\partial}{\partial \epsilon} \left( \frac{\partial f}{\partial t} \right) d\epsilon = \frac{\partial}{\partial t} \left( \frac{\partial f}{\partial \epsilon} \right) d\epsilon = \frac{\partial}{\partial t} (\delta f)$$

Esta independencia lineal entre el espacio-tiempo y el "espacio de las variaciones" es lo que nos garantiza el derecho a sacar la derivada fuera de la variación.

Integración por partes y la Derivada Funcional

Volviendo a la ecuación original $\delta S=0$ y sabiendo que podemos conmutar operadores, reescribimos el segundo y tercer término, para luego aplicar integración por partes (la regla del producto de derivadas a la inversa).

Al integrar por partes, aparecen términos evaluados en las fronteras de integración. Sin embargo, como hemos establecido como restricción fundamental que la variación es nula en los bordes ($\delta f = 0$), esos términos evaluados en la frontera matemática desaparecen. Solo nos quedan los nuevos integrandos con un signo menos:

$$\delta S = \int \int \left[ \frac{\partial \mathcal{L}}{\partial f} - \frac{\partial}{\partial t}\left( \frac{\partial \mathcal{L}}{\partial \left(\frac{\partial f}{\partial t}\right)} \right) - \frac{\partial}{\partial x}\left( \frac{\partial \mathcal{L}}{\partial \left(\frac{\partial f}{\partial x}\right)} \right) \right] \delta f \, dx \, dt = 0$$

Al corchete de esta integral se le conoce matemáticamente como la derivada funcional de la Acción $S$ respecto al campo $f(x,t)$ (denotada comúnmente como $\frac{\delta S}{\delta f}$).

Para que esta integral doble sea idénticamente igual a cero, independientemente de la forma caprichosa que tenga la variación arbitraria $\delta f$ que hayamos elegido, el corchete entero (la derivada funcional) debe ser forzosamente nulo en todo punto del espacio-tiempo. Este es el Lema Fundamental del Cálculo de Variaciones.

Esto nos conduce a la magistral Ecuación de Euler-Lagrange para campos continuos:

$$\frac{\partial}{\partial t}\left( \frac{\partial \mathcal{L}}{\partial \left(\frac{\partial f}{\partial t}\right)} \right) + \frac{\partial}{\partial x}\left( \frac{\partial \mathcal{L}}{\partial \left(\frac{\partial f}{\partial x}\right)} \right) - \frac{\partial \mathcal{L}}{\partial f} = 0$$

Cualquier sistema físico continuo descrito por una densidad lagrangiana $\mathcal{L}$ obedecerá esta ecuación diferencial, asegurando así que la Acción del sistema se mantenga minimizada/estacionaria.

Particularización a un sistema discreto de partículas

Hasta ahora hemos tratado medios continuos mediante una densidad lagrangiana ($\mathcal{L}$) integrada sobre el volumen. Sin embargo, en mecánica clásica es muy habitual tratar con sistemas discretos compuestos por $N$ puntos materiales (partículas puntuales) con masa.

Para este tipo de sistemas, ya no integramos sobre el espacio, sino que definimos la posición del sistema mediante un conjunto de coordenadas generalizadas $q_i$. Si tenemos $N$ partículas moviéndose en 3 dimensiones, necesitaremos $3N$ coordenadas (por ejemplo, $q_1 = x_1, q_2 = y_1, q_3 = z_1, q_4 = x_2...$ hasta $q_{3N}$).

Las derivadas temporales de estas coordenadas se denominan velocidades generalizadas, expresadas mediante la notación de punto de Newton:

$$\dot{q}_i = \frac{dq_i}{dt}$$

En este contexto discreto, el operador que define al sistema se convierte en una función escalar llamada el Lagrangiano ($L$), que depende explícitamente de las coordenadas generalizadas, las velocidades generalizadas y, opcionalmente, del tiempo:

$$L = L(q_1, q_2, ..., q_{3N}, \dot{q}_1, \dot{q}_2, ..., \dot{q}_{3N}, t) \equiv L(q_i, \dot{q}_i, t)$$

La Acción se define ahora como una única integral en el tiempo del Lagrangiano a lo largo de la trayectoria del sistema entre un estado inicial $t_1$ y uno final $t_2$:

$$S = \int_{t_1}^{t_2} L(q_i, \dot{q}_i, t) dt$$

Aplicando el Principio de Hamilton ($\delta S = 0$) y la misma maquinaria de cálculo de variaciones (integración por partes en una sola variable, el tiempo), obtenemos un conjunto de $3N$ ecuaciones diferenciales ordinarias acopladas:

$$\frac{d}{dt}\left( \frac{\partial L}{\partial \dot{q}_i} \right) - \frac{\partial L}{\partial q_i} = 0$$

Estas son las Ecuaciones de Euler-Lagrange para sistemas discretos. Cada término tiene un significado físico directo:

1. El término $\frac{\partial L}{\partial \dot{q}_i}$ se define como el momento generalizado (o momento conjugado) $p_i$. (Si $L = \frac{1}{2}m\dot{x}^2 - V(x)$, entonces $\frac{\partial L}{\partial \dot{x}} = m\dot{x} = p_x$).
2. El término $\frac{\partial L}{\partial q_i}$ se define como la fuerza generalizada $F_i$. (Si $V$ solo depende de $x$, entonces $\frac{\partial L}{\partial x} = -\frac{\partial V}{\partial x} = F_x$).

Sustituyendo estas definiciones, la ecuación se lee como $\frac{d p_i}{dt} = F_i$, lo que demuestra que el formalismo lagrangiano recupera maravillosamente la Segunda Ley de Newton, pero con la enorme ventaja de que las ecuaciones de Euler-Lagrange mantienen exactamente la misma forma matemática independientemente del sistema de coordenadas elegido (cartesianas, polares, cilíndricas o variables abstractas).

¿Por qué $L = T - V$? El puente desde Newton

Es común ver definido el Lagrangiano como la diferencia entre la Energía Cinética Total ($T$) y la Energía Potencial ($V$):

$$L = T - V$$

Pero, ¿de dónde sale esta estructura exacta? No es un capricho; es la consecuencia matemática de obligar a las ecuaciones de Euler-Lagrange a ser idénticas a la Segunda Ley de Newton en presencia de fuerzas conservativas.

Veámoslo para una única partícula en una dimensión (coordenada $x$). La Segunda Ley de Newton nos dice:

$$m \ddot{x} = F_x$$

Si la fuerza es conservativa, deriva de un potencial $V(x)$, de modo que $F_x = -\frac{\partial V}{\partial x}$. Sustituyendo:

$$m \ddot{x} = -\frac{\partial V}{\partial x}$$

Por otro lado, la energía cinética de la partícula es $T = \frac{1}{2}m\dot{x}^2$. Notemos dos propiedades matemáticas de $T$:

1. Si derivamos $T$ respecto a la velocidad $\dot{x}$, obtenemos el momento: $\frac{\partial T}{\partial \dot{x}} = m\dot{x}$. Si a esto le aplicamos la derivada temporal, recuperamos la fuerza inercial (masa por aceleración): $\frac{d}{dt}\left( \frac{\partial T}{\partial \dot{x}} \right) = m\ddot{x}$.
2. Si derivamos $T$ respecto a la posición $x$, el resultado es cero (en coordenadas cartesianas, la energía cinética no depende de dónde estés, solo de lo rápido que vayas): $\frac{\partial T}{\partial x} = 0$.

Con esto en mente, podemos reescribir el término $m\ddot{x}$ de la ley de Newton usando exclusivamente derivadas de la energía cinética:

$$\frac{d}{dt}\left( \frac{\partial T}{\partial \dot{x}} \right) = -\frac{\partial V}{\partial x}$$

Reagrupemos todos los términos en el lado izquierdo:

$$\frac{d}{dt}\left( \frac{\partial T}{\partial \dot{x}} \right) + \frac{\partial V}{\partial x} = 0$$

Aquí viene el truco final. Dado que la energía potencial $V(x)$ depende únicamente de la posición y no de la velocidad, su derivada parcial respecto a la velocidad es cero ($\frac{\partial V}{\partial \dot{x}} = 0$). Y, como ya vimos, $\frac{\partial T}{\partial x} = 0$. Esto nos permite "engañar" a la ecuación agrupando ambas energías bajo las mismas derivadas sin alterar el resultado matemático:

$$\frac{d}{dt}\left( \frac{\partial (T - V)}{\partial \dot{x}} \right) - \frac{\partial (T - V)}{\partial x} = 0$$

¡Esta es exactamente la ecuación de Euler-Lagrange! Si comparamos esta expresión con la forma general $\frac{d}{dt}\left( \frac{\partial L}{\partial \dot{x}} \right) - \frac{\partial L}{\partial x} = 0$, la conclusión es inevitable: el operador $L$ que hace que el principio variacional reproduzca la dinámica newtoniana conservativa debe ser, por definición, $L = T - V$.

(Nota: En sistemas mecánicos complejos con vínculos y coordenadas generalizadas abstractas $q_i$, se utiliza el Principio de d'Alembert (o de los Trabajos Virtuales) para demostrar de forma más rigurosa que esta misma estructura $L = T - V$ se mantiene inviolable).

1.6. La mecánica hamiltoniana

El formalismo lagrangiano $L(q_i, \dot{q}_i, t)$ que acabamos de ver formula la dinámica en el espacio de configuración, un espacio matemático de $N$ dimensiones definido por las coordenadas generalizadas $q_i$. Las velocidades $\dot{q}_i$ son simplemente las derivadas temporales de dichas coordenadas.

La mecánica hamiltoniana propone un cambio de paradigma: tratar a las coordenadas de posición ($q_i$) y a los momentos asociados ($p_i$) como variables completamente independientes, en un plano de igualdad matemática. Esto nos traslada a un nuevo espacio geométrico de $2N$ dimensiones conocido como el espacio de las fases.

De velocidades a momentos generalizados: La Transformada de Legendre

Como vimos en la sección anterior, el momento generalizado o momento conjugado se define a partir del Lagrangiano como:

$$p_i = \frac{\partial L}{\partial \dot{q}_i}$$

Nuestro objetivo ahora es crear una nueva función, el Hamiltoniano ($H$), que dependa exclusivamente de posiciones, momentos y del tiempo: $H(q_i, p_i, t)$. Para lograr este cambio de variables, las matemáticas nos ofrecen una herramienta específica: la Transformada de Legendre.

La transformada de Legendre nos permite pasar de una función que depende de una variable (en este caso, $\dot{q}_i$) a otra función que dependa de la derivada de esa variable respecto a la función original (es decir, $p_i$). La definición general del Hamiltoniano se construye así:

$$H(q_i, p_i, t) = \sum_{i} p_i \dot{q}_i - L(q_i, \dot{q}_i, t)$$

Deducción de las Ecuaciones Canónicas de Hamilton

Para descubrir qué forma toman las ecuaciones de movimiento en este nuevo marco, vamos a calcular la diferencial total (el cambio infinitesimal) del Hamiltoniano de dos maneras distintas y compararlas.

Primer método: Usando la definición de la transformada de Legendre

Si diferenciamos la ecuación $H = \sum p_i \dot{q}_i - L$, aplicando la regla del producto y la regla de la cadena para la diferencial de $L(q_i, \dot{q}_i, t)$, obtenemos:

$$dH = \sum_{i} (\dot{q}_i dp_i + p_i d\dot{q}_i) - \left[ \sum_{i} \left( \frac{\partial L}{\partial q_i} dq_i + \frac{\partial L}{\partial \dot{q}_i} d\dot{q}_i \right) + \frac{\partial L}{\partial t} dt \right]$$

Ahora usamos nuestras dos definiciones clave provenientes del formalismo lagrangiano:

1. $p_i = \frac{\partial L}{\partial \dot{q}_i}$ (definición de momento).
2. $\dot{p}_i = \frac{\partial L}{\partial q_i}$ (es la propia Ecuación de Euler-Lagrange, $\frac{d p_i}{dt} = \frac{\partial L}{\partial q_i}$).

Sustituyendo esto en el corchete:

$$dH = \sum_{i} (\dot{q}_i dp_i + p_i d\dot{q}_i) - \sum_{i} (\dot{p}_i dq_i + p_i d\dot{q}_i) - \frac{\partial L}{\partial t} dt$$

Notamos que el término $p_i d\dot{q}_i$ aparece sumando y restando, por lo que se cancela de forma espectacular. Esto es el núcleo de la transformada de Legendre: elimina la dependencia de los diferenciales de velocidad ($d\dot{q}_i$). Nos queda:

$$dH = \sum_{i} (\dot{q}_i dp_i - \dot{p}_i dq_i) - \frac{\partial L}{\partial t} dt$$

Segundo método: Diferenciando el Hamiltoniano como función de sus propias variables

Sabemos por definición que $H$ es una función de $q_i$, $p_i$ y $t$. Su diferencial total formal en cálculo multivariable es:

$$dH = \sum_{i} \left( \frac{\partial H}{\partial q_i} dq_i + \frac{\partial H}{\partial p_i} dp_i \right) + \frac{\partial H}{\partial t} dt$$

Igualando coeficientes:

Como ambos métodos deben darnos el mismo diferencial $dH$, podemos igualar término a término los coeficientes que acompañan a $dq_i$, $dp_i$ y $dt$. Esto nos proporciona el sistema de ecuaciones fundamentales de la mecánica hamiltoniana, conocidas como Ecuaciones Canónicas de Hamilton:

$$\dot{q}_i = \frac{\partial H}{\partial p_i}$$

$$\dot{p}_i = -\frac{\partial H}{\partial q_i}$$

Y adicionalmente: $\frac{\partial H}{\partial t} = -\frac{\partial L}{\partial t}$.

A diferencia del formalismo lagrangiano, que nos daba $N$ ecuaciones diferenciales de segundo orden, el formalismo hamiltoniano nos proporciona $2N$ ecuaciones diferenciales acopladas de primer orden. Estas ecuaciones dictan cómo fluye el sistema trazando una única e inequívoca trayectoria a través del espacio de las fases de $2N$ dimensiones.

Significado físico: El Hamiltoniano como Energía Total

En la inmensa mayoría de los sistemas mecánicos convencionales (específicamente aquellos donde las fuerzas son conservativas, la energía potencial $V$ no depende de las velocidades, y las ecuaciones de transformación entre las coordenadas espaciales y las generalizadas no dependen explícitamente del tiempo), el Hamiltoniano resulta ser idéntico a la Energía Mecánica Total del sistema.

Veamos por qué. Si la energía cinética $T$ es una función cuadrática de las velocidades (como es habitual, ej. $T = \frac{1}{2}m\dot{x}^2$), se cumple una propiedad matemática del Teorema de Euler para funciones homogéneas que establece que:

$$\sum_{i} \dot{q}_i \frac{\partial T}{\partial \dot{q}_i} = 2T$$

Como el momento es $p_i = \frac{\partial L}{\partial \dot{q}_i}$ y $L = T - V$ (donde $V$ no depende de las velocidades), entonces $\frac{\partial L}{\partial \dot{q}_i} = \frac{\partial T}{\partial \dot{q}_i}$. Por tanto:

$$\sum_{i} p_i \dot{q}_i = \sum_{i} \dot{q}_i \frac{\partial T}{\partial \dot{q}_i} = 2T$$

Sustituyendo esto en nuestra definición original del Hamiltoniano ($H = \sum p_i \dot{q}_i - L$):

$$H = 2T - (T - V) = T + V = E_{total}$$

Esta es la razón por la que en mecánica cuántica (que toma la mecánica hamiltoniana como punto de partida clásico), el "Operador Hamiltoniano" $\hat{H}$ es precisamente el operador asociado a la energía total del sistema.

&nbsp;

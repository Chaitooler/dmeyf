## Clase 6

Yo doy SUBSAMPLEO


## Clase especial logistica
# Regresión Logística
Horas de estudio x horas de sueño, caso basico
Punto de corte = Hiperplanjo que corta los planos en clases

P(Y=1 | X)

Y va a ser 1 si estoy de un lado del punto de corte.
bX > 0

P( bX + e > 0 | X)

Se asume que el error es una dist logistica

P ( e > -bX | X ) = 1 / 1 + e ^ -bX (Logit(bX))
(integral desde ahi hasta infinito)

Tambien hay Probit

# Odds

p/q (exitos sobre fracasos, como son las magnitudes comparadas)

log (p/q) = bX

p / (1-p)

Te lleva al Logit

Y ~ Bernoulli (p)
f(y) = bX

Logistica: Crecimiento poblacional. Sube exponencial y despues se para.

e^-bi -> ODD RATIO. Cuanto aporta una variable a la conclusión de la p.

# WOE (weight of evidence)

Medir el poder predictivo de una variable.

Por ejemplo: Comuna. Se calcula el Woe de cada una, y se ve que tan fuerte es esa clase respecto a la clase general. Uno busca (cuando encuentra que hay distintos WOEs)

Cuando hay bins que son muy fuertes, la variable discriminan. Despues los Woes conforman el Information Value.
El WOE es logaritmico. Por eso es util para modelos regresivos.
Muchas veces se usa el WOE de la variable en vez del numero.

Problemas de meter datos asi nomas a una regresión: outliers, missing, asimetrias

Continua -> Discretiza (Homogeniza) -> WOE -> Regresion
Importante el WOE no tiene unidades, entonces se hace comparable.

# Score Card -> Para explicar a la gnete que no le dieron un credito
Edad, Salario, Profesion.
Los scores de las variables son WOES
El BCRA exige que todos los otorgamientos sean explicables, esto es una forma muy estandar de hacerlo.

Cortar las variables a travez de Deciles
IV muy buena ordenando las variables. Si el IV es menor a X, no sirve, y asi.

# Kolmogorov - Smirnov

Test o estadistico.
Responde a dos preguntas
1. Este conjunto viene de tal distribucion particular?
2. Estas dos muestras son de la misma distribucion?

Comparar las F acumuladas y hacer un test con ellas. (Muestral con teorica, o muestral con muestral)

Ni a palos se acerca a ser la mejor tenica para estimar distribuciones.

KS se usa para ver que tan distintas son (En vez de ver que tan similares son)
Distancia max entre las probabilidades de las salidas de los modelos.

Que tanto separa mi modelo a los buenos y los malos
METRICA GLOBAL: La metrica es mala porque puede tener la max separacion en el medio en vez de lo que de verdad me importa que es el principio (los mejores)



## Ensambles

Logistica corta en diagonal al plano.
Arbol va cortando al plano ortogonalmente

Como hago cortes raros? como una estrella?

Combinar modelos porque la capacidad ddiscriminativa de uno solo no es suficiente para predecir el modelo.

Podemos ir sacando partes para que pueda cortar optimamente.
MODELOS MUY DISTINTOS

LEER: Colash.github.io/ NEURAL NETS MANIFOLDS TOPOLOGY
Cortar datos como los SVM

Red corta con regresiones (rectas)
KNN separa con diagramas de Voronoi (clusters)

Redes con mas capas
Deformar el espacio para encontrar una recta que lo pueda separar!
Puede sumar una dimension sumando capas y cortarla en otro plano
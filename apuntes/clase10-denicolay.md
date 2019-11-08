## Clase 10

## La muerte del overfitting

'Los cientificos son muh chantas' Aveces la sobervbia evita ver que el verdadero problema esta en los algoritmos.

'Overfitting, mi algoritmo se pega a los datos'

Culpa de la complejidad.

Lo que pasaba realmente, es que cortaban mal el arbol. El ser humano genera el overfitting.


Usar max depths, min split min bucket es aberrante cuando podriamos hacer un test estadistico adecuado para multiples comparaciones.

LA culpa del overfitting era del algoritmo.


VER CONVEX HULL

Puntos de corte, metodo eligen puntos de la cascara convexa de la curva ROC.



Soluciones para MCPs
-Nueva data (conjunto de test)
-CrossValid
-Bonferroni Adjustment
-Class Randomization (Permutation

Permutacion de la clase:
Cambiarle la clase a los datos como cuando ordenas en el excell y no pones toodo.

Buscar Randomization Test
Permutation Test
Markus Ojala

Un punto de corte sirve solo si esta por encima de la cascara convexa randomizada.

Parametros inutiles en el Gradient Boost
Lambda
Alfa
Gamma
Max_Depth
MIN_GAIN_TO_SPLIT

Parametros que si sirven:
ETA
ColsampleByTree
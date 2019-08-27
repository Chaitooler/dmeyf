## Clase 3

r2d3us.us -> Ver pagina
Objetivo: Cualquier persona entienda Machine Learning

Criterio de corte ARBOL: Concentrar informacion (Entropia)
Un solo elemento en una rama da sospecha. Siendo estricto necesitas probarlo con otra data.

Tunear el arbol con respecto a cuanto dejo que abra en base al tamaño del nodo siguiente
Tener poca poda es malo.

Bias vs Variance: Min Error.

Ver que onda las variables subrogadas.

Mover modelo a binario para trabajar con Px

No abrio el arbol: PANIC ATTACK. Puede ser que falle la complejidad, u otros parametros. Incluso el RF puede abrir cuando un arbol comun no.

Mirar salida de densidades. Importan pero nunca se hacen
Dada esas probabilidades, como se distribuyen. MAs cerca de 1 es mejor para saber los que se van.

Punto de corte a la PX minima: Un elemento a una clase para consideararla parte de la misma.
Switch: Probabilidad de las ramas. Elegir un buen punto de corte: DESAFIO
Probabilidades  en forma inversa. Punto de corte es cola afuera de la gausseana. Siempre mayor. Se suele visualizar alrevez. Lo bueno mas cerca del eje.

CONTINUA / BAJA = 500/20000 = 0,025
Corte = 0,038 (No es lo mismo pero la max gan esta entre 0,023 y 0,038)
Usar las probabilidades para definir los criterios de umbral de la curva ROC
Dependiendo el criterio hay muchos puntos de corte en la ROC. Uno es la segunda derivada (Punto de concavidad de la curva)

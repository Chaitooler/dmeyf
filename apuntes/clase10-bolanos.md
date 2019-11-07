## Clase 10

# kNN

Dime con quien andas y te dire quien eres.

No tiene un proceso de ajuste. Todo esta ahi. Es muy rapido. 

Scorear es dificil en este modelo.
No se entrena, ya esta todo in site.

Ponderar en funcion de la distancia para evitar.
Devuelve un numero entre 0 y 1. En nuestros modelos son probabilidades.

Se usa muchisimo en sistemas de recomendacion.
Clasificacion de imagenes.

'fastknn'

IMPORTANTE:
Tomar tan solo una muestra de los datos de entrenamiento, ya que tomar todo tiene un costo computacional gigante.

MIAs (NAs) : Analizar donde estan los NA, y ver que hacer, porque no hay distancias contra NA en espacios geometricos.

El punto de corte es cualquiera porque no es una probabilidad

5 millones y medio fue el max ganancia.


Feature engineering:

Puedo hace log para cambiar la forma de los datos. O arcsin.

DATO PIOLA: Llevar a cero 1 y aplicar la inversa de la logistica.

Es importante cambiar la escala y llevar a [0,1)

Ver libreria bestNormalize

Si normalizamos hay que normalizar el conjunto de entrenamiento. Y luego usas esa funcion de normalizacion la aplicamos a test.

Despues de eso da 7 y medio.

Parametrizacion
Distancia, se puede tunear otras distancias
Valor de K -> podemos usar bayesiano, grid search
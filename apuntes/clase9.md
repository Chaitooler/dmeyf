## Clase 9

Ver tarea hogar 09 de Denicolay. 

Optimiza con XGBoost, histograma, hasta 31 variables, eta bajo, nrounds 300 es bastante, colsample_bytree es el 60% de las variables para cada arbol
Ver parametros L1 alfa y gamma, que no estan ahi
ver data degeneracion (parametro fundamental)

La idea: Tratar de predecir abril con los meses anteriores

Ver la hiperparametrizacion
Mas variables!!! usar mas

Modelos malos> Ver modelos que pueden llegar a ganar pero no lo hacen

Ver lineademuerteuba.r
Ver lo de agregar params de arboles

Cruzar los datasets de la linea de muerte

## Stacking

Ensamble metamodelo.
N modelos
Otro modelo que use las salidas de los anteriores para decidir la clase real.

Problema principal. Como cortar el modelo para cuando entrenar con el metamodelo no genera overfit
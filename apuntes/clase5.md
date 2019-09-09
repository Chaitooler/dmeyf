## CLase 5

Usar Train Validation y Test

Elegir el corte segun Validation, entonces evitamos el sobreajuste a train.
Luego aplicarlo sobre test para ver el fit. Se evita mucho el overfit haciendo eso.
En el dropbox ver el ejercicio en Elementary.

Rebalancear datos: Peligroso
Una metrica que no esta afectado por el rebalanco: Area bajo la curva ROC

Todas las demas son afectadas, pero se pueden corregir

LIFT tiene un tope (metrica, afectado por el rebalanceo)

Rebalanceo: Cambiaron las probabilidades, cambio el punto de corte. Juntar clases baja+1 y +2 cambia el punto de corte.
Cuando la clase es mas grande el punto de corte se mueve. Tengo mucho mas para separar

Pero...Reduje 100 veces el tiempo de entrenamiento
No es recomendable, se puede bajar a la linea de muerte facil

Parametros: Profundidad,Complejidad, Corte minimo, Cantidad de hojas, etc

Ver Metodos de sampleo! (Oversampling, Subsampling)

Grid search: Tarda mucho, busca solo lo que uno ya sabe


Correr GRID SEARCH y ver que onda. Elige el mejor modelo

Ver optimizacion heuristica. recocido
Variedad= Superficie en muchas dimensiones

Gradiente?
Random search? No es malo, gana casi lo mismo que el grid


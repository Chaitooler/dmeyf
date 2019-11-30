
#Objetivo: mostrar como se genera y aplica un modelo de LightGBM
#source( "/cloud/cloud1/R/lightgbm/lightgbm_basico_canarito_01.r" )

#limpio la memoria
rm( list=ls() )
gc()



#raiz del environment
env <- list()

directory <-list()

switch (Sys.info()[['sysname']],
         Windows = { directory$work     <-  "M:\\work\\"
                     directory$datasets <-  "M:\\datasets\\dias\\"
                   },
         Darwin  = { directory$work     <-  "~/dm/work/"
                     directory$datasets <-  "~/dm/datasets/dias/"
                   },
         Linux   = { directory$work     <-  "~/cloud/cloud1/work/"
                     directory$datasets <-  "~/cloud/cloud1/datasets/dias/"
                   }
       )
env$directory <- directory





library( "lightgbm" )
library( "Matrix" )



library( "data.table" )



data <- list()
data$campos_separador     <-  "\t"
data$campo_id             <-  "numero_de_cliente"
data$clase_nomcampo       <-  "clase_ternaria"
data$clase_valor_positivo <-  "BAJA+2"
data$campos_a_borrar      <-  c( data$campo_id )

data$archivo_generacion   <-   "201902_dias.txt"
data$archivo_aplicacion   <-   "201904_dias.txt"
env$data  <-  data

problema <- list()
problema$prob_corte           <-      0.025
problema$ganancia_acierto     <-  19500 
problema$ganancia_noacierto   <-   -500

env$problema <- problema


#Hacer que la variable   env   NO se pueda modificar
lockBinding( "env", globalenv() )

#------------------------------------------------------
#Esta funcion calcula la ganancia de una prediccion
#Quedarse solo con las predicciones con probabilidad mayor a  kprob_corte
#Si es un acierto  sumar  kganancia_acierto    ( +19500 ) 
#Si NO es acierto  sumar  kganancia_noacierto  (   -500 )

fmetrica_ganancia_lightgbm  = function( pprob_corte, probs, clases, problema )
{
 
  res <-  sum(    (probs > pprob_corte  ) * 
                   ifelse( clases== 1, problema$ganancia_acierto, problema$ganancia_noacierto ) 
                   , na.rm = TRUE  
              )

  return(  ifelse(  is.na(res) , 0, res )  
         )

}
#------------------------------------------------------------------------------

#Esta funcion calcula AUC  Area Under Curve  de la Curva ROC

fmetrica_auc_lightgbm  = function( probs, clases )
{
  pred             <-  ROCR::prediction(  probs, clases, label.ordering=c( 0, 1))
  auc_testing      <-  ROCR::performance( pred,"auc") 
 
  return( unlist(auc_testing@y.values) )

}
#------------------------------------------------------------------------------

agregar_canaritos <- function( pdataset, pcanaritos_idx )
{

  canaritos_cantidad <- as.integer( round(ncol(pdataset) * pcanaritos_idx) )
  vcanaritos <-  paste0( "canarito", 1:canaritos_cantidad )

  #uso esta semilla para los canaritos
  set.seed(10217)

  #podria haber hecho un loop for
  pdataset[ , (vcanaritos) := 0 ]
  pdataset[ , (vcanaritos) := lapply(.SD, runif), .SDcols = vcanaritos]

  #ahora hago que los canaritos sean las primeras variables del dataset
  nuevo_orden <-  c( vcanaritos, setdiff( colnames( pdataset), vcanaritos )) 
  setcolorder( pdataset, nuevo_orden )
}
#------------------------------------------------------------------------------

vcanaritos_idx <-  0.15

setwd(  env$directory$datasets )
dataset_generacion    <-   fread( cmd=paste("cat", env$data$archivo_generacion), header=TRUE, stringsAsFactors=TRUE, sep=env$data$campos_separador)


#borro las variables que no me interesan
dataset_generacion[ ,  (env$data$campos_a_borrar) := NULL    ] 

#dejo la clase en {0,1}  clase  binaria1
dataset_generacion[ , (env$data$clase_nomcampo) := as.integer(get(env$data$clase_nomcampo) == env$data$clase_valor_positivo ) ]

agregar_canaritos(  dataset_generacion,  vcanaritos_idx )

#genero el formato requerido por LightGBM
dgeneracion  <-   lgb.Dataset( data  = data.matrix(dataset_generacion[ , setdiff(names(dataset_generacion),env$data$clase_nomcampo), with=FALSE]),
                               label = dataset_generacion[, get(env$data$clase_nomcampo)], 
                               missing=NA,
                               free_raw_data=FALSE 
                              )


#-------------------------
#genero el modelo

t0       <-  Sys.time()

modelo = lgb.train( 
               data = dgeneracion,
               objective = "binary",
               metric="auc",
               seed= 102191,
               num_iterations=300,
               boost_from_average=TRUE,
               bagging_fraction=1, 
               feature_fraction=1.0, 
               learning_rate=0.010, 
               max_bin=255, 
               num_leaves=1024,
               num_canaritos= as.integer( round(ncol(dataset_generacion) * vcanaritos_idx) ),
               verbose = 1,
               min_data_in_leaf = 10
              )

t1       <-  Sys.time()

tiempo <-  as.numeric(  t1 - t0, units = "secs")

tb_importancia <-  as.data.table( lgb.importance( model = modelo ) )

#-------------------------
#aplico el modelo

setwd(  env$directory$datasets )
dataset_aplicacion <-  fread( cmd=paste("cat", env$data$archivo_aplicacion), header=TRUE, sep=env$data$campos_separador) 

#borro las variables que no me interesan
dataset_aplicacion[ ,  (env$data$campos_a_borrar) := NULL    ] 

#dejo la clase en {0,1}  clase  binaria1
dataset_aplicacion[ , (env$data$clase_nomcampo) := as.integer(get(env$data$clase_nomcampo) == env$data$clase_valor_positivo ) ]

agregar_canaritos(  dataset_aplicacion,  vcanaritos_idx )


#aplico el modelo a datos nuevos
aplicacion_prediccion  <- predict(  modelo, as.matrix( dataset_aplicacion) )



# calculo la ganancia
gan <-  fmetrica_ganancia_lightgbm( 0.025, aplicacion_prediccion,  dataset_aplicacion[ , get(env$data$clase_nomcampo)], env$problema ) 

# calculo el AUC
auc <-  fmetrica_auc_lightgbm( aplicacion_prediccion,  dataset_aplicacion[ , get(env$data$clase_nomcampo)] ) 


cat( "ganancia = ",  gan , "\n")
cat( "AUC = ",  auc, "\n"  )
cat( "tiempo = ",  tiempo, "\n"  )



library(xgboost)
library( "data.table" )

n_experimento = "1"

dataset_dir = "E:/Chaito/Desktop/Facultad/dmeyf/data"
dataset_name = "paquete_premium_exthist.txt.gz"
resultados_dir = "E:/Chaito/Desktop/Facultad/dmeyf/work"
file_probabilidades = paste(paste("probs", n_experimento),".txt") 
file_entregable = paste(paste("entregar", n_experimento), ".txt")
file_importancia = paste(paste("importancia",n_experimento),".txt")
punto_corte = 0.025

mes_test = 201904

mes_min = 201902
mes_max = 201902

############################
#### FUNCIONES
############################


entrenar_modelo <- function(dataset,
                            mes_min = 201805,
                            mes_max = 201902,
                            
                            objective= "binary:logistic",
                            tree_method= "hist",
                            max_bin= 31,
                            eta= 0.04,
                            nrounds= 300, 
                            colsample_bytree= 0.6
) {
  dtrain <- xgb.DMatrix( data = data.matrix( dataset[ foto_mes>=mes_min & foto_mes<=mes_max , !c("numero_de_cliente","clase_ternaria"), with=FALSE]),
                         label = dataset[ foto_mes>=mes_min & foto_mes<=mes_max, clase_ternaria ]
  )
  
  xgb.train(
    data= dtrain,
    objective=objective,
    tree_method=tree_method,
    max_bin=max_bin,
    eta=eta,
    nrounds=nrounds, 
    base_score= mean( getinfo(dtrain, "label") )
  )
}

############################

cargar_dataset <- function() {
  setwd(dataset_dir)
  dataset <- fread(dataset_name)
  dataset[, clase_ternaria := as.integer(clase_ternaria=="BAJA+2") ]
  dataset
}

############################

validar_test <- function(modelo, dataset, mes_test) {
  daplicacion <- xgb.DMatrix( data  = data.matrix( dataset[ foto_mes==mes_test, !c("numero_de_cliente","clase_ternaria"), with=FALSE]),
                              label = dataset[ foto_mes==mes_test, clase_ternaria ]
  )
  aplicacion_prediccion  <- predict(modelo, daplicacion )
  prediccion_final  <-  cbind(dataset[ foto_mes==mes_test, c("numero_de_cliente","clase_ternaria") ], aplicacion_prediccion )
  colnames(prediccion_final) <-  c( "numero_de_cliente", "clase01", "prob_positivo" )
  
  prediccion_final
}
############################

imprimir_resultados <- function(prediccion_final, modelo, punto_corte) {
  
  setwd(resultados_dir)
  fwrite( prediccion_final[ order( -prob_positivo) ], 
          file=file_probabilidades, 
          sep="\t", 
          eol = "\r\n")
  
  
  fwrite( as.data.table( prediccion_final[ prob_positivo > punto_corte  , "numero_de_cliente" ] ), 
          file=file_entregable, 
          col.names=FALSE, 
          sep="\t", 
          eol = "\r\n")
  
  write.table(  xgb.importance( model = modelo )
                , file=file_importancia
                , sep="\t"
                , eol = "\r\n"
  )
}
############################



############################
#### MAIN
############################

set.seed(102191)

ds = cargar_dataset()
mod = entrenar_modelo(ds, mes_min, mes_max)
pred = validar_test(mod, ds, mes_test)
#imprimir_resultados(pred, mod, punto_corte)

print(sum(pred[ prob_positivo>punto_corte,ifelse( clase01 == 1  , 19500, -500) ] ))

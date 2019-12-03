library(xgboost)
library( "data.table" )

n_experimento = "promedios"

dataset_dir = "/Users/christianmarcusa/Desktop/Maestria/dmeyf/datasets"
dataset_name = "modelitos.txt.gz"

hiperparametros_file = "hiperparametro_GLOBAL.txt"

probabilidades_dir = "/Users/christianmarcusa/Desktop/Maestria/dmeyf/work"

resultados_dir = "/Users/christianmarcusa/Desktop/Maestria/dmeyf/work"

file_probabilidades = paste(paste("probs", n_experimento),".txt") 
file_entregable = paste(paste("entregar", n_experimento), ".txt")
file_ganancia = paste(paste("ganancia",n_experimento),".txt")

punto_corte = 0.025

### ABRIL
input_probabilidades_ldm04 = "cloud1_work_lineademuerte_probabilidades_UBA.txt"
input_probabilidades_mod04 = "probs_modelitos_04.txt"

setwd(probabilidades_dir)
probs_ldm04 = fread(input_probabilidades_ldm04,
              sep= "\t")
probs_mod04 = fread(input_probabilidades_mod04
                  ,
                  sep= "\t")

## MARZO
input_probabilidades_ldm03 = "probs_201903_ldm.txt"
input_probabilidades_mod03 = "probs_modelitos_201903.txt"

setwd(probabilidades_dir)
probs_ldm03 = fread(input_probabilidades_ldm03,
                  sep= "\t")
probs_mod03 = fread(input_probabilidades_mod03
                  ,
                  sep= "\t")

## FEBRERO

input_probabilidades_ldm02 = "probs_201902_ldm.txt"
input_probabilidades_mod02 = "probs_modelitos_201902.txt"

setwd(probabilidades_dir)
probs_ldm02 = fread(input_probabilidades_ldm02,
                  sep= "\t")
probs_mod02 = fread(input_probabilidades_mod02
                  ,
                  sep= "\t")
## ENERO

input_probabilidades_ldm01 = "probs_201901_ldm.txt"
input_probabilidades_mod01 = "probs_modelitos_201901.txt"

setwd(probabilidades_dir)
probs_ldm01 = fread(input_probabilidades_ldm01,
                  sep= "\t")
probs_mod01 = fread(input_probabilidades_mod01
                  ,
                  sep= "\t")
## JUNIO 18

input_probabilidades_ldm06 = "probs_201806_ldm.txt"
input_probabilidades_mod06 = "probs_modelitos_201806.txt"

setwd(probabilidades_dir)
probs_ldm06 = fread(input_probabilidades_ldm06,
                  sep= "\t")
probs_mod06 = fread(input_probabilidades_mod06
                  ,
                  sep= "\t")



### FUNCTIONS
library(dplyr)

ganancia <- function(probs, pdc=punto_corte) {
  sum(probs[ prob_positivo>pdc,ifelse( clase01 == 1  , 19500, -500) ] )
}

mymerge <- function(x, y) {
  merge(x, y, by="numero_de_cliente", all=TRUE)
}

calc_promedios <- function (probs_ldm, probs_mod) {
  promedios = merge(probs_ldm, probs_mod, by="numero_de_cliente", all=TRUE)
  print(colnames(promedios))
  promedios$prob_positivo <- rowMeans(subset(promedios, select = c(prob_positivo.y, prob_positivo.x)), na.rm = TRUE)
  promedios$clase01 <- promedios$clase01.x
  promedios
}


## GANANCIAS 

# Work

#GanciasLDM 0.25
ganancia(probs_ldm04)
ganancia(probs_ldm03)
ganancia(probs_ldm02)
ganancia(probs_ldm01)
ganancia(probs_ldm06)

#Ganancias MOD 0.25
ganancia(probs_mod04)
ganancia(probs_mod03)
ganancia(probs_mod02)
ganancia(probs_mod01)
ganancia(probs_mod06)

#GanciasLDM 0.27
ganancia(probs_ldm04, 0.027)
ganancia(probs_ldm03, 0.027)
ganancia(probs_ldm02, 0.027)
ganancia(probs_ldm01, 0.027)
ganancia(probs_ldm06, 0.027)

#Ganancias MOD 0.27
ganancia(probs_mod04, 0.027)
ganancia(probs_mod03, 0.027)
ganancia(probs_mod02, 0.027)
ganancia(probs_mod01, 0.027)
ganancia(probs_mod06, 0.027)


#Ganancia en MERGE con 0.025
ganancia(calc_promedios(probs_ldm04, probs_mod04), 0.025)
ganancia(calc_promedios(probs_ldm03, probs_mod03), 0.025)
ganancia(calc_promedios(probs_ldm02, probs_mod02), 0.025)
ganancia(calc_promedios(probs_ldm01, probs_mod01), 0.025)
ganancia(calc_promedios(probs_ldm06, probs_mod06), 0.025)

#Ganancia en MERGE con 0.027
ganancia(calc_promedios(probs_ldm04, probs_mod04), 0.027)
ganancia(calc_promedios(probs_ldm03, probs_mod03), 0.027)
ganancia(calc_promedios(probs_ldm02, probs_mod02), 0.027)
ganancia(calc_promedios(probs_ldm01, probs_mod01), 0.027)
ganancia(calc_promedios(probs_ldm06, probs_mod06), 0.027)

#Ganancia en MERGE con 0.026
ganancia(calc_promedios(probs_ldm04, probs_mod04), 0.026)
ganancia(calc_promedios(probs_ldm03, probs_mod03), 0.026)
ganancia(calc_promedios(probs_ldm02, probs_mod02), 0.026)
ganancia(calc_promedios(probs_ldm01, probs_mod01), 0.026)
ganancia(calc_promedios(probs_ldm06, probs_mod06), 0.026)

#Ganancia en MERGE con 0.024
ganancia(calc_promedios(probs_ldm04, probs_mod04), 0.024)
ganancia(calc_promedios(probs_ldm03, probs_mod03), 0.024)
ganancia(calc_promedios(probs_ldm02, probs_mod02), 0.024)
ganancia(calc_promedios(probs_ldm01, probs_mod01), 0.024)
ganancia(calc_promedios(probs_ldm06, probs_mod06), 0.024)

#Ganancia en MERGE con 0.0245
ganancia(calc_promedios(probs_ldm04, probs_mod04), 0.0245)
ganancia(calc_promedios(probs_ldm03, probs_mod03), 0.0245)
ganancia(calc_promedios(probs_ldm02, probs_mod02), 0.0245)
ganancia(calc_promedios(probs_ldm01, probs_mod01), 0.0245)
ganancia(calc_promedios(probs_ldm06, probs_mod06), 0.0245)

#Ganancia en MERGE con 0.025
ganancia(calc_promedios(probs_ldm04, probs_mod04), 0.0255)
ganancia(calc_promedios(probs_ldm03, probs_mod03), 0.0255)
ganancia(calc_promedios(probs_ldm02, probs_mod02), 0.0255)
ganancia(calc_promedios(probs_ldm01, probs_mod01), 0.0255)
ganancia(calc_promedios(probs_ldm06, probs_mod06), 0.0255)

######################
## Entregable final


calc_promedios_entrega <- function (probs_ldm, probs_mod) {
  promedios = merge(probs_ldm, probs_mod, by="numero_de_cliente", all=TRUE)
  print(colnames(promedios))
  promedios$prob_positivo <- rowMeans(subset(promedios, select = c(prob_positivo.y, prob_positivo.x)), na.rm = TRUE)
  promedios
}

probs_ldmENTREGA = fread('lineademuerte_probabilidades_UBA.txt',
                    sep= "\t")
probs_modENTREGA = fread('probs_modelitos201906.txt',
                    ,
                    sep= "\t")

prediccion_final = calc_promedios_entrega(probs_ldmENTREGA, probs_modENTREGA)

positivos_final = prediccion_final[ prob_positivo > 0.025  , c("numero_de_cliente", "prob_positivo") ]

fwrite( as.data.table( positivos_final[  , "numero_de_cliente" ] ), 
        file='ENTREGABLE_FINAL.txt', 
        col.names=FALSE, 
        sep="\t", 
        eol = "\r\n")

#EN CONSTRUCCION
#Aun no funciona

#limpio la memoria
rm( list=ls() )
gc()


library("data.table" )
library("stringr")


#raiz del environment
env <- list()

directory <-list()
switch (Sys.info()[['sysname']],
         Windows = { 
                     directory$work           <-  "M:\\work\\"
                     directory$work_graficos  <-  "M:\\work\\graficos\\"
                     directory$datasets       <-  "M:\\datasets\\"
                     directory$datasets       <-  "M:\\datasetsOri\\"
                   },
         Darwin  = { 
                     directory$work           <-  "~/dm/work/"
                     directory$work_graficos  <-  "~/dm/work/graficos/"
                     directory$datasets       <-  "~/dm/datasets/"
                     directory$datasetsOri    <-  "~/dm/datasetsOri/"
                   },
         Linux   = { 
                     directory$work           <-  "~/cloud/cloud1/work/"
                     directory$work_graficos  <-  "~/cloud/cloud1/work/graficos/"
                     directory$datasets       <-  "~/cloud/cloud1/datasets/"
                     directory$datasetsOri    <-  "~/cloud/cloud1/datasetsOri/"
                   }
       )
env$directory <- directory

data <- list()
data$campos_separador     <-  "\t"
data$campo_foto           <-  "foto_mes"
data$campo_id             <-  "numero_de_cliente"
data$clase_nomcampo       <-  "clase_ternaria"
data$clase_valor_positivo <-  "BAJA+2"
data$campos_a_borrar      <-  c()
data$archivo_grande       <-  "paquete_premium_dias.txt"
env$data <- data


#Hacer que la variable   env   NO se pueda modificar
lockBinding( "env", globalenv() )


#------------------------------------------------------------------------------

grafico_xclase  <- function( ptabla,  pnombre )
{
  setwd(env$directory$work_graficos)

  vfoto <- env$data$campo_foto

  xmin <- 1
  xmax <- length( unique( ptabla[ , get(vfoto)] ) )
  
  columnas <-  setdiff( colnames( ptabla ), c( env$data$clase_nomcampo, env$data$campo_foto  ) )
  for(  vcampo  in columnas )
  {
  
    
    jpeg(file = paste0(vcampo,"_", pnombre, ".jpg"),  width = 6, height = 4, units = 'in', res = 200)
   
    ymin <- min( ptabla[ , get(vcampo)],  na.rm=TRUE)
    ymax <- max( ptabla[ , get(vcampo)],  na.rm=TRUE)
   

    plot( xmin:xmax,
          ptabla[ clase_ternaria=="CONTINUA", get(vcampo)],
          main= paste( pnombre, "  ", vcampo, "  rojo=BAJA+2"),
          xlab= "Periodo",
          ylab= vcampo,
          pch= 19,
          xlim=c(1, xmax),
          ylim=c(pmin(0,ymin), ymax*1.10 ),
          yaxs="i",
          xaxt="n"
        )

    axis(1, at=xmin:xmax, labels=unique(ptabla[ , get(vfoto)])) 
    
    lines( xmin:xmax, ptabla[ clase_ternaria=="BAJA+2",   get(vcampo)], type="o" , col="red",   lwd=2)
    lines( xmin:xmax, ptabla[ clase_ternaria=="BAJA+1",   get(vcampo)], type="o" , col="blue",  lwd=1)
    lines( xmin:xmax, ptabla[ clase_ternaria=="CONTINUA", get(vcampo)], type="o" , col="black", lwd=2)
 
    #enero
    abline(v=c(7,19,31), col=c("black", "black", "black"), lty=c(3,3,3), lwd=c(1,1,1))
    
    #201904
    abline(v=c(34), col=c("grey"), lty=c(3), lwd=c(1))

    dev.off()

  }
}
#------------------------------------------------------------------------------


grafico_simplisimo  <- function( ptabla,  pnombre )
{
  setwd(env$directory$work_graficos)

  vfoto <- env$data$campo_foto

  xmin <- 1
  xmax <- length( unique( ptabla[ , get(vfoto)] ) )
  
  columnas <-  setdiff( colnames( ptabla ), c( env$data$clase_nomcampo, env$data$campo_foto  ) )
  for(  vcampo  in columnas )
  {
  
    
    jpeg(file = paste0(vcampo,"_", pnombre, ".jpg"),  width = 6, height = 4, units = 'in', res = 200)
   
    ymin <- min( ptabla[ , get(vcampo)],  na.rm=TRUE)
    ymax <- max( ptabla[ , get(vcampo)],  na.rm=TRUE)
   

    plot( xmin:xmax,
          ptabla[ tipo=="media", get(vcampo)],
          main= paste( pnombre, "  ", vcampo, "  rojo=no_cero"),
          xlab= "Periodo",
          ylab= vcampo,
          pch= 19,
          xlim=c(1, xmax),
          ylim=c(pmin(0,ymin), ymax*1.10 ),
          yaxs="i",
          xaxt="n"
        )

    axis(1, at=xmin:xmax, labels=unique(ptabla[ , get(vfoto)])) 
    
    lines( xmin:xmax, ptabla[ tipo=="media", get(vcampo)], type="o" , col="blue", lwd=2)
    lines( xmin:xmax, ptabla[ tipo=="media_nocero", get(vcampo)], type="o" , col="red", lwd=2)
 
    #enero
    abline(v=c(7,19,31), col=c("black", "black", "black"), lty=c(3,3,3), lwd=c(1,1,1))
    
    #201904
    abline(v=c(34), col=c("grey"), lty=c(3), lwd=c(1))

    dev.off()

  }
}
#------------------------------------------------------------------------------

mean_nocero <-  function( v )
{
 v2 <- v[ v!=0 ]
 if( length(v2)==0 )  return(0)
 
 return(  as.numeric(mean(  v2, na.rm=TRUE  )))
}
#------------------------------------------------------------------------------

#Leo el dataset original
setwd(  env$directory$datasets )
dataset_grande     <- fread(env$data$archivo_grande )

#ordeno el dataset
setorder( dataset_grande, env$data$campo_foto, env$campo_id )

columnas_graficar  <-  setdiff(  colnames(dataset_grande), c( env$data$clase_nomcampo  ) )


#Calculo de metricas

#calculo las medias de una sola vez
tb_medias  <-   dataset_grande[  ,  
                               lapply( .SD, mean, na.rm=TRUE),   #la operacion que hago para todas las columnas 
                               by= c(env$data$campo_foto),           #por lo que agrupo
                               .SDcols= columnas_graficar        #las columnas que me interesan
                              ]

tb_medias_nocero  <-   dataset_grande[  ,  
                                      lapply( .SD, mean_nocero),   #la operacion que hago para todas las columnas 
                                      by= c(env$data$campo_foto),           #por lo que agrupo
                                     .SDcols= columnas_graficar        #las columnas que me interesan
                                     ]


tb_medias[ , tipo:= "media" ]
tb_medias_nocero[ , tipo:= "media_nocero" ]

tb_media <-  rbind( tb_medias, tb_medias_nocero )


#creo la carpeta donde van los resultados
dir.create( env$directory$work_graficos, showWarnings = FALSE)


grafico_simplisimo( tb_media, "media" )


#Ahora hago la apertura segun la clase


columnas_graficar  <-  setdiff(  colnames(dataset_grande), c( env$data$clase_nomcampo, env$data$campo_foto  ) )

tb_medias  <-   dataset_grande[  ,  
                               lapply( .SD, mean, na.rm=TRUE),   #la operacion que hago para todas las columnas 
                               by= c(env$data$campo_foto, data$clase_nomcampo),           #por lo que agrupo
                               .SDcols= columnas_graficar        #las columnas que me interesan
                              ]

grafico_xclase( tb_medias[foto_mes<=201904], "mediaxclase" )

 
unique( dataset_grande[  foto_mes==201904 &clase_ternaria=="BAJA+2", mttarjeta_visa_debitos_automaticos]  )
 
 
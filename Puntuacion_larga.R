#!/usr/bin/Rscript
result = tryCatch({
  # Comenta o modifica la línea setwd dependiendo de tu directorio
  setwd("~/RFolder")
}, error = function(e) {
  print('No se pudo cambiar el directorio de trabajo a ~/RFolder');
  print('Ejecutando script en el directorio actual...');
})
source("ScriptsAuxiliares/util.R")
source("ScriptsAuxiliares/getResults.R")

#ACCIÓN REQUERIDA
#Edita si fuese necesario el nombre del csv y el fichero de texto 'output' donde quieres que se vuelquen los datos.

prueba<-data.frame()
prueba<-getResults('./csv/larga.csv','./csv/info.csv')
output<-'./resultadosLarga.txt'

sink(file=output)
print(prueba)
sink()
print(paste('Fin puntuaciones larga, comprueba el archivo: ', output))



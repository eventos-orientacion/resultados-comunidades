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

prueba<-getResults('./csv/sprint.csv','./csv/info.csv')
output<-'./resultadosSprint.txt'

sink(file=output)
print(prueba)
sink()
print(paste('Fin puntuaciones sprint, comprueba el archivo: ', output))

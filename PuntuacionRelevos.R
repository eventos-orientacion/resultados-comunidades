#!/usr/bin/Rscript
result = tryCatch({
  # Comenta o modifica la l�nea setwd dependiendo de tu directorio
  setwd("~/RFolder")
}, error = function(e) {
  print('No se pudo cambiar el directorio de trabajo a ~/RFolder');
  print('Ejecutando script en el directorio actual...');
})
source("ScriptsAuxiliares/util.R")
source("ScriptsAuxiliares/getResultsRelevos.R")

#Nombre del fichero csv
input<-'./csv/relevos.csv'

#Nombre del ficheros de puntuaciones m�ximas csv
maxPunt<-'./csv/info.csv'

#Se genera un dataframe 'maxPuntuaciones' con las puntuaciones m�ximas a las que opta cada categor�a.220 por defecto
resultados<-getResultsRelevos(input,maxPunt)

output<-'./resultadosRelevos.txt'
sink(file=output)
print(resultados)
sink()
print(paste('Fin puntuaciones relevos, comprueba el archivo: ', output))

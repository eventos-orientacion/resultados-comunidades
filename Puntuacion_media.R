setwd("~/RFolder")
source("ScriptsAuxiliares/util.R")
source("ScriptsAuxiliares/getResults.R")

#ACCIÓN REQUERIDA
#Edita si fuese necesario el nombre del csv y el fichero de texto 'output' donde quieres que se vuelquen los datos.

prueba<-getResults('./csv/media.csv','./csv/info.csv')
output<-'./resultadosMedia.txt'

sink(file=output)
print(prueba)
sink()
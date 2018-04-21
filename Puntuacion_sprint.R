setwd("~/RFolder")
source("ScriptsAuxiliares/util.R")
source("ScriptsAuxiliares/getResults.R")

#ACCIÓN REQUERIDA
#Edita si fuese necesario el nombre del csv y el fichero de texto 'output' donde quieres que se vuelquen los datos.

prueba<-getResults('./csv/sprint.csv','./csv/info.csv')
output<-'./resultadosSprint.txt'

sink(file=output)
print(prueba)
sink()
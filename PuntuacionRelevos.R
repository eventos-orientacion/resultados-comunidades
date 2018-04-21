setwd("~/RFolder")
source("ScriptsAuxiliares/util.R")
source("ScriptsAuxiliares/getResultsRelevos.R")

#Nombre del fichero csv
input<-'./csv/relevos.csv'

#Nombre del ficheros de puntuaciones m�ximas csv
maxPunt<-'./csv/info.csv'

#Se genera un dataframe 'maxPuntuaciones' con las puntuaciones m�ximas a las que opta cada categor�a.220 por defecto
resultados<-getResultsRelevos(input,maxPunt)

sink(file="resultadosRelevos.txt")
print(resultados)
sink()
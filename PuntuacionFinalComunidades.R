rm(list = ls())
setwd("~/RFolder")
source("ScriptsAuxiliares/util.R")
source("ScriptsAuxiliares/getResults.R")
source("ScriptsAuxiliares/getResultsRelevos.R")
source("ScriptsAuxiliares/auxCalculoComunidades.R")

csvLarga<-'./csv/larga.csv'
csvMedia<-'./csv/media.csv'
csvSprint<-'./csv/sprint.csv'
csvRelevos<-'./csv/relevos.csv'

csvInfo<-'./csv/info.csv'



#ACCIÓN REQUERIDA 2
#Edita si fuese necesario los nombres de los csv, ficheros de texto y mira que se utilice el vector 'maxPuntuacionesX' correcto.
larga<-getResults(csvLarga,csvInfo)
media<-getResults(csvMedia,csvInfo)
sprint<-getResults(csvSprint,csvInfo)
relevos<-getResultsRelevos(csvRelevos,csvInfo)


#RESULTADO PRUEBAS INDIVIDUALES#
#Le añade al data frame en cuestión la columna de categoría (cadete, junior, senior y veterano).
#Esta información la saca del 

larga<-addCategory(larga,csvInfo)
media<-addCategory(media,csvInfo)
sprint<-addCategory(sprint,csvInfo)

larga<-larga[,c(1,3,4)]
media<-media[,c(1,3,4)]
sprint<-sprint[,c(1,3,4)]

#Suma los 3 mejores tiempos de cadetes y junior, los 4 mejores de veteranos y los 7 mejores de senior. 
#Cada comunidad acaba teniendo un total de hasta 4 entradas (cadete, junior, senior, veterano)
larga<-sumBestCatTimes(larga,csvInfo)
media<-sumBestCatTimes(media,csvInfo)
sprint<-sumBestCatTimes(sprint,csvInfo)

#Puntuación final para esa carrera. Suma las 4 entradas de categorías
#debug(sumEntriesByRegion)
larga<-sumEntriesByRegion(larga)
media<-sumEntriesByRegion(media)
sprint<-sumEntriesByRegion(sprint)


finalIndResults<-finalIndividualRaces(larga,media,sprint)


#RESULTADO RELEVOS


finalRelaysResults<-sumBestRelayTimes(relevos)


#RESULTADOS FINALES POR COMUNIDAD
#debug(mergeRelaysAndIndividual)

finales<-mergeRelaysAndIndividual(finalIndResults,finalRelaysResults)


sink(file='ResultadosFinalesPorComunidades.txt')
print(finalIndResults)
print(finalRelaysResults)
print(finales)
sink()
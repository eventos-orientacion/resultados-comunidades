addCategory<-function(resultadosDF,csvInfo){

info<- read.csv2(csvInfo,stringsAsFactors = F, header=T,sep=";")

info$Categoria<-factor(info$Categoria)


categoria<-factor(c(rep("",length(resultadosDF$puntuacion))))
levels(categoria)<-levels(info$Categoria)
resultadosDF$Categoria<-categoria
resultadosDF<-resultadosDF[,c(3,5,7,6)]
names(resultadosDF)<-c('Region','Corto','Categoria','Puntuacion')
resultadosDF<-resultadosDF[order(resultadosDF$Puntuacion, decreasing = TRUE),]
resultadosDF<-resultadosDF[order(resultadosDF$Categoria,resultadosDF$Region),]

for(i in levels(info$Categoria)){
  corto<-resultadosDF$Corto
  cat<-info$Categoria
  resultadosDF$Categoria[resultadosDF$Corto %in% info[info$Categoria==i,]$Individuales]<-i
}

resultadosDF<-resultadosDF[!is.na(resultadosDF$Categoria),]
resultadosDF<-resultadosDF[order(resultadosDF$Puntuacion, decreasing = TRUE),]
resultadosDF<-resultadosDF[order(resultadosDF$Region, resultadosDF$Categoria),]

return(resultadosDF)
}



sumBestCatTimes<-function(resInd,csvInfo){
  #csvInfo contiene en sus dos primeras columnas el número de corredores por categoría que se tendrán en consideración.
  info<-read.csv2(csvInfo,stringsAsFactors = F, header=T,sep=";")
  info<-info[,c(1,2)]
  info<-info[!is.na(info$CECcorredores),]
  
  #Iteración en todas las regiones. Se hacen subsets del dataframe resInd que se almacenan en aux
  resultados<-data.frame()
  for(i in levels(resInd$Region)){
    #aux contiene una sola comunidad autónoma
    aux<-subset(resInd,resInd$Region==i)
    #Iterar solo si la Región tiene más de 0 corredores en total
    if(length(aux$Puntuacion)>0){
      aux$Categoria<-factor(aux$Categoria)
      for(j in levels(aux$Categoria)){
        aux2<-subset(aux,aux$Categoria==j)
        #Iterar solo en caso de que la categoría tenga más de 0 corredores
        if(length(aux2$Puntuacion)>0){
          #Hay que controlar que número de iteración es porque es distinto según la categoría
          
          #Este for itera en aux2 que tiene una categoría y una comunidad.
          for(cont in 1:length(aux2$Puntuacion)){
            if(cont<length(aux2$Puntuacion)){aux2$Puntuacion[1]=aux2$Puntuacion[1]+aux2$Puntuacion[cont+1]}
            #Si se alcanza el número máximo de corredores considerado para la categoría en cuestión (almacenado en info$CECcorrredores) entonces break
              if(cont==(info[info$CECLevels %in% j,]$CECcorredores)-1){
                break
              }
          }
          resultados=rbind(resultados,aux2[1,])
        }
      }    
    }
  }
  
  return(resultados)
}

sumEntriesByRegion<-function(race){
  results<-data.frame()
  race<-race[,c(1,3)]
  race$Region<-factor(race$Region)
  for(i in levels(race$Region)){
    aux<-subset(race,race$Region==i)
    if(length(aux$Puntuacion>1)){aux$Puntuacion[1]=sum(aux$Puntuacion)}
    aux=aux[1,]
    results<-rbind(results,aux)
    }
  
  return(results)
}

finalIndividualRaces<-function(larga,media,sprint){
  races<-rbind(larga,media,sprint)
  races$Region<-factor(races$Region)
  results<-data.frame()
  for(i in levels(races$Region)){
    aux<-subset(races,races$Region==i)
    aux$Larga[1]<-round(aux$Puntuacion[1],digits=2)
    aux$Media[1]<-round(aux$Puntuacion[2],digits=2)
    aux$Sprint[1]<-round(aux$Puntuacion[3],digits=2)
    aux$Puntuacion[1]=round(sum(aux$Puntuacion),digits=2)
    aux=aux[1,]
    results<-rbind(results,aux)
  }
  results<-results[,c(1,3,4,5,2)]
  results<-results[order(results$Puntuacion, decreasing = TRUE),]
  names(results)<-c('Region','Larga','Media','Sprint','TotalIndiv')
  return(results)
}

sumBestRelayTimes<-function(relevos){

relevos<-relevos[!is.na(relevos$Puntuacion[]),]
relevos<-relevos[order((relevos$Puntuacion), decreasing = TRUE),]
relevos<-relevos[order(relevos$Region),]
resultadoRelevos<-data.frame()
relevos$Region<-factor(relevos$Region)

for(i in levels(relevos$Region)){
  comunidad<- subset(relevos,relevos$Region[]==i)
  
  for(j in 1:4) {
    if(j<length(comunidad$Puntuacion)){
      comunidad$Puntuacion[1]=comunidad$Puntuacion[1] + comunidad$Puntuacion[j+1]
    }
  }
  resultadoRelevos<-rbind(resultadoRelevos,comunidad[1,])
}

resultadoRelevos$NumeroClub<-NULL
resultadoRelevos$Categoria<-NULL
resultadoRelevos$Puntuacion[is.na(resultadoRelevos$Puntuacion)]<-0
resultadoRelevos<-resultadoRelevos[order(resultadoRelevos$Puntuacion, decreasing = TRUE),]
names(resultadoRelevos)<-c('Region','TotalRelevos')
return(resultadoRelevos)
}


mergeRelaysAndIndividual<-function(finalIndResults,finalRelaysResults){
 
  auxIndResults<-finalIndResults[,c(1,5)]
  names(auxIndResults)<-c('Region','TOTAL')
  names(finalRelaysResults)<-c('Region','TOTAL')
  finales<-data.frame()
  aux<-rbind(auxIndResults,finalRelaysResults)
  aux$Region<-factor(aux$Region)
  for(i in levels(aux$Region)){
    aux2<-subset(aux,aux==i)
    aux2$TOTAL[1]=round(sum(aux2$TOTAL),digits=2)
      aux3<-subset(auxIndResults,auxIndResults$Region==i)
    aux2$TotalIndividuales[1]<-aux3$TOTAL[1]
      aux3<-subset(finalRelaysResults,finalRelaysResults$Region==i)
    aux2$TotalRelevos[1]<-aux3$TOTAL[1]
    finales<-rbind(finales,aux2[1,])
  }
  finales$TOTAL[is.na(finales$TOTAL)]<-0
  finales$TotalIndividuales[is.na(finales$TotalIndividuales)]<-0
  finales$TotalRelevos[is.na(finales$TotalRelevos)]<-0
  
 
  finales<-finales[c(1,3,4,2)]
  names(finales)<-c('Region','TotalIndiv','TotalRelevos','TOTAL')
  finales=finales[order(finales$TOTAL, decreasing = TRUE),]
  
 return(finales)
}



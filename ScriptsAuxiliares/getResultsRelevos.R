getResultsRelevos<-function(input,maxPunt){
  
  #Lee el fichero csv y lo almacena en currentCsv
  currentCsv<- read.csv2(input,stringsAsFactors = F, header=T,sep=";",fileEncoding="latin1")
  
  #Factorizo currentCsv$corto y región
  currentCsv$Corto<-factor(currentCsv$Corto)
  currentCsv$Región<-factor(currentCsv$Región)
  
  #Se da formato de tiempos correcto a currentCsv$Tiempo, usando la función setDate
  currentCsv$Tiempo<-setDate(currentCsv$Tiempo)
  
  
  #Se crea dataframe resultados con las columnas Region, NumeroClub, Categoria, Tiempo, Puntuacion y Xtra4(competitivo o no) cogidas del csv
  resultados<-data.frame(currentCsv$Región, currentCsv$Descr,currentCsv$Corto,currentCsv$Tiempo,c(rep(0,length(currentCsv$Tiempo))),currentCsv$nc)
  colnames(resultados)<-c('Region','NumeroClub','Categoria', 'Tiempo', 'Puntuacion','Competitivo')
  #Se ordena el dataFrame de resultados por categoría(1º) y por Tiempos(2º)
  resultados<-resultados[order(resultados$Categoria,resultados$Tiempo),]
  
  #Se crea el data.frame maxPuntuaciones con dos columnas, las distintas categorías (corto) y las puntuaciones máximas a las que aspiran
  csvName<-input
  remove<-'./csv/'
  csvName <- sub(remove,"", csvName)
  
  maxPuntuaciones<- read.csv2(maxPunt,stringsAsFactors = T, header=T,sep=";")
  
  tiempoMax<-maxPuntuaciones[maxPuntuaciones$Carrera==csvName,]$TiempoMax
  tiempoMax<-tiempoMax*60
  puntMin<-maxPuntuaciones[maxPuntuaciones$Carrera==csvName,]$PuntuacionMin
  
  maxPuntuaciones<-maxPuntuaciones[!is.na(maxPuntuaciones[,9]),]
  maxPuntuaciones<-maxPuntuaciones[c(1:length(maxPuntuaciones[,8])),c(8,9)]
  colnames(maxPuntuaciones)<-c('Categorias','Puntuaciones')
  
  
  
  
  #Bucle for principal para asignar resultados en base a tiempos.
  for(i in levels(maxPuntuaciones$Categorias)){
    aux<-subset(resultados,resultados$Categoria==i)
    #Ver si hay corredores en la categoría
    if(length(aux$Puntuacion>0)){
      a<-(maxPuntuaciones$Categorias[]==i)
      #print(aux)
      for(z in 1:length(aux$Puntuacion)){
        if(!aux$Competitivo[z]=='X'){
          aux$Puntuacion[z]<-maxPuntuaciones$Puntuaciones[a]
          tiempoGanador<-getTimeinSecs(aux$Tiempo[z])
          if(tiempoGanador>tiempoMax){aux$Puntuacion[z]<-puntMin}
          break
        } else{
          aux$Puntuacion[z]<-0
        }
      }
      if(z<length(aux$Puntuacion)){
        for(j in (z+1):length(aux$Puntuacion)){
          if(!aux$Competitivo[j]=='X'){
            tiempoCorredor<-getTimeinSecs(aux$Tiempo[j])
            if(is.na(tiempoCorredor)){
              aux$Puntuacion[j]<-0
            }else{
              if(!(aux$Puntuacion[z])==0){
                aux$Puntuacion[j]<-(tiempoGanador/tiempoCorredor)*aux$Puntuacion[z]
                if(tiempoCorredor>tiempoMax){aux$Puntuacion[j]<-puntMin}
              }else{
                aux$Puntuacion[j]<-0
              }
            }
          }
        }
      }
      resultados$Puntuacion[resultados$Categoria==i]<-aux$Puntuacion 
    }
       
}
  #Se elimina la columna de tiempos del dataframe resultados ya que no interesa en el informe
  resultados$Tiempo<-NULL
  resultados$Puntuacion[is.na(resultados$Puntuacion)]<-0
  resultados<-resultados[,c(1,2,3,4)]
  return(resultados) 
  
}

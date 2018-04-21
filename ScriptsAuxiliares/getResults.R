#Recive el nombre del fichero csv que lee y el nombre del fichero txt donde se guardarán los resultados.
getResults<-function(input,maxPunt){
 
#Retirar el comentario de estas líneas para test/debugging 
#setwd("~/RFolder")
#source("util.R")  
#getResults<-function(){
#  input<-'media.csv'
#  output<-'resultadosMedia.txt'
#  maxPunt<-c(100, 100, 100, 60, 100, 100, 100, 60, 100, 60, 100, 100, 100, 100, 100, 100, 125, 100, 100, 100, 60, 100, 100, 100, 60, 100, 60, 100, 100, 100, 100, 100, 100, 125, 0, 0, 0)

  currentCsv<- read.csv2(input,stringsAsFactors = F, header=T,sep=";",fileEncoding="latin1")
 
  
  #Factorizo currentCsv$corto y región
  currentCsv$Corto<-factor(currentCsv$Corto)
  currentCsv$Región<-factor(currentCsv$Región)
  
  #Se da formato de tiempos correcto a currentCsv$Tiempo, currentCsv$Salida y currentCsv$Meta usando la función setDate

  #currentCsv[currentCsv$Corto=='M-12']&Tiempo<-setDate(currentCsv[currentCsv$Nombre=='M-12']$Tiempo)
  
  currentCsv$Tiempo<-setDate(currentCsv$Tiempo)
  currentCsv$Salida<-setDate(currentCsv$Salida)
  currentCsv$Meta<-setDate(currentCsv$Meta)
  
#Genero un data Frame 'maxPuntuaciones' con la lista de categorías y la puntuación máxima posible para la misma.
  #maxPuntuaciones=data.frame(levels(currentCsv$Corto),maxPunt)
  maxPuntuaciones <-read.csv2(maxPunt,stringsAsFactors = T,header=T,sep=";")
  
  csvName<-input
  remove<-'./csv/'
  csvName <- sub(remove,"", csvName)
  tiempoMax<-maxPuntuaciones[maxPuntuaciones$Carrera==csvName,]$TiempoMax
  tiempoMax<-tiempoMax*60
  puntMin<-maxPuntuaciones[maxPuntuaciones$Carrera==csvName,]$PuntuacionMin
  
  maxPuntuaciones<-data.frame(maxPuntuaciones[,c(3)],maxPuntuaciones[,csvName])
  
  colnames(maxPuntuaciones)<-c('categorias','puntuaciones')
  
  #Se define el dataFrame 'resultados' y se ordena por categorías (1º) y tiempos (2º)
  resultados = data.frame(currentCsv$Nombre, currentCsv$Apellidos, currentCsv$Región, currentCsv$Tiempo,currentCsv$Corto,  puntuacion=c(rep(0,length(currentCsv$Tiempo))), currentCsv$nc)
  resultados$currentCsv.Nombre<- as.character(resultados$currentCsv.Nombre)
  resultados$currentCsv.Apellidos<- as.character(resultados$currentCsv.Apellidos)
  resultados<-resultados[order(resultados$currentCsv.Corto,resultados$currentCsv.Tiempo),]
  
  #Iterar para cada categoría (niveles del factor maxPuntuaciones$categorias)
  for(i in levels(maxPuntuaciones$categorias)){
    
    #Data frame auxiliar que contiene las entradas de la categoría actual.
    aux<-subset(resultados,resultados$currentCsv.Corto==i)
    if(length(aux$currentCsv.Nombre)>0){
      a<-(maxPuntuaciones$categorias[]==i)
      #Puntuación  de ganador (aux$puntuacion[k] donde k es el índice del primer corredor que compite)
      for(k in 1:length(aux$currentCsv.Nombre)){
        if(!aux$currentCsv.nc[k]=='X'){
          aux$puntuacion[k]<-subset(maxPuntuaciones$puntuaciones,a)
          tiempoGanador<-getTimeinSecs(aux$currentCsv.Tiempo[k])
          if(tiempoGanador>tiempoMax){
            aux$puntuacion[k]<-puntMin
          }
          break
        }
        else{
          aux$puntuacion[k]<-0
        }
      }
      #Tiempo y puntuación del resto
      #Chequear que haya al menos un corredor por debajo del ganador (que es el que tiene índice k)
      if(k<length(aux$puntuacion)){
        
        for(j in (k+1):length(aux$puntuacion)){
          if(aux$currentCsv.nc[j]=='X'){
          aux$puntuacion[j]<-0  
          }else{
            tiempoCorredor<-getTimeinSecs(aux$currentCsv.Tiempo[j])
            if(!is.na((tiempoCorredor))){
              puntuacionProvisional<-(tiempoGanador/tiempoCorredor)*aux$puntuacion[k]
              #Hay que garantizar un mínimo de 10 puntos para todo aquel que participa.
              ifelse((10<puntuacionProvisional),aux$puntuacion[j]<-puntuacionProvisional,aux$puntuacion[j]<-10)
              if(tiempoCorredor>tiempoMax){aux$puntuacion[j]<-10}
              #Si la categoría no es competitiva (máxima puntuación de 0). Se le quitan los diez puntos dados en la línea anterior.
              if(aux$puntuacion[k]==0){aux$puntuacion[j]<-0}
              #Si supero el tiempo  máximo se le asigna la puntuación mínima solo.
            } 
              #Si el corredor no compitió (tiempo NA) se le asignan 0 puntos
              else{
              aux$puntuacion[j]<-0
            }
           
          }
        }
      }
      resultados$puntuacion[resultados$currentCsv.Corto==i]<-aux$puntuacion
      
    }
   
  }
  
  resultados$currentCsv.Tiempo<-format(resultados$currentCsv.Tiempo, format='%H:%M:%S')
  resultados<-resultados[,c(1,2,3,4,5,6)]
  return(resultados)
  
}
#getResults()

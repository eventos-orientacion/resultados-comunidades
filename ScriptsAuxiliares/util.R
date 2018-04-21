
#Función auxiliar setDate que recive un array de tiempos como caracteres y lo devuelve como tiempos %H:%M:%S
setDate <- function(a){
  #Caso especial. si el tiempo de carrera es de 24 min '24:00:00' R lo marca como incorrectamente como 00:00:00. Hay que editarlo manualmente. Para tiempos superiores e inferiores no
  #hay problema
  
  logic<-a[]=='24:00:00'
  a[logic]='24:00'
  
  aux<- strftime(as.POSIXct(a[], format = "%H:%M:%S"),format="%H:%M:%S")
  for(i in 1:length(a)){
    aux[i]<-if(is.na(aux[i])) strftime(as.POSIXct(a[i], format = "%M:%S"),format="%H:%M:%S") else aux[i]
  }
  aux<- as.character(aux)
  aux<-as.POSIXct(aux,format="%T")
  a<-aux
}

#Función auxiliar getTimeinSecs que te recibe una fecha y devuelve el número de segundos de %H:%M:%S
getTimeinSecs <-function(a){
  horas<-as.integer(format(as.POSIXct(a),"%H"))
  minutos<-as.integer(format(as.POSIXct(a),"%M"))
  segundos<-as.integer(format(as.POSIXct(a),"%S"))
  return(segundos+minutos*60+horas*3600)  
}


getStarTime <-function(tiempo){
  tiempo<-tiempo[order(tiempo)]
  return(tiempo[1])
  
}
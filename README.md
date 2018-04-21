# Resultados por comunidades
Calculo de resultados por comunidades usando R.
Diseñado para la realización de clasificaciones por comunidades autónomas en campeonatos de españa de orientación, siguiendo la normativa FEDO.



## Archivos en el paquete
### Ejecutables principales de R
Estos son los ejecutables principales (tambien llamados scripts):
 - PuntuacionFinalComunidades.R (ejecutable principal)
 - Puntuacion_larga.R
 - Puntuacion_media.R
 - Puntuacion_sprint.R
 - PuntuacionRelevos.R
### Archivo de configuración
El archivo de configuracion se llama `csv/info.csv`. En este archivo se pueden configurar las categorías, grupos de edad, puntuaciones, etc. que serán tenidas en cuenta a la hora de calcular la clasificación por comunidades.

Los nombre en la columna `CECLevels` deben coincidir con los de la columna `Categoría`

Todos los campos en blanco en la imagen a continuación son editables.

Los campos en amarillo deben coincidir exactamente con los nombres de la columna `Corto` de los csv exportados.

El campo verde debe coincidir exactamente con los nombres del archivo csv correspondiente.

![alt text](https://github.com/eventos-orientacion/resultados-comunidades/blob/master/img/info.png "info.csv")
 
 
## Instrucciones
Es necesario ejecutar los scripts con R. Visita [https://cran.r-project.org](https://cran.r-project.org) para instalar el último paquete.

### Windows
Si es instalado en windows con las opciones por defecto, el directorio de trabajo de R será la carpeta `Mis Documentos`.
Puedes crear una nueva carpeta en `Mis Documentos` (o en el directorio de trabajo por defecto) con el nombre `RFolder`.
Pon en `RFolder` el contenido del repositorio. Si esto se realiza correctamente, los ejecutables principales estarán directamente sobre `RFolder` de forma que exista el archivo en este directorio `Mis Documentos\RFolder\PuntuacionFinalComunidades.R`. También existirán las carpetas `Mis Documentos\RFolder\csv` y `Mis Documentos\RFolder\ScriptsAuxiliares`
Para ejecutar scrips abrelos con R y ejecutalos pulsando el botón `source` o pulsando simultáneamente `CTRL+SHIFT+ENTER`

### Linux/Unix
Para ejecutar los scripts en Linux/Unix, clona el repositorio y accede a la carpeta donde están localizados los ejecutables principales. Desde esta carpeta ejecuta el comando `Rscript` con el nombre del ejecutable. E.g. `Rscript PuntuacionFinalComunidades.R`

### Exportar desde sportsoftware
Exporta los resultados desde OE2010 y OS2010: `Results/Preliminary/Courses/Export`.
Selecciona las opciones por defecto (csv; delimitador punto y coma (`;`); y delimitador de texto comillas dobles (`"`) ). Si el evento tiene más de una etapa, exporta una única etapa.
Los archivos exportados se deben almacenar en la carpeta csv.
Es importante que la columna `Región` contiene el nombre de las comunidades autónomas.
Es importante comprobar que los nombres de las columnas coinciden con los archivos de ejemplo en la carpeta `csv`.



	
## Explicación de los archivos ejecutables
### PUNTUACION_LARGA
Puntuacion_larga.csv calculates the score for the runners on a single race 'larga' according to the rules on info.csv

larga.csv is the Preliminary Results by courses export from OE2010. It should be exported once the event is finished.
info.csv contains the information for processing the data on larga.csv:


The winner score for each category (column ‘Individual’) is taken from the ‘larga.csv’ column. For instance for F-21A winner would be 100,  for F21B, 60.

The Score for the rest of the runners (no winners) is calculated as follows 
(winner time/runner time)*winner score

If you want to edit this formula open with a text editor the auxiliary script ‘getResults.R’ search the following line and edit it:

   `puntuacionProvisional<-(tiempoGanador/tiempoCorredor)*aux$puntuacion[k]`

Where:

- tiempoGanador is the winners time
- tiempoCorredor is the runners time whose socore is being calculated
- aux$puntuacion[k] is the winners time

‘PuntuacionMin’ (10 points) is granted for every runner that completed the race

If Runner time is > Max race time (Column ‘TiempoMax’), then PuntuacionMin is assigned to the runner

If runner is marked as ‘non competitive’ 0 points are assigned to him/her.

### PUNTUACION_MEDIA.R
Exactly like ‘Puntuacion_larga.R’ but it loads media.csv instead of larga.csv and these columns of info.csv are used:

### PUNTUACION_SPRINT.R 
Same as above but it loads sprint.csv instead and these fields from info.csv are used:

### PUNTUACION_RELEVOS.R
Same as above but:

It loads relevos.csv that is the csv exportation of Preliminary Results by courses on OS2010.

It loads relevos.csv instead and these fields from are used:

Scores are applied to teams, not to individual runners.

If you want to edit the formula that is used for calculating the teams scores open with a text editor and edit the following line:

`aux$Puntuacion[j]<-(tiempoGanador/tiempoCorredor)*aux$Puntuacion[z]`

Where:
- tiempoGanador is the winners team time
- tiempoCorredor is the team time whose score is being calculated
- aux$puntuacion[k] is the winners team score



### PUNTUACIÓNFINALCOMUNIDADES.R


For each individual race (larga.csv, media.csv and sprint.csv:

It groups the runners by ages. For instance as seen in the image F-12, F-14 and F-16 will be all ‘Cadete’.

It groups the runners by the ‘Region’ field of the corresponding csv (larga, media or sprint)

Is sums the best three cadete times, the best three junior, four veteran, and seven senior for each ‘Region’. This can be edited on the fields beneath the columns (CECLevels and CECcorredores) on the info.csv. This leaves one final score for the ‘Region’ for the race.

For the relevos race (relevos.csv)

- It groups the runners by the ‘Region’ field of relevos.csv.
- It sums the best five scores for each region. It does not look at the category. This leaves one final score by ‘Region’ for the relevos race
	
Finally

- It sums the ‘Region score by race’ calculated as explained above on a single final score for each region.

	

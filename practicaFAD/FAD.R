
#librerias
#install.packages("expss")
#install.packages("egg")
#install.packages("GGally")
#install.packages("ISLR")
#install.packages("car")
#install.packages("DMwR2")
#install.packages("faraway")
#install.packages("mlbench")
#install.packages("kableExtra")
#install.packages("bsplus")
#install.packages("VIM")
#install.packages("mice")
#install.packages("lattice")
#install.packages("rbind")
#install.packages("GUI")
#install.packages("expss")
#install.packages("dplyr")
#install.packages("gridExtra")
#install.packages("carData")
#install.packages("sos")
#install.packages("brew")
#install.packages("dplyr")
#install.packages("magrittr") 
#install.packages("caret")

library(magrittr)
library(brew)
library(gridExtra)
library(lattice)
library(mice)
library(VIM)
library(expss)
library(dplyr)
library(tidyr)
library(ggplot2)
library(egg)
library(GGally)
library(DMwR2)
library(ISLR)
library(car)
library(DMwR2)
library(faraway)
library(mlbench)
library(knitr)
library(kableExtra)
library(htmltools)
library(bsplus)
library(RColorBrewer)
library(carData)
library(dplyr)
library(tidyr)
library(ggplot2)
library(egg)
library(GGally)
library(sos)
library(ISLR)
library(car)
library(DMwR2)
library(faraway)
library(mlbench)
library(knitr)
library(kableExtra)
library(htmltools)
library(bsplus)
library(RColorBrewer)
library(sos)
library(readr)
library(Hmisc)
library(caret)
library(dplyr)
library(gclus)
library(Amelia)
library(lubridate)
library(forcats)

#################################################
####LECTURA DE LOS DATOS CON VARIABLES MISSING###
#################################################


#SEMMA
#SEMMA 1. SAMPLE

#TRAIN 70% / CONTROL 20% / TEST 10%

datos_miss <-read.csv2 (file="C:/Users/Pablo/Desktop/FAD_Práctica/kc_house_data_missing.csv",
                        header=TRUE, na = c("", "NA"), )
summary (datos_miss)

set.seed(737)
inTraining     <- createDataPartition(pull(datos_miss), p = .7, list = FALSE, times = 1)
price_training <- slice(datos_miss, inTraining)
aux            <- slice(datos_miss, -inTraining)
intest         <- createDataPartition(pull(aux),
                                      p = 2/3, list = FALSE, times = 1)

price_control  <- slice(aux, intest)
price_testing  <- slice(aux, -intest)

#price_training 15.119 obs
#price_control  4.319  obs
#price_testing  2.159  obs

#guardamos los datos despues del proceso de impudato###
write.csv(price_testing, file="C:/Users/Pablo/Desktop/FAD_Práctica/kc_house_price_testing.csv")

###############################################
#SEMMA 2. ANALISIS EXPLORATORIO DE LOS DATOS ##
###############################################

#price_training

##3 Análisis exploratorio de datos faltantes: VIM##
aggr_plot <- aggr(price_training, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE,
                  labels=names(price_training), cex.axis=.7, gap=1, 
                  ylab=c("Histogram of missing data","Pattern"))


# Visualización de valores faltantes

price_training %>% select(sqft_lot, condition) %>% marginplot()
#vemos que los valores missing de Bedrooms suele darse en valores de sqft_lot bajos.
#sobre todo en los primeros niveles. Imputación a través del algoritmo KNN de VIM

price_training %>% select(sqft_lot, bedrooms) %>% VIM::kNN() %>% marginplot(., delimiter="_imp")
#parece que no se aparta demasiado por lo que la imputación es buena 

#Variables Missing son en todos lod casos inferior al 3% 
#bedrooms        41
#bathrooms       28
#sqft_living     28 
#sqft_lot        41
#floors          16 
#waterfront      27 
#view             8
#condition        8
#grade           17
#sqft_above      27 
#sqft_basement   31
#yr_built        10 
#yr_renovated     9
#lat              1


#ALTERNATIVA1 Impute (fill in) the missing data

vec_miss <- price_training


##Para las variables continuas podríamos hacer una imputacion a la media##

#sqft_living
price_training$sqft_living[is.na(price_training$sqft_living)] <- 
                    mean(price_training$sqft_living, na.rm = TRUE)

#sqft_lot
price_training$sqft_lot[is.na(price_training$sqft_lot)] <- 
  mean(price_training$sqft_lot, na.rm = TRUE)


#sqft_above
price_training$sqft_above[is.na(price_training$sqft_above)] <- 
  mean(price_training$sqft_above, na.rm = TRUE)


#sqft_basement
price_training$sqft_basement[is.na(price_training$sqft_basement)] <- 
  mean(price_training$sqft_basement, na.rm = TRUE)



#variable discreta 
# Create the function calculate the mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}
mode_bedrooms   <- getmode(price_training$bedrooms)
mode_bathrooms  <- getmode(price_training$bathrooms)
mode_floors     <- getmode(price_training$floors)
mode_waterfront <- getmode(price_training$waterfront )
mode_view       <- getmode(price_training$view )
mode_condition  <- getmode(price_training$condition )
mode_grade      <- getmode(price_training$grade )
mode_yr_built   <- getmode(price_training$yr_built )
mode_yr_renovated     <- getmode(price_training$yr_renovated )


#bedrooms
price_training$bedrooms[is.na(price_training$bedrooms)] <- 
  (mode_bedrooms)

#bathrooms
price_training$bathrooms[is.na(price_training$bathrooms)] <- 
  (mode_bathrooms)

#floors
price_training$floors[is.na(price_training$floors)] <- 
  (mode_floors)

#waterfront
price_training$waterfront[is.na(price_training$waterfront)] <- 
  (mode_waterfront)

#view
price_training$view[is.na(price_training$view)] <- 
  (mode_view)

#condition
price_training$condition[is.na(price_training$condition)] <- 
  (mode_condition)

#grade
price_training$grade[is.na(price_training$grade)] <- 
  (mode_grade)

#yr_built
price_training$yr_built[is.na(price_training$yr_built)] <- 
  (mode_yr_built)

#yr_renovated
price_training$yr_renovated[is.na(price_training$yr_renovated)] <- 
  (mode_yr_renovated)


#chequeamos que no hay variables missing
summary (price_training)



## ALTERNATIVA 2. ESUDIO DE LOS MISSING A TRAVES DE FUNCION MICE 
#Usaríamos  MICE  en el caso de querer imputación múltiple
#asume que los datos faltantes son debidos al azar MAR, lo que implica que la ausencia de 
#un valor puede predecirse a partir de otros 

#1.-seleccion de las variables PMM (Predictive Mean Matching)  - For numeric variables

summary(vec_miss)
continuas<- mice(vec_miss [c(6,7,13,14)], m=5, method = 'pmm', seed = 737)
summary(continuas)

continuas$imp$sqft_living
continuas$imp$sqft_lot 
continuas$imp$sqft_above 
continuas$imp$sqft_basement 



#polyreg(Bayesian polytomous regression) - For Factor Variables (>= 2 levels)
#Proportional odds model (ordered, >= 2 levels)

vec_miss$bedrooms<-as.character(vec_miss$bedrooms)
vec_miss$bathrooms<-as.character(vec_miss$bathrooms)
vec_miss$floors<-as.character(vec_miss$floors)
vec_miss$waterfront<-as.character(vec_miss$waterfront)
vec_miss$view<-as.character(vec_miss$view)
vec_miss$condition<-as.character(vec_miss$condition)
vec_miss$grade<-as.character(vec_miss$grade)




summary(vec_miss)
discreta <- mice(vec_miss [c(4,5,8,9,10,11,12)], m=5, method = 'polyreg', seed = 737)

discreta$imp$bedrooms
discreta$imp$bathrooms
discreta$imp$floors
discreta$imp$waterfront  
discreta$imp$view  
discreta$imp$condition  
discreta$imp$grade
discreta$imp$yr_built  
discreta$imp$yr_renovated  

#nos quedamos con el primer método por sencillez, pero tenemos las bases deL Mice

dat2<-mice::complete(discreta, 2)
dat1<-mice::complete(continuas,2)
dat <-vec_miss [c(1,2,3)]

###unimos los 3 datasets , nos quedamos con el primer metodo







#######################
#SEMMA 2. EXPLORE
#######################



#ANALISIS 
#VISUALIZACIÓN DE LOS DATOS
#OUTLIER

#variables continuas 



#variables discretas

########################################################################
# condition#####################################################
########################################################################


ggplot(price_training, aes(price_training$condition)) + geom_bar() + ggtitle("Condition")
#problemas con los grupos con pocas frecuencias a considerar

price_training$condition<-as.character(price_training$condition)
price_training$price<-as.numeric(price_training$price)
aggregate(price_training$price, by=list(price_training$condition), FUN=mean)  


price_training$condition_new<-recode (price_training$condition,
                                      "c('1','2')='low'; 
                                       c('3','4')='med'; 
                                       c('5')    ='hig'"
                                      )
ggplot(price_training, aes(price_training$condition_new)) + geom_bar() + ggtitle("Condition new")

#hemos recodificado esta variable en tres grupos alrededor de la media en relacion a su precio medio
#veamos esta relacion antes y depues de la transformación


price_training %>%
  group_by(condition) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=condition, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Condicion")

#nos llama la atencion el grupo 1 y 2 precios en medio mucho menor que los otros 3 grupos
#si aplicamos la transformacion


price_training %>%
  group_by(condition_new) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=condition_new, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Condicion New")


ggplot(data = price_training, aes(x = condition_new, y = price, color = condition_new)) +
  geom_boxplot() +
  theme_bw()

#podemos afirmar a priori y visualmente que existe una relación entre el precio y la 
#condicion de la vivienda que se refleja claramente en el grupo LOW




###################################################
###bedrooms#######################################
##################################################

ggplot(price_training, aes(price_training$bedrooms))  + geom_bar() + ggtitle("bedRooms")
#es una variable ordinal

price_training %>%
  group_by(bedrooms) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=bedrooms, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio medio por Habitaciones")
#interesante por el precio es creciente en relacion a numero de
#habitaciones pero a partir de 7 habitaciones el precio empieza a reducirse


boxplot(price ~ bedrooms, data = price_training, col = "lightgreen", 
        xlab = "numero de camas", ylab = "precio vivienda") 

t_beds<-table(price_training$bedrooms)
t_beds
aggregate(price_training$price, by=list(price_training$bedrooms), FUN=mean) 

# nuestra decision y considerando los valores medios agrupar a partir de 6 camas en 
# una unica categoria obteniendo la variable bed_new

price_training$bedrooms_new<-recode (price_training$bedrooms,"6:11=6")
table(price_training$bedrooms_new)
aggregate(price_training$price, by=list(price_training$bedrooms_new), FUN=mean) 

boxplot(price ~ bedrooms_new, data = price_training, col = "lightgreen", 
        xlab = "numero de camas new", ylab = "precio vivienda")



###################################################################################
#bathrooms #######################################################################
###################################################################################

ggplot(price_training, aes(price_training$bathrooms)) + geom_bar() + ggtitle("bathrooms")
#es una variable ordinal
aggregate(price_training$price, by=list(price_training$bathrooms), FUN=mean) 


price_training %>%
  group_by(bathrooms) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=bathrooms, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Banyos")

table(price_training$bathrooms)
#la distribución a partir de 4 es muy pequeña. Poco estable para inferir
#proponemos la recodificación a partir de este valor

price_training$bathrooms_new<-recode (price_training$bathrooms,"4:8=4")
table(price_training$bathrooms_new)


price_training %>%
  group_by(bathrooms_new) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=bathrooms_new, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Banyos new")

boxplot(price ~ bathrooms_new, data = price_training, col = "red", 
        xlab = "numero de banyos new", ylab = "precio vivienda")



#############################################################################
#floors#####################################################################
#############################################################################

ggplot(price_training, aes(price_training$floors))    + geom_bar() + ggtitle("floors")


price_training %>%
  group_by(floors) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=floors, y=avg_price)) + geom_bar(stat = "identity")  +
  ggtitle("Precio Medio por Plantas")

#es una variable bastante estable en relación al precio.
table(price_training$floors)
aggregate(price_training$price, by=list(price_training$floors), FUN=mean) 

#nuestra propuesta es recodifcar 2.5 en 2 y 3.5 en 3 
price_training$floors_new<-recode (price_training$floors,"2.5=2; 3.5=3")
table(price_training$floors_new)
aggregate(price_training$price, by=list(price_training$floors_new), FUN=mean) 

boxplot(price ~ floors_new, data = price_training, col = "blue", 
        xlab = "numero de floors new", ylab = "precio vivienda")




############################################################################
#waterfront ################################################################
############################################################################


ggplot(price_training, aes(price_training$waterfront))    + geom_bar() + ggtitle("waterfront")
#recode data nominal vistas versus no vistas #
price_training$waterfront[which(price_training$waterfront == 0)] <- "WF_NO"
price_training$waterfront[which(price_training$waterfront == 1)] <- "WF_SI"
ggplot(price_training, aes(price_training$waterfront))    + geom_bar() + ggtitle("waterfront")


table(price_training$waterfront)
aggregate(price_training$price, by=list(price_training$waterfront), FUN=mean) 



price_training %>%
  group_by(waterfront) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=waterfront, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Vista al Mar")

##esto a entender. frente al mar el precio es en media más barato?¿




#############################################################################
#view  ######################################################################
#############################################################################


ggplot(price_training, aes(price_training$view))     + geom_bar() + ggtitle("view")
#VARIABLE ORDINAL CON ESCASA FRECUENCIA DISTINTA DE CERO
#interesante crear una nueva variable flag Visitas si versus visitas NO
price_training$view_flag<-ifelse(price_training$view> 0,
                                  "VS_SI", "VS_NO")

#view_flag#nos podemos plantear un flag Visitada vs no vistada 
ggplot(price_training, aes(price_training$view_flag))     + geom_bar() + ggtitle("view_flag")



price_training %>%
  group_by(view) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=view, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Numero de Visitas")


price_training %>%
  group_by(view_flag) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=view_flag, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Numero de Visitas flag")

#no parece que view flag sea una variable interesante a tratar porque está recogiendo 
# distintas variabilidades de los estados 1-4 de view que difieren entre ellos en media
#no es interesante agruparla . La descartamos.




################################################################################
#analisis de grade
################################################################################

ggplot(price_training, aes(price_training$grade))    + geom_bar() + ggtitle("grade")
#en este punto interesa crear una agrupación en función del precio que será nuestra variable objetivo
price_training$grade<-as.character(price_training$grade)

table(price_training$grade)
aggregate(price_training$price, by=list(price_training$grade), FUN=mean)                         


#parecen que se deberian formar los siguientes grupos (9,8) (7,13,10,s) (11,12,4,5,6) en funcion al 
#precio medio de estas viviendas 


price_training$grade_new<-recode (price_training$grade,
                                      "c('9','8')='Grade_top'; 
                                       c('7','13','10','s')='Grade_med'; 
                                       c('11','12','4','5','6')    ='Grade_low'"
)

table(price_training$grade_new)
aggregate(price_training$price, by=list(price_training$grade_new), FUN=mean)  


price_training %>%
  group_by(grade) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=grade, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Grado")

price_training %>%
  group_by(grade_new) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=grade_new, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Grado new")




############################################################################
##### analisis de la estacionalidad de la compra en funcion de los meses ###
############################################################################

#extraemos en mes por si existe una estcionalidad en la compra

price_training$mes<-month(as.POSIXlt(price_training$date, format="%m/%d/%Y"))
table(price_training$mes)
aggregate(price_training$price, by=list(price_training$mes), FUN=mean)  


price_training %>%
  group_by(mes) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=mes, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por mes")



################################################################################
### anyo de construccion 
###############################################################################


table(price_training$yr_built)
aggregate(price_training$price, by=list(price_training$yr_built), FUN=mean)  


price_training %>%
  group_by(yr_built) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=yr_built, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Anyo Construccion")

#muy interesante esta variables vamos trabajar distintos Variaciones de la misma

# Partimos de la Hipotesis de que es existe una diferencia entre las viviendas antes 
# y despues del anyo 2000

price_training$flag_milenio<-recode (price_training$yr_built,
                                     "1900:1999=0; 2000:2020=1")


table(price_training$flag_milenio)
aggregate(price_training$price, by=list(price_training$flag_milenio), FUN=mean)  
price_training %>%
  group_by(flag_milenio) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=flag_milenio, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Milenio")
#Parece a priori que existe una diferencia significativa entre la construccíon 
# durante un milenio y otro. Comprobaremos nuestra Hipótesis con un test
# Suponiendo normalidad TCL
# t test 
# Ho : No existen diferencias significativas de precio entre las categorias Milenio 1900 y 2000 

m1<-subset(price_training, flag_milenio=="1")
m0<-subset(price_training, flag_milenio=="0")

set.seed(737)
test <- t.test(m0$price,m1$price) # Prueba t de Student
print(test)
#rechazamos la Ho , existen diferencias sginifcativas entre ambos milenios para la variable precio
boxplot(m0$price,m1$price,names=c("m_1900","m_2000"))



#################################################
#####analisis por decadas en ambas siglos#######
#################################################

table(m1$yr_built)
aggregate(m1$price, by=list(m1$yr_built), FUN=mean)  
m1 %>%
  group_by(yr_built) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=yr_built, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por decada ")

table(m0$yr_built)
aggregate(m0$price, by=list(m0$yr_built), FUN=mean)  
m0 %>%
  group_by(yr_built) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=yr_built, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por decada ")

# analizando ambas poblaciones de siglos parece que existen diferencias en el siglo 20
# por lo que nos detendremos a realizar un analisis detallado

table(m0$yr_built)
aggregate(m0$price, by=list(m0$yr_built), FUN=mean)  

# analizando la distribución parece que las casa construidas hasta el anyo 1932 tiene
#mucho más valor de mercado hasta el anyo 1975 que sufren otra subida
#proponemos el siguiente Banding

price_training$decada<-recode (price_training$yr_built,
                                     "1900:1932=0; 
                                      1933:1975=1;
                                      1975:1999=2;
                                      2000:2020=3")

table(price_training$decada)
aggregate(price_training$price, by=list(price_training$decada), FUN=mean)  


price_training %>%
  group_by(decada) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=decada, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por periodo")


############################################################################
#####anyo de renovacion 
###########################################################################


table(price_training$yr_renovated)
aggregate(price_training$price, by=list(price_training$yr_renovated), FUN=mean) 

# creamos un flag si /no por si ha reformado o no
price_training$yr_renovated<-as.numeric(price_training$yr_renovated)
price_training$flag_reforma<-recode (price_training$yr_renovated,
                                     "0=0; 1940:2020=1")
                                   
                                    

table(price_training$flag_reforma)
aggregate(price_training$price, by=list(price_training$flag_reforma), FUN=mean) 

####parece que existe diferencias entre el precio en funcion de si ha sido reformado
# o no pero no lo podemos afirmar con total seguridad , vamos a realizar un contraste
# de Hipotesis para analizar el flag 

# Suponiendo normalidad TCL
# t test 
# Ho : No existen diferencias significativas de precio entre las categorias reforma si/no 

f1<-subset(price_training, flag_reforma=="1")
f0<-subset(price_training, flag_reforma=="0")

set.seed(737)
test <- t.test(f0$price,f1$price) # Prueba t de Student
print(test)

# No podemos rechazar  la Ho , 
# a priori en en función a nuestros datos NO existen diferencias sginifcativas
# entre las viviendas reformadas y no reformadas
#vamos a intruducirla en el modelo pero no parece que vaya a ser un factor importante


price_training %>%
  group_by(flag_reforma) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=flag_reforma, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por  Reforma")


##################################################################
####creamos la variable antiguedad de la vivienda 
#### a partir de la fecha de compra date y el anyo de construccion
#################################################################

#tiempo desde la construccion  hasta la venta

tabla.frec  <- table(price_training$yr_built)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 

tabla.frec  <- table(price_training$date)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
#tienen distinto formato por lo que nos quedamos con el año

date1 <-  as.Date(price_training$date,'%m/%d/%Y')
year1 <- as.numeric(format(date1,'%Y'))
tabla.frec  <- table(year1)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 

price_training$antiguedad<-(year1-price_training$yr_built)
tabla.frec  <- table(price_training$antiguedad)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(price_training$antiguedad, xlab="antiguedad",ylab="frecuencia",
     main="histograma distribucion de la antiguedad", col="blue")

price_training %>%
  group_by(antiguedad) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=antiguedad, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por antiguedad")


###vemos que en el analisis de correlaciones esta va tener mucha relacion con otras
# de estacionalidad d¡cque hemos trabajado con la de decada. Se denota en el grafico
# que existe una poblacion de viviendas de una antiguedad importante que sn 
#siginificativamente mas cara en precio,



#parece a primera vista que no existe mucha relacion entre a antiguedad de la vivienda
# con el precio de la vivienda



#flag reforma si/no

tabla.frec  <- table(price_training$yr_renovated)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 


flag_reforma<-recode(price_training$yr_renovated,"1:hi=1 ;lo:0=0 ")
tabla.frec  <- table(flag_reforma)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(flag_reforma, xlab="flag_reforma",ylab="frecuencia",main="histograma flag_reforma", col="blue")






######################
#variables trassformacion de las variables ##
######################

#recode data nominal #


"

histogram(datos_miss$grade)
datos_miss$grade<-recode(datos_miss$grade, "0:6=1; 7=2; 8=3; 9=4; else=5")
histogram(datos_miss$grade)




ggplot(price_training, aes(x = price_training$sqft_living)) +
  geom_density() +
  ggtitle('Density sqft Casa')


ggplot(price_training, aes(x = price_training$sqft_above)) +
  geom_density() +
  ggtitle('Density sqft above')


ggplot(price_training, aes(x = price_training$sqft_lot)) +
  geom_density() +
  ggtitle('Density sqft terreno')


ggplot(price_training, aes(x = price_training$sqft_living15)) +
  geom_density() +
  ggtitle('Density sqft casa 15')


ggplot(price_training, aes(x = price_training$sqft_lot15)) +
  geom_density() +
  ggtitle('Density sqft terrero 15')





plot(price_training$sqft_living, price_training$price, main="Scatterplot Example",
     xlab="price ", ylab="sqft_living ", pch=100)

library(car)
scatterplot(price_training$sqft_living ~ price_training$price | price_training$bathrooms, data=price_training,
            xlab="Metros", ylab="precio",
            main="Enhanced Scatter Plot")

library(cluster)
library(gclus)

head(price_training)


####relacion entre las variables metros cuadrados
dta <- price_training[c(7,8,14,15,21,22)] # get data
dta.r <- abs(cor(dta)) # get correlations
dta.col <- dmat.color(dta.r) # get colors
# reorder variables so those with highest correlation
# are closest to the diagonal
dta.o <- order.single(dta.r)
cpairs(dta, dta.o, panel.colors=dta.col, gap=.5,
       main="Variables Ordered and Colored by Correlation" )

#analisis de correlaciones de las variables metros 
###analisis de las correlaciones###

# Correlation plot
ggcorr(dta, palette = "RdBu", label = TRUE)

# Correlation plot all variables
ggcorr(price_training, palette = "RdBu", label = TRUE)
#tenemos que borrar Bedrooms y bathrooms


glimpse(price_training)





#ANALISIS EXLORATORIO DE LOS DATOS


####Transformaciones para igualar dispersión#####
#podemos ver que sus valores para t odos los grupos están muy sesgados. 
#Sería conveniente transformarla para que la distribución de valores 
#fuese más homogénea.
#Este resultado se consigue aplicando una transformación logarítmica.


p1 <- price_training %>% select(condition, price) %>%
  na.omit() %>%
  ggplot(aes(x=price, colour=condition)) +
  geom_density()

p2 <- price_training %>% mutate(log10_price = log10(price)) %>%
  select(condition, log10_price) %>%
  na.omit() %>%
  ggplot(aes(x=log10_price, colour=condition)) +
  geom_density()

grid.arrange(p1, p2, nrow = 1)



##GRAFICO CON LA TRANFORMACION LOG10

########################################################
###analisis de las variables discretas y  ordinales#####
########################################################

####to do 

#analisis de las zonas codigo postal

tabla.frec  <- table(datos_root$zipcode)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 



########################################################
###analisis de las variables continuas             #####
########################################################

#trasnformacion para precio

price1 <- price_training %>% select(condition, price) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=price, fill=condition)) +
  geom_boxplot()
  

price2 <- price_training %>% mutate(log10_price = log10(price)) %>%
  select(condition, log10_price) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=log10_price, fill=condition)) +
  geom_boxplot()
  

p1 <- price_training %>% select(condition, price) %>%
  na.omit() %>%
  ggplot(aes(x=price, colour=condition)) +
  geom_density()

p2 <- price_training %>% mutate(log10_price = log10(price)) %>%
  select(condition, log10_price) %>%
  na.omit() %>%
  ggplot(aes(x=log10_price, colour=condition)) +
  geom_density()

grid.arrange(p1, p2, nrow = 1)
grid.arrange(price1, price2, nrow = 1)


#transformacion sqft_living

sqft_liv1 <- price_training %>% select(condition, sqft_living) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=sqft_living, fill=condition)) +
  geom_boxplot()

sqft_liv2 <- price_training %>% mutate(log10_sqft_living = log10(sqft_living)) %>%
  select(condition, log10_sqft_living) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=log10_sqft_living, fill=condition)) +
  geom_boxplot()



sq1 <- price_training %>% select(condition, sqft_living) %>%
  na.omit() %>%
  ggplot(aes(x=sqft_living, colour=condition)) +
  geom_density()

sq2 <- price_training %>% mutate(log10_sqft_living = log10(sqft_living)) %>%
  select(condition, log10_sqft_living) %>%
  na.omit() %>%
  ggplot(aes(x=log10_sqft_living, colour=condition)) +
  geom_density()

grid.arrange(sq1, sq2, nrow = 1)
grid.arrange(sqft_liv1, sqft_liv2, nrow = 1)



#transformacion sqft_lot

sqft_lot1<- price_training %>% select(condition, sqft_lot) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=sqft_lot, fill=condition)) +
  geom_boxplot()

sqft_lot2 <- price_training %>% mutate(log10_sqft_lot = log10(sqft_lot)) %>%
  select(condition, log10_sqft_lot) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=log10_sqft_lot, fill=condition)) +
  geom_boxplot()

sql1 <- price_training %>% select(condition, sqft_lot) %>%
  na.omit() %>%
  ggplot(aes(x=sqft_lot, colour=condition)) +
  geom_density()

sql2 <- price_training %>% mutate(log10_sqft_lot = log10(sqft_lot)) %>%
  select(condition, log10_sqft_lot) %>%
  na.omit() %>%
  ggplot(aes(x=log10_sqft_lot, colour=condition)) +
  geom_density()

grid.arrange(sql1, sql2, nrow = 1)
grid.arrange(sqft_lot1, sqft_lot2, nrow = 1)

#transformacion sqft_above

sqft_above1<- datos_root %>% select(new, sqft_above) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=sqft_above, fill=new)) +
  geom_boxplot()


sqft_above2 <- datos_root %>% mutate(log10_sqft_above= log10(sqft_above)) %>%
  select(new, log10_sqft_above) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=log10_sqft_above, fill=new)) +
  geom_boxplot()


grid.arrange(sqft_above1, sqft_above2, nrow = 1)



#transformacion sqft_basement

sqft_basement1<- datos_root %>% select(new, sqft_basement) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=sqft_basement, fill=new)) +
  geom_boxplot()

sqft_basement2 <- datos_root %>% mutate(log10_sqft_basement= log10(sqft_basement)) %>%
  select(new, log10_sqft_basement) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=log10_sqft_basement, fill=new)) +
  geom_boxplot()

grid.arrange(sqft_basement1, sqft_basement2, nrow = 1)




#transformacion sqft_living15 


sqft_living15_1<- datos_root %>% select(new, sqft_living15) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=sqft_living15, fill=new)) +
  geom_boxplot()

sqft_living15_2 <- datos_root %>% mutate(log10_sqft_living15= log10(sqft_living15)) %>%
  select(new, log10_sqft_living15) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=log10_sqft_living15, fill=new)) +
  geom_boxplot()

grid.arrange(sqft_living15_1, sqft_living15_2, nrow = 1)


#transformacion sqft_lot15


sqft_lot15_1<- datos_root %>% select(new, sqft_lot15) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=sqft_lot15, fill=new)) +
  geom_boxplot()

sqft_lot15_2 <- datos_root %>% mutate(log10_sqft_lot15= log10(sqft_lot15)) %>%
  select(new, log10_sqft_lot15) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=log10_sqft_lot15, fill=new)) +
  geom_boxplot()

grid.arrange(sqft_lot15_1, sqft_lot15_2, nrow = 1)



###analisis de los precios por las categorias
library(dplyr)
datos_root$price %>%
  group_by(datos_root$condition) %>% 
  summarise(avg_price = mean(datos_root$price)) %>%
  ggplot(aes(x=datos_root$condition, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Salario promedio por categoría")



####analisis de los outliers#####




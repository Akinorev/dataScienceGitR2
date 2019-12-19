
#librerias

library(PerformanceAnalytics)
library(GoodmanKruskal)
library(rcompanion)
library (bestNormalize)
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
library(nortest)
library(MASS)
library(vcd)

#################################################
####LECTURA DE LOS DATOS CON VARIABLES MISSING###
#################################################


#SEMMA
#SEMMA 1. SAMPLE

#TRAIN 70% / CONTROL 20% / TEST 10%

datos_miss <-read.csv2 (file="C:/Users/Pablo/Desktop/FAD_Pr?ctica/kc_house_data_missing3.csv",
                        header=TRUE, na = c("", "NA"), )
summary (datos_miss)
histogram(datos_miss$price)


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
write.csv(price_testing, file="C:/Users/Pablo/Desktop/FAD_Pr?ctica/kc_house_price_testing.csv")

###############################################
#SEMMA 2. ANALISIS EXPLORATORIO DE LOS DATOS ##
###############################################

#price_training

##3 Análisis exploratorio de datos faltantes: VIM##
aggr_plot <- aggr(price_training, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE,
                  labels=names(price_training), cex.axis=.7, gap=1, 
                  ylab=c("Histogram of missing data","Pattern"))




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


##Para las variables continuas podr?amos hacer una imputacion a la media##

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
#Usar?amos  MICE  en el caso de querer imputaci?n m?ltiple
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

#nos quedamos con el primer m?todo por sencillez, pero tenemos las bases deL Mice

dat2<-mice::complete(discreta, 2)
dat1<-mice::complete(continuas,2)
dat <-vec_miss [c(1,2,3)]

###unimos los 3 datasets , nos quedamos con el primer metodo







#######################
#SEMMA 2. EXPLORE
#######################

#Hipotesis. Realizaremos un modelo lineal para estimar el precio de la vivienda en funci?n 
# de las variables independientes como beds, baths, etc

#principios Modelo lineal Multiple

#No colinialidad
#Parsimonia
#Relaci?n lineal entre los predictores num?ricos y la variable respuesta
#Distribuci?n normal de los residuos
#Variabilidad constante de los residuos


      




########################################################
#variables continuas ##################################
#######################################################

#################################
#trasnformacion para precio######
#################################



# Ver si cumple la hipotesis de Normalidad y si no es as? realizar la transformacion 
# test de kolmogorov 
# Ho: La muestra proviene de una distribuci?n normal.
# El nivel de significancia que se trabajar? es de 0.05. Alfa=0.05
# Criterio de Decisi?n
# Si P < Alfa Se rechaza Ho


norm_price_test<-lillie.test(price_training$price)
print (norm_price_test)


# Rechazamos Ho para nuestra muestra. Price No sigue una distribuci?n Normal

# posibles soluciones
# 1.-Transformacion logaritmico 10
# 2.-Raiz cuadrada
# 3.-Inversa 1/x

#Prueba 1 . Logaritmo
summary (price_training$price)
norm_price_test<-lillie.test(log10(price_training$price))
print (norm_price_test)
histogram((price_training$price))
# Rechazamos Ho para nuestra muestra.Log10 Price No sigue una distribuci?n Normal

qqnorm(1/(price_training$price))
qqline(1/(price_training$price))
#vemos que en los valores superiores no se ajusta del todo a una normal. pero nos apoyamos en TCL


#Prueba 2 . Raiz Cuadrada sqrt 
histogram(sqrt(price_training$price))
norm_price_test<-lillie.test(sqrt(price_training$price))
print (norm_price_test) 
# Rechazamos Ho para nuestra muestra. Raiz cuadrada de Price No sigue una distribuci?n Normal


#Prueba 3 . Inversa 1/x 
histogram(1/(price_training$price))
norm_price_test<-lillie.test(1/(price_training$price))
print (norm_price_test) 
# Rechazamos Ho para nuestra muestra. Inversa de  Price No sigue una distribuci?n Normal

#Prueba 4 . x al cuadrado
histogram((price_training$price*price_training$price))
x2<-(price_training$price*price_training$price)
norm_price_test<-lillie.test(x2)
print (norm_price_test) 
# Rechazamos Ho para nuestra muestra.  Price al cuadrado No sigue una distribuci?n Normal




#Transformaci?n general de potencias: Tambi?n llamada transformaci?n de Box-Cox,
#ya que fue propuesta por Box y Cox (1964). 
#Engloba a las anteriores mediante la siguiente f?rmula general

#el lambda para la maxima  log likeihood obteniendo un minimo SSE es 0.707

prueba<-(price_training$price^(0.707))
norm_price_test<-lillie.test(prueba)
print (norm_price_test) 





###vamos a analizar si es un problema con los outliers#####
#la distribucion del precio de la vivienda est? muy dispersa y esto va a dificultar
#la predicci?n del modelo. 

#Univariate -> boxplot. outside of 1.5 times inter-quartile range is an outlier.

lowerq = quantile(price_training$price)[2]
upperq = quantile(price_training$price)[4]
iqr = (upperq - lowerq) 
extreme.threshold.upper = (iqr * 1.5) + upperq
extreme.threshold.lower = lowerq - (iqr * 1.5)
extreme.threshold.upper
extreme.threshold.lower

dev.off()
#el nuevo dataset es dwo. Data without outliers

dwo<-subset(price_training, price_training$price<extreme.threshold.upper &
              price_training$price>extreme.threshold.lower)


###pasamos de 15119 a 14.344 observaciones
(norm_price_test<-lillie.test((dwo$price)))

#los datos siguen sin seguir una distribuci?n Normal. Esto incumple los principios del lm
#provemos con la distribucion log10 sobre los datos sin outliers.
(norm_price_test<-lillie.test(log10(dwo$price)))
histogram (log10(dwo$price))
qqnorm    (log10(dwo$price))
qqline    (log10(dwo$price))

#Se rechaza el contraste de Normalidad , pero tanto el Hitograma como el grafico Q-Q plot
# nos dicen que no se aleja mucho de una distribuci?n Normal. Por lo menos de forma intuitiva
#sabemos que estamos incumpliendo la hip?tesis de partida pero continuamos con el supuesto de
# TCL ya que no hemos encontrado ninguna transformacion que nos ayude

dwo$price_log<-(log10(dwo$price))


#########################################################################################
###nos quedamos con la transformacion logaritmica log10 para los price sin ouliers#######
#########################################################################################


#### analisis normalidad para las siguientes valibles continuas#####


#transformacion sqft_living
#transformacion sqft_lot
#transformacion sqft_basement
#transformacion sqft_above




##################################
#transformacion sqft_living
###################################


(norm_price_test<-lillie.test(dwo$sqft_living))
#rechazamos la Ho de normalidad. Proponemos transformacion logaritmica

(norm_price_test<-lillie.test(log10(dwo$sqft_living)))

histogram (dwo$sqft_living)
histogram (log10(dwo$sqft_living))
#el test se rechaza pero parece que nos aproximamos a una dist normal TCL
qqnorm(log10(dwo$sqft_living))
qqline(log10(dwo$sqft_living))


dwo$sqft_livingt_log<-log10(dwo$sqft_living)

#ninguna funcion  nos permite transforma a Normalidad. 



##################################
#transformacion sqft_lot
###################################

histogram (dwo$sqft_lot)
(norm_price_test<-lillie.test(dwo$sqft_lot))
#rechazamos la Ho de normalidad. Proponemos transformacion logaritmica


histogram (log10(dwo$sqft_lot))
qqnorm    (log10(dwo$sqft_lot))
qqline    (log10(dwo$sqft_lot))
(norm_price_test<-lillie.test(log10(dwo$sqft_lot)))
#tambien rechazamos la hipotesis de normalidad , esta de forma mucho m?s notoria en el gr?fico Q-Q
#proponemos otras transformaciones

#TRANSFORMACION raiz cuadrada
histogram (sqrt(dwo$sqft_lot))
qqnorm    (sqrt(dwo$sqft_lot))
qqline    (sqrt(dwo$sqft_lot))
(norm_price_test<-lillie.test(sqrt(dwo$sqft_lot)))
#tambien rechazamos la hipotesis de normalidad , esta de forma mucho m?s notoria en el gr?fico Q-Q
#proponemos otras transformaciones

#TRANSFORMACION inversa
histogram (1/(dwo$sqft_lot))
qqnorm    (1/(dwo$sqft_lot))
qqline    (1/(dwo$sqft_lot))
(norm_price_test<-lillie.test(1/(dwo$sqft_lot)))



#nos platearemos la inclusion o no en el modelo debido a la falta de Normalidad.
#La distribuci?n que m?s nos convence y apoyandonos en el TCL es la log10

dwo$sqft_lot_log<-log10(dwo$sqft_lot)




##############################################################
#transformacion sqft_basement
##############################################################


histogram (dwo$sqft_basement)
(norm_price_test<-lillie.test(dwo$sqft_basement))
#rechazamos la Ho de normalidad.
summary (dwo$sqft_basement)

#Proponemos transformacion logaritmica
histogram (log10(dwo$sqft_basement)) 

dwo$sqft_basement_log<-log10(dwo$sqft_basement)





################################################################
#transformacion sqft_above######################################
##################################################################


histogram (dwo$sqft_above)
(norm_price_test<-lillie.test(dwo$sqft_above))
#rechazamos la Ho de normalidad. Proponemos transformacion logaritmica



(norm_price_test<-lillie.test(log10(dwo$sqft_above)))
histogram (log10(dwo$sqft_above)) 
qqnorm    (log10(dwo$sqft_above))
qqline    (log10(dwo$sqft_above))

#ninguna funcion  nos permite transforma a Normalidad. Pero visualmente se aproxima
#y podria ser normal con el TCL

dwo$sqft_above_log<-log10(dwo$sqft_above)
#excluimos esta variable del an?lisis


#variables discretas. En este punto debemos tener en cuenta el pricipio de Parsimonia
#Este t?rmino hace referencia a que el mejor modelo es aquel capaz de explicar con mayor precisi?n
#la variabilidad observada en la variable respuesta empleando el menor n?mero de predictores,
#por lo tanto, con menos asunciones.

########################################################################
# condition#####################################################
########################################################################


ggplot(dwo, aes(dwo$condition)) + geom_bar() + ggtitle("Condition")
#problemas con los grupos con pocas frecuencias a considerar

dwo$condition<-as.character(dwo$condition)
aggregate(dwo$price, by=list(dwo$condition), FUN=mean)  



#hemos recodificado esta variable en tres grupos alrededor de la media en relacion a su precio medio
#veamos esta relacion antes y depues de la transformaci?n


dwo %>%
  group_by(condition) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=condition, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Condicion")




#podemos afirmar a priori y visualmente que existe una relaci?n entre el precio y la condicion




###################################################
###bedrooms#######################################
##################################################

ggplot(dwo, aes(dwo$bedrooms))  + geom_bar() + ggtitle("bedRooms")
#es una variable ordinal

dwo %>%
  group_by(bedrooms) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=bedrooms, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio medio por Habitaciones")

#vemos que claramente la distribucion es creciente a mayor bedrooms mayor precio


boxplot(price ~ bedrooms, data = dwo, col = "lightgreen", 
        xlab = "numero de camas", ylab = "precio vivienda") 

t_beds<-table(dwo$bedrooms)
t_beds
aggregate(dwo$price, by=list(dwo$bedrooms), FUN=mean) 

# nuestra decision y considerando los valores medios agrupar a partir de 6 camas en 
# una unica categoria obteniendo la variable bed_new

dwo$bedrooms_new<-recode (dwo$bedrooms,"6:11=6")
table(dwo$bedrooms_new)
aggregate(dwo$price, by=list(dwo$bedrooms_new), FUN=mean) 

boxplot(price ~ bedrooms_new, data = dwo, col = "lightgreen", 
        xlab = "numero de camas new", ylab = "precio vivienda")



###################################################################################
#bathrooms #######################################################################
###################################################################################

ggplot(dwo, aes(dwo$bathrooms)) + geom_bar() + ggtitle("bathrooms")
#es una variable ordinal
aggregate(dwo$price, by=list(dwo$bathrooms), FUN=mean) 


dwo %>%
  group_by(bathrooms) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=bathrooms, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Banyos")

table(dwo$bathrooms)
#la distribuci?n a partir de 4 es muy peque?a. Poco estable para inferir
#proponemos la recodificaci?n a partir de este valor

dwo$bathrooms_new<-recode (dwo$bathrooms,"4:8=4")
table(dwo$bathrooms_new)


dwo %>%
  group_by(bathrooms_new) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=bathrooms_new, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Banyos new")

boxplot(price ~ bathrooms_new, data = dwo, col = "red", 
        xlab = "numero de banyos new", ylab = "precio vivienda")



#############################################################################
#floors#####################################################################
#############################################################################

ggplot(dwo, aes(dwo$floors))    + geom_bar() + ggtitle("floors")


dwo %>%
  group_by(floors) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=floors, y=avg_price)) + geom_bar(stat = "identity")  +
  ggtitle("Precio Medio por Plantas")

#es una variable bastante estable en relaci?n al precio.
table(dwo$floors)
aggregate(dwo$price, by=list(dwo$floors), FUN=mean) 

#nuestra propuesta es recodifcar 2.5 en 2 y 3.5 en 3 
dwo$floors_new<-recode (dwo$floors,"2.5=2; 3.5=3")
table(dwo$floors_new)
aggregate(dwo$price, by=list(dwo$floors_new), FUN=mean) 



boxplot(price ~ floors_new, data = dwo, col = "blue", 
        xlab = "numero de floors new", ylab = "precio vivienda")




############################################################################
#waterfront ################################################################
############################################################################


ggplot(dwo, aes(dwo$waterfront))    + geom_bar() + ggtitle("waterfront")
#recode data nominal vistas versus no vistas #
ggplot(dwo, aes(dwo$waterfront))    + geom_bar() + ggtitle("waterfront")


table(dwo$waterfront)
aggregate(dwo$price, by=list(dwo$waterfront), FUN=mean) 



dwo %>%
  group_by(waterfront) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=waterfront, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Vista al Mar")

##variables significativa , vistas al mar implica mayor precio

dwo$waterfront_flag<-ifelse(dwo$waterfront> 0,
                      'SI', 'NO')


#############################################################################
#view  ######################################################################
#############################################################################


ggplot(dwo, aes(dwo$view))     + geom_bar() + ggtitle("view")
#VARIABLE ORDINAL CON ESCASA FRECUENCIA DISTINTA DE CERO
#interesante crear una nueva variable flag Visitas si versus visitas NO
dwo$view_flag<-ifelse(dwo$view> 0,
                                  'SI', 'NO')

#view_flag#nos podemos plantear un flag Visitada vs no vistada 
ggplot(dwo, aes(dwo$view_flag))     + geom_bar() + ggtitle("view_flag")



dwo %>%
  group_by(view) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=view, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Numero de Visitas")

####aqui vemos de forma clara que a mayor numero de visitas mayor precio en la vivienda

dwo %>%
  group_by(view_flag) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=view_flag, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Numero de Visitas flag")

####interesante mantener el flag s / n . existe una media en precio importante y cuidamos la parsimonia



################################################################################
#analisis de grade
################################################################################

ggplot(dwo, aes(dwo$grade))    + geom_bar() + ggtitle("grade")
#en este punto interesa crear una agrupaci?n en funci?n del precio que ser? nuestra variable objetivo
dwo$grade<-as.character(dwo$grade)

table(dwo$grade)
aggregate(dwo$price, by=list(dwo$grade), FUN=mean)                         


#parecen que se deberian formar los siguientes grupos (9,8) (7,13,10,s) (11,12,4,5,6) en funcion al 
#precio medio de estas viviendas 



dwo$grade_new<-recode (dwo$grade,
                                      "c('13','12','11','10')=2; 
                                       c('8','9')=1; 
                                       c('3','4','5','6','7','s') =0"
)

table(dwo$grade_new)
aggregate(dwo$price, by=list(dwo$grade_new), FUN=mean)  
# en esta tabla vemos que existen diferencias muy notables entre los distintos grupos

dwo %>%
  group_by(grade) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=grade, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Grado")

dwo %>%
  group_by(grade_new) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=grade_new, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Grado new")

###nueva variable grado discremina muy bien a nivel precio de la vivienda


############################################################################
##### analisis de la estacionalidad de la compra en funcion de los meses ###
############################################################################

#extraemos en mes por si existe una estcionalidad en la compra



#puede que nos estemos encontrando con un problema de serie temporal de forma velada
# por lo que vamos a incluir esta variable dentro del modelo de forma categ?rica y no continua

dwo$mes<-month(as.POSIXlt(dwo$date, format="%m/%d/%Y"))
table(dwo$mes)
aggregate(dwo$price, by=list(dwo$mes), FUN=mean)  

dwo %>%
  group_by(mes) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=mes, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por mes")

dwo$mes_new<-recode (dwo$mes,
 "1='enero'; 
2	=	'febrero';
3	=	'marzo';
4	=	'abril';
5	=	'mayo';
6	=	'junio';
7	=	'julio';
8	=	'agosto';
9	=	'septiembre';
10	=	'octubre';
11	=	'noviembre';
12	=	'diciembre'")

                             
table (dwo$mes_new)

################################################################################
### anyo de construccion 
###############################################################################
#parece que en esta variable tambien existe un fuerte componente estacional
#provaremos a meterla en el modelo y ver como funciona

table(dwo$yr_built)
aggregate(dwo$price, by=list(dwo$yr_built), FUN=mean)  


dwo %>%
  group_by(yr_built) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=yr_built, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Anyo Construccion")

#muy interesante esta variables vamos trabajar distintos Variaciones de la misma

# Partimos de la Hipotesis de que es existe una diferencia entre las viviendas antes 
# y despues del anyo 2000

dwo$flag_milenio<-recode (dwo$yr_built,
                                     "1900:1999='NO'; 2000:2020='SI'")


table(dwo$flag_milenio)
aggregate(dwo$price, by=list(dwo$flag_milenio), FUN=mean)  
dwo %>%
  group_by(flag_milenio) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=flag_milenio, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Milenio")
#Parece a priori que existe una diferencia significativa entre la construcc?on 
# durante un milenio y otro. Comprobaremos nuestra Hip?tesis con un test
# Suponiendo normalidad TCL
# t test 
# Ho : No existen diferencias significativas de precio entre las categorias Milenio 1900 y 2000 

m1<-subset(dwo, flag_milenio=="1")
m0<-subset(dwo, flag_milenio=="0")

set.seed(737)
test <- t.test(m0$price,m1$price) # Prueba t de Student
print(test)
#rechazamos la Ho , existen diferencias sginifcativas entre ambos milenios para la variable precio





############################################################################
#####anyo de renovacion 
###########################################################################


table(dwo$yr_renovated)
aggregate(dwo$price, by=list(dwo$yr_renovated), FUN=mean) 

# creamos un flag si /no por si ha reformado o no
dwo$yr_renovated<-as.numeric(dwo$yr_renovated)
dwo$flag_reforma<-recode (dwo$yr_renovated,
                                     "0='no'; 1900:2020='si'")
                                   
                                    

table(dwo$flag_reforma)
aggregate(dwo$price, by=list(dwo$flag_reforma), FUN=mean) 

####parece que existe diferencias entre el precio en funcion de si ha sido reformado
# o no pero no lo podemos afirmar con total seguridad , vamos a realizar un contraste
# de Hipotesis para analizar el flag 

# Suponiendo normalidad TCL
# t test 
# Ho : No existen diferencias significativas de precio entre las categorias reforma si/no 

f1<-subset(dwo, flag_reforma=="1")
f0<-subset(dwo, flag_reforma=="0")

set.seed(737)
test <- t.test(f0$price,f1$price) # Prueba t de Student
print(test)

# rechazamos  la Ho , 
# a partir de nuestros datos existen direncias significativas entre las poblaciones que han reformado 
#y las que no


dwo %>%
  group_by(flag_reforma) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=flag_reforma, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por  Reforma")



##################################################################
####creamos la variable antiguedad de la vivienda 
#### a partir de la fecha de compra date y el anyo de construccion
#################################################################

#tiempo desde la construccion  hasta la venta

tabla.frec  <- table(dwo$yr_built)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 

tabla.frec  <- table(dwo$date)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
#tienen distinto formato por lo que nos quedamos con el a?o

date1 <-  as.Date(dwo$date,'%m/%d/%Y')
year1 <- as.numeric(format(date1,'%Y'))
tabla.frec  <- table(year1)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 

dwo$antiguedad<-(year1-dwo$yr_built)+2
tabla.frec  <- table(dwo$antiguedad)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(dwo$antiguedad, xlab="antiguedad",ylab="frecuencia",
     main="histograma distribucion de la antiguedad", col="blue")

dwo %>%
  group_by(antiguedad) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=antiguedad, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por antiguedad")



histogram ((dwo$antiguedad))
summary ((dwo$antiguedad))
##vamos a realizar una transformacion logaritmica

histogram (log10(dwo$antiguedad))
qqnorm    (log10(dwo$antiguedad))
qqline    (log10(dwo$antiguedad))
(norm_price_test<-lillie.test(log10(dwo$antiguedad)))
###rechazamos la hipotesis de Normalidad en la transformacion logaritmica


##vamos a realizar una transformacion cuadratica

histogram (sqrt(dwo$antiguedad))
qqnorm    (sqrt(dwo$antiguedad))
qqline    (sqrt(dwo$antiguedad))
(norm_price_test<-lillie.test(sqrt(dwo$antiguedad)))

###rechazamos la hipotesis de Normalidad en la transformacion cuadr?tica


##vamos a realizar una transformacion inversa

histogram (1/(dwo$antiguedad))
qqnorm    (1/(dwo$antiguedad))
qqline    (1/(dwo$antiguedad))
(norm_price_test<-lillie.test(1/(dwo$antiguedad)))
#esta es la que peor funciona.
#nos plantemos si introducir la variable en el modelo ya que no es normal.
# de momento la transformacion que m?s nos convence es la raiz cuadrada.


dwo$antiguedad_raiz<-(sqrt(dwo$antiguedad))


#############################################################################
#####analisisi conjunto y correlaciones entre las variables##################
#############################################################################


#No colinialidad o multicolinialidad:
  
#  En los modelos lineales m?ltiples los predictores deben ser independientes, 
#no debe de haber colinialidad entre ellos.
#La colinialidad ocurre cuando un predictor est? linealmente relacionado
#con uno o varios de los otros predictores del modelo o 
#cuando es la combinaci?n lineal de otros predictores


summary(dwo)

chart.Correlation(dwo[c(23,24,26,27,36,37,38)], histogram = F, pch = 19)


# a partir del analisis de correlaciones 
# nos quedamos con la variables continuas siguientes 

#1-sqft_livingt_log
#2-sqft_lot_log
#3-floors_new
#4-sqft_above_log
#5- antiguedad_raiz 



#ANALISIS DE LAS ASOCIACIONES ENTRE VARIABLES CON EL V DE CRAMER
#La V de Cramer es muy habitual para medir la relaci?n entre factores,
#es menos susceptible a valores muestrales. Tambi?n 0 implica independencia
#y 1 una relaci?n perfecta entre los factores. Habitualmente
#valores superiores a 0,30 ya nos est?n indicando que hay una posible
#relaci?n entre las variables.

#flag_reforma
#flag_milenio
#grade_new
#condition_new
#mes_new
#view_flag
#waterfront_flag


cv.test = function(x,y) {
  CV = sqrt(chisq.test(x, y, correct=FALSE)$statistic /
              (length(x) * (min(length(unique(x)),length(unique(y))) - 1)))
  print.noquote("Cram?r V / Phi:")
  return(as.numeric(CV))
}


cv.test(x=dwo$flag_reforma,y=dwo$flag_milenio)
#[1] 0.1025731
cv.test(x=dwo$flag_reforma,y=dwo$grade_new)
#[1] 0.03513422
cv.test(x=dwo$flag_reforma,y=dwo$waterfront_flag)
#[1] 0.07131954
cv.test(x=dwo$flag_reforma,y=dwo$mes_new)
#[1] 0.04108059
cv.test(x=dwo$flag_reforma,y=dwo$view_flag)
#[1] 0.05551726
cv.test(x=dwo$flag_milenio,y=dwo$grade_new)
#[1] 0.3246008
####nos planteamos retizar la variable flag_milenio

cv.test(x=dwo$grade_new,y=dwo$mes_new)
#[1]0.04056281
cv.test(x=dwo$grade_new,y=dwo$view_flag)
#[1] 0.1305783

cv.test(x=dwo$mes_new,y=dwo$waterfront_flag)
#[1] 0.01678745

cv.test(x=dwo$view_flag,y=dwo$view_flag)
#[1] 0.01725379

cv.test(x=dwo$grade_new,y=dwo$condition)
#[1] 0.1471439

#variables in
#1-sqft_livingt_log
#2-sqft_lot_log
#3-floors_new
#4-sqft_above_log
#5- antiguedad_raiz 
#7-flag_reforma
#8-grade_new
#9.-condition
#10.-mes_new
#11.-view_flag
#12.-waterfront_flag


######################################################################
#####semma4 modelo ###################################################
######################################################################

#modelo1 . Seleccion de Predictores
#M?todo de entrada forzada: se introducen todos los predictores simult?neamente

modelo1 <- lm(formula = price ~sqft_livingt_log +sqft_lot_log + floors_new+
                sqft_above_log+ antiguedad_raiz + flag_reforma + grade_new + 
                condition+ +view_flag+waterfront_flag
                ,data = dwo)
modelo1
summary(modelo1)

#El modelo con todas las variables introducidas como predictores tiene un R2 nula 0,5133
#es capaz de explicar el 51,01% de la variabilidad observada en la esperanza de vida. 
#El p-value del modelo es significativo (p-value: < 2.2e-16) por lo que se puede aceptar 
#que el modelo no es por azar, al menos uno de los coeficientes parciales de regresi?n 
#es distinto de 0. Muchos de ellos no son significativos, 
#lo que es un indicativo de que podr?an no contribuir al modelo.

#por ejemplo la variable condition es problable que sea conveniente eliminarla 


#3.Selecci?n de los mejores predictores
#En este caso se van a emplear la estrategia de stepwise mixto. 
#El valor matem?tico empleado para determinar la calidad del modelo va a ser Akaike(AIC).

step(object = modelo1, direction = "backward", trace = 1)

#El mejor modelo resultante del proceso de selecci?n ha sido:
  
modelo <- (lm(formula = price_log ~ sqft_livingt_log + sqft_lot_log + floors_new + 
                sqft_above_log + antiguedad_raiz + flag_reforma + grade_new + 
                condition + +view_flag + waterfront_flag, data = dwo))
summary(modelo)

#intervalos de confianza para los predictores del modelo
confint(lm(formula = price_log ~ sqft_livingt_log + sqft_lot_log + floors_new + 
             sqft_above_log + antiguedad_raiz + flag_reforma + grade_new + 
             condition + +view_flag + waterfront_flag, data = dwo))



#analisis de los residuos del modelos. a Prioi siguen una distribucion normal
qqnorm(modelo$residuals)
qqline(modelo$residuals)

#test de normalidad de los residuos. Se rechaza la hipotesis Nula de normalidad
lillie.test(modelo$residuals)


#Variabilidad constante de los residuos (homocedasticidad):
#Al representar los residuos frente a los valores ajustados por el modelo,
#los primeros se tienen que distribuir de forma aleatoria en torno a cero,
#manteniendo aproximadamente la misma variabilidad a lo largo del eje X.
#Si se observa alg?n patr?n espec?fico, por ejemplo forma c?nica o mayor
#dispersi?n en los extremos, significa que la variabilidad es dependiente del valor ajustado
#y por lo tanto no hay homocedasticidad.

fit_plot <- ggplot(dwo, aes(modelo$fitted.values, modelo$residuals))+
  geom_smooth(method="lm", se=FALSE, color="lightgray")+      
  geom_point(alpha = 0.5) +
  theme(plot.background = element_rect(colour = NA))+
  xlab("x")+
  ylab("y")

fit_plot
#parece que no hay homocedasticidad a pesar de la poca calidad del modelo
#parece que existe una ligera forma c?nica en el extremo 



# An?lisis de Inflaci?n de Varianza (VIF):
vif(modelo)
#la variable condition mucha una inflaccion de la varianza muy alta. Tenemos que
#trabajarla para reducir su tama?o o eliminarla del modelo.


#Autocorrelaci?n:
library(car)
#Durbin-Watson Test For Autocorrelated Errors
dwt(modelo, alternative = "two.sided")
#parece que tenemos un problema de autocorrelacion clara. La hipotesis nula del test 
#Durbin-Watson, Tenemos que plantearnos el problema con Un SERIE TEMPORAL



# identificacion de los valores atipicos o influyentes en el modelo
library(dplyr)
dwo$studentized_residual <- rstudent(modelo)
borrar<-which(abs(dwo$studentized_residual) > 3)

#hemos identificado un numero importante de valores atipicos que nos pueden desvirtuar el modelo
#procedemos a eliminarlos.

summary(influence.measures(modelo))
influencePlot(modelo)
#observamos los resultados de la distancia de cook Distancia Cook (cook.d): 
#Se consideran influyentes valores superiores a 1.



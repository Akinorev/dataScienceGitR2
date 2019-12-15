
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
#install.packages("bestNormalize")
#@install.packages("rcompanion")

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

#################################################
####LECTURA DE LOS DATOS CON VARIABLES MISSING###
#################################################


#SEMMA
#SEMMA 1. SAMPLE

#TRAIN 70% / CONTROL 20% / TEST 10%

datos_miss <-read.csv2 (file="C:/Users/Pablo/Desktop/FAD_Práctica/kc_house_data_missing3.csv",
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

########################################################
#variables continuas ##################################
#######################################################

#################################
#trasnformacion para precio######
#################################



# Ver si cumple la hipotesis de Normalidad y si no es así realizar la transformacion 
# test de kolmogorov 
# Ho: La muestra proviene de una distribución normal.
# El nivel de significancia que se trabajará es de 0.05. Alfa=0.05
# Criterio de Decisión
# Si P < Alfa Se rechaza Ho


norm_price_test<-lillie.test(price_training$price)
print (norm_price_test)


# Rechazamos Ho para nuestra muestra. Price No sigue una distribución Normal

# posibles soluciones
# 1.-Transformacion logaritmico 10
# 2.-Raiz cuadrada
# 3.-Inversa 1/x

#Prueba 1 . Logaritmo

norm_price_test<-lillie.test(log10(price_training$price))
print (norm_price_test)
histogram(log10(price_training$price))
# Rechazamos Ho para nuestra muestra.Log10 Price No sigue una distribución Normal

qqnorm(log10(price_training$price))
qqline(log10(price_training$price))
#vemos que en los valores superiores no se ajusta del todo a una normal. pero nos apoyamos en TCL


#Prueba 2 . Raiz Cuadrada sqrt 
histogram(sqrt(price_training$price))
norm_price_test<-lillie.test(sqrt(price_training$price))
print (norm_price_test) 
# Rechazamos Ho para nuestra muestra. Raiz cuadrada de Price No sigue una distribución Normal


#Prueba 3 . Inversa 1/x 
histogram(1/(price_training$price))
norm_price_test<-lillie.test(1/(price_training$price))
print (norm_price_test) 
# Rechazamos Ho para nuestra muestra. Inversa de  Price No sigue una distribución Normal

#Prueba 4 . x al cuadrado
histogram((price_training$price*price_training$price))
x2<-(price_training$price*price_training$price)
norm_price_test<-lillie.test(x2)
print (norm_price_test) 
# Rechazamos Ho para nuestra muestra.  Price al cuadrado No sigue una distribución Normal




#Transformación general de potencias: También llamada transformación de Box-Cox,
#ya que fue propuesta por Box y Cox (1964). 
#Engloba a las anteriores mediante la siguiente fórmula general


b <- boxcox(price_training$price ~ price_training$grade_new)
lambda <- b$x # lambda values
lik <- b$y # log likelihood values for SSE
bc <- cbind(lambda, lik) # combine lambda and lik
sorted_bc <- bc[order(-lik),]
head(sorted_bc, n = 10)

#el lambda para la maxima  log likeihood obteniendo un minimo SSE es 0.707

prueba<-(price_training$price^(0.707))
norm_price_test<-lillie.test(prueba)
print (norm_price_test) 



###vamos a analizar si es un problema con los outliers#####

#Univariate -> boxplot. outside of 1.5 times inter-quartile range is an outlier.

lowerq = quantile(price_training$price)[2]
upperq = quantile(price_training$price)[4]
iqr = (upperq - lowerq) 
extreme.threshold.upper = (iqr * 3) + upperq
extreme.threshold.lower = lowerq - (iqr * 3)
extreme.threshold.upper
extreme.threshold.lower

dev.off()
dwo<-subset(price_training, price_training$price<extreme.threshold.upper &
              price_training$price>extreme.threshold.lower)


###pasamos de 15119 a 14.344 observaciones
(norm_price_test<-lillie.test(log10(price_training$price)))
histogram (log10(dwo$price))
qqnorm    (log10(dwo$price))
qqline    (log10(dwo$price))



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

#estudiamos si tenemos problemas con los outliers en esta variable

lowerq = quantile(dwo$sqft_living)[2]
upperq = quantile(dwo$sqft_living)[4]
iqr = (upperq - lowerq) 
extreme.threshold.upper = (iqr * 3) + upperq
extreme.threshold.lower = lowerq - (iqr * 3)
extreme.threshold.upper
extreme.threshold.lower

dwo<-subset(dwo, dwo$sqft_living<extreme.threshold.upper &
                 dwo$sqft_living>extreme.threshold.lower)


###pasamos de  14.344 a 14.338 observaciones
histogram (log10(dwo$sqft_living))
qqnorm(log10(dwo$sqft_living))
qqline(log10(dwo$sqft_living))
#el test se rechaza pero parece que nos aproximamos a una dist normal TCL



dwo$sqft_living_log<-(log10(dwo$sqft_living))


##################################
#transformacion sqft_lot
###################################


(norm_price_test<-lillie.test(dwo$sqft_lot))
#rechazamos la Ho de normalidad. Proponemos transformacion logaritmica
(norm_price_test<-lillie.test(log10(dwo$sqft_lot)))

histogram (dwo$sqft_lot)
histogram (log10(dwo$sqft_lot))
histogram (sqrt(dwo$sqft_lot))
histogram ((dwo$sqft_lot)*(dwo$sqft_lot))

#la mas fiable parece la logaritmica 
#estudiamos si tenemos problemas con los outliers en esta variable

lowerq = quantile(dwo$sqft_lot)[2]
upperq = quantile(dwo$sqft_lot)[4]
iqr = (upperq - lowerq) 
extreme.threshold.upper = (iqr * 3) + upperq
extreme.threshold.lower = lowerq - (iqr * 3)
extreme.threshold.upper
extreme.threshold.lower


dwo<-subset(dwo, dwo$sqft_lot<extreme.threshold.upper &
                 dwo$sqft_lot>extreme.threshold.lower)

###pasamos de  14.338 a 14.332 observaciones

histogram (dwo$sqft_lot)
histogram (log10(dwo$sqft_lot))
qqnorm(log10(dwo$sqft_lot))
qqline(log10(dwo$sqft_lot))

#log10 es la transformacion que mas se aproxima a la normal


dwo$sqft_lot_log<-(log10(dwo$sqft_lot))



##############################################################
#transformacion sqft_basement
##############################################################

(norm_price_test<-lillie.test(dwo$sqft_basement))
#rechazamos la Ho de normalidad. Proponemos transformacion logaritmica

histogram (dwo$sqft_basement)
histogram (log10(dwo$sqft_basement))                          
histogram (1/(dwo$sqft_basement))
histogram (sqrt(dwo$sqft_basement))



# analisis de los outliers 
lowerq = quantile(dwo$sqft_basement)[2]
upperq = quantile(dwo$sqft_basement)[4]
iqr = (upperq - lowerq) 
extreme.threshold.upper = (iqr * 1.5) + upperq
extreme.threshold.lower = lowerq - (iqr * 1.5)
extreme.threshold.upper
extreme.threshold.lower

dwo<-subset(dwo, dwo$sqft_basement<extreme.threshold.upper &
                dwo$sqft_basement>extreme.threshold.lower)



###pasamos de 14.332 a 12.882  observaciones
#nos quedamos con la transformacion logaritmica
histogram (log10(dwo$sqft_basement))  
dwo$sqft_basement_log<-(log10(dwo$sqft_basement))





################################################################
#transformacion sqft_above######################################
##################################################################

(norm_price_test<-lillie.test(dwo$sqft_above))
#rechazamos la Ho de normalidad. Proponemos transformacion logaritmica

histogram (dwo$sqft_above)
histogram (log10(dwo$sqft_above)) 

#estudiamos si tenemos problemas con los outliers en esta variable

lowerq = quantile(dwo$sqft_above)[2]
upperq = quantile(dwo$sqft_above)[4]
iqr = (upperq - lowerq) 
extreme.threshold.upper = (iqr * 3) + upperq
extreme.threshold.lower = lowerq - (iqr * 3)
extreme.threshold.upper
extreme.threshold.lower


dwo<-subset(dwo, dwo$sqft_above<extreme.threshold.upper &
                 dwo$sqft_above>extreme.threshold.lower)


###pasamos de  12.882 a 12.878 observaciones

#nos quedamos con la transformacion logaritmica
histogram (log10(dwo$sqft_above))  
qqnorm(log10(dwo$sqft_above))
qqline(log10(dwo$sqft_above))


#no son transfromaciones a Normal pero se aproximan más  TCL

dwo$sqft_above_log<-(log10(dwo$sqft_above))




#variables discretas

########################################################################
# condition#####################################################
########################################################################


ggplot(dwo, aes(dwo$condition)) + geom_bar() + ggtitle("Condition")
#problemas con los grupos con pocas frecuencias a considerar

dwo$condition<-as.character(dwo$condition)
aggregate(dwo$price, by=list(dwo$condition), FUN=mean)  


dwo$condition_new<-recode (dwo$condition,
                                      "c('1','2')='low'; 
                                       c('3','4')='med'; 
                                       c('5')    ='hig'"
                                      )
ggplot(dwo, aes(dwo$condition_new)) + geom_bar() + ggtitle("Condition new")

#hemos recodificado esta variable en tres grupos alrededor de la media en relacion a su precio medio
#veamos esta relacion antes y depues de la transformación


dwo %>%
  group_by(condition) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=condition, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Condicion")

#nos llama la atencion el grupo 1 y 2 precios en medio mucho menor que los otros 3 grupos
#si aplicamos la transformacion


dwo %>%
  group_by(condition_new) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=condition_new, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Condicion New")


ggplot(data = dwo, aes(x = condition_new, y = price, color = condition_new)) +
  geom_boxplot() +
  theme_bw()

#podemos afirmar a priori y visualmente que existe una relación entre el precio y la 
#condicion de la vivienda que se refleja claramente en el grupo LOW




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
#la distribución a partir de 4 es muy pequeña. Poco estable para inferir
#proponemos la recodificación a partir de este valor

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

#es una variable bastante estable en relación al precio.
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
dwo$waterfront[which(dwo$waterfront == 0)] <- "WF_NO"
dwo$waterfront[which(dwo$waterfront == 1)] <- "WF_SI"
ggplot(dwo, aes(dwo$waterfront))    + geom_bar() + ggtitle("waterfront")


table(dwo$waterfront)
aggregate(dwo$price, by=list(dwo$waterfront), FUN=mean) 



dwo %>%
  group_by(waterfront) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=waterfront, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Vista al Mar")

##variables significativa , vistas al mar implica mayor precio




#############################################################################
#view  ######################################################################
#############################################################################


ggplot(dwo, aes(dwo$view))     + geom_bar() + ggtitle("view")
#VARIABLE ORDINAL CON ESCASA FRECUENCIA DISTINTA DE CERO
#interesante crear una nueva variable flag Visitas si versus visitas NO
dwo$view_flag<-ifelse(dwo$view> 0,
                                  "VS_SI", "VS_NO")

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
#en este punto interesa crear una agrupación en función del precio que será nuestra variable objetivo
dwo$grade<-as.character(dwo$grade)

table(dwo$grade)
aggregate(dwo$price, by=list(dwo$grade), FUN=mean)                         


#parecen que se deberian formar los siguientes grupos (9,8) (7,13,10,s) (11,12,4,5,6) en funcion al 
#precio medio de estas viviendas 


dwo$grade_new<-recode (dwo$grade,
                                      "c('12','11','10')='Grade_top'; 
                                       c('8','9')='Grade_med'; 
                                       c('3','4','5','6','7','s')    ='Grade_low'"
)

table(dwo$grade_new)
aggregate(dwo$price, by=list(dwo$grade_new), FUN=mean)  


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

dwo$mes<-month(as.POSIXlt(dwo$date, format="%m/%d/%Y"))
table(dwo$mes)
aggregate(dwo$price, by=list(dwo$mes), FUN=mean)  


dwo %>%
  group_by(mes) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=mes, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por mes")

###no parece a priori que presente una gran variabilidad

################################################################################
### anyo de construccion 
###############################################################################


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
                                     "1900:1999=0; 2000:2020=1")


table(dwo$flag_milenio)
aggregate(dwo$price, by=list(dwo$flag_milenio), FUN=mean)  
dwo %>%
  group_by(flag_milenio) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=flag_milenio, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Milenio")
#Parece a priori que existe una diferencia significativa entre la construccíon 
# durante un milenio y otro. Comprobaremos nuestra Hipótesis con un test
# Suponiendo normalidad TCL
# t test 
# Ho : No existen diferencias significativas de precio entre las categorias Milenio 1900 y 2000 

m1<-subset(dwo, flag_milenio=="1")
m0<-subset(dwo, flag_milenio=="0")

set.seed(737)
test <- t.test(m0$price,m1$price) # Prueba t de Student
print(test)
#rechazamos la Ho , existen diferencias sginifcativas entre ambos milenios para la variable precio
boxplot(m0$price,m1$price,names=c("m_1900","m_2000"))




############################################################################
#####anyo de renovacion 
###########################################################################


table(dwo$yr_renovated)
aggregate(dwo$price, by=list(dwo$yr_renovated), FUN=mean) 

# creamos un flag si /no por si ha reformado o no
dwo$yr_renovated<-as.numeric(dwo$yr_renovated)
dwo$flag_reforma<-recode (dwo$yr_renovated,
                                     "0=0; 1900:2020=1")
                                   
                                    

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
#tienen distinto formato por lo que nos quedamos con el año

date1 <-  as.Date(dwo$date,'%m/%d/%Y')
year1 <- as.numeric(format(date1,'%Y'))
tabla.frec  <- table(year1)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 

dwo$antiguedad<-(year1-dwo$yr_built)
tabla.frec  <- table(dwo$antiguedad)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(dwo$antiguedad, xlab="antiguedad",ylab="frecuencia",
     main="histograma distribucion de la antiguedad", col="blue")

dwo %>%
  group_by(antiguedad) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=antiguedad, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por antiguedad")


##vamos a realizar una transformacion logaritmica
histogram ((dwo$antiguedad))

# el mejor tratamiento a esta variable es hacer banding discretos, así esquivamos los problemas con norm
tabla.frec
dwo$ant_clas<-recode (dwo$antiguedad,
                        "-1:10=1; 
                          11:20=2;
                          21:30=3;
                          31:40=4;
                          41:50=5;
                          51:60=6;
                          61:70=7;
                          71:80=8;
                          81:90=9;
                          91:120=10;
                      ")

histogram ((dwo$ant_clas))


dwo %>%
  group_by(ant_clas) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=ant_clas, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por  antiguedad banding")





#############################################################################
#####analisisi conjunto y correlaciones entre las variables##################
#############################################################################

#listado de variables de las que vamos a partir

#price_log        
#sqft_living_log 
#sqft_lot_log
#sqft_basement_log 
#sqft_above_log 
#condition_new       
#bedrooms_new   
#bathrooms_new  
#floors_new
#view
#view_flag          
#grade_new             
#mes         
#flag_milenio     
#flag_reforma
#ant_clas

summary (dwo)

# Correlation plot

ggcorr(dwo, palette = "RdBu", label = TRUE)

dwo$condition_new



#####analisis

price1 <- price_training %>% select(grade_new, price) %>%
  na.omit() %>%
  ggplot(aes(x=grade_new, y=price, fill=grade_new)) +
  geom_boxplot()
  

price2 <- price_training %>% mutate(log10_price = log10(price)) %>%
  select(grade_new, log10_price) %>%
  na.omit() %>%
  ggplot(aes(x=grade_new, y=log10_price, fill=grade_new)) +
  geom_boxplot()
  

p1 <- price_training %>% select(grade_new, price) %>%
  na.omit() %>%
  ggplot(aes(x=price, colour=grade_new)) +
  geom_density()

p2 <- price_training %>% mutate(log10_price = log10(price)) %>%
  select(grade_new, log10_price) %>%
  na.omit() %>%
  ggplot(aes(x=log10_price, colour=grade_new)) +
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




#analisis de correlaciones de las variables metros 
###analisis de las correlaciones###

# Correlation plot
ggcorr(dta, palette = "RdBu", label = TRUE)

# Correlation plot all variables
ggcorr(price_training, palette = "RdBu", label = TRUE)
#tenemos que borrar Bedrooms y bathrooms






####analisis de los outliers#####




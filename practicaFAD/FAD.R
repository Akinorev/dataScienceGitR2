
#librerias
install.packages("expss")
install.packages("egg")
install.packages("GGally")
install.packages("ISLR")
install.packages("car")
install.packages("DMwR2")
install.packages("faraway")
install.packages("mlbench")
install.packages("kableExtra")
install.packages("bsplus")
install.packages("VIM")
install.packages("mice")
install.packages("lattice")
install.packages("rbind")
install.packages("GUI")
install.packages("expss")
install.packages("dplyr")
install.packages("gridExtra")
install.packages("carData")
install.packages("sos")
install.packages("brew")
install.packages("dplyr")
install.packages("magrittr") 
install.packages("caret")

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


#################################################
####LECTURA DE LOS DATOS CON VARIABLES MISSING###
#################################################


#label variables datos origen datos_root

datos_at = apply_labels(datos_root,
                        date            = "Date house was sold",
                        price           = "Price is prediction target",
                        bedrooms        = "Number of Bedrooms/House",
                        bathrooms       = "Number of bathrooms",
                        sqft_living     = "square footage of the home",
                        sqft_lot        = "square footage of the lot",
                        floors          = "Total floors (levels) in house",
                        waterfront      = "House which has a view to a waterfront",
                        view            = "Has been viewed",
                        condition       = "How good the condition is ( Overall ). 1 indicates worn out property and 5 excellent",
                        grade           = "overall grade given to the housing unit, based on King County grading system. 1 poor ,13 excellent",
                        sqft_above      = "square footage of house apart from basement",
                        sqft_basement   = "square footage of the basement",
                        yr_built        = "Built Year",
                        yr_renovated    = "Year when house was renovated",
                        zipcode         = "Postal Code",
                        lat             = "Latitude",
                        long            = "Longitude",
                        sqft_living15   = "Living room area in 2015(implies-- some renovations) This might or might not have affected the lotsize area",
                        sqft_lot15      = "lotSize area in 2015(implies-- some renovations)"
)



attr(datos_at[["date"]], "label")
attr(datos_at[["price"]], "label")
attr(datos_at[["bedrooms"]], "label")
attr(datos_at[["bathrooms"]], "label")
attr(datos_at[["sqft_living"]], "label")
attr(datos_at[["sqft_lot"]], "label")
attr(datos_at[["floors"]], "label")
attr(datos_at[["waterfront"]], "label")
attr(datos_at[["view"]], "label")
attr(datos_at[["condition"]], "label")
attr(datos_at[["grade"]], "label")
attr(datos_at[["sqft_above"]], "label")
attr(datos_at[["sqft_basement"]], "label")
attr(datos_at[["yr_built"]], "label")
attr(datos_at[["yr_renovated"]], "label")
attr(datos_at[["zipcode"]], "label")
attr(datos_at[["lat"]], "label")
attr(datos_at[["long"]], "label")
attr(datos_at[["sqft_living15"]], "label")
attr(datos_at[["sqft_lot15"]], "label")



datos_miss <-read.csv2 (file="/mnt/laptopspace/Datos/01_Proyectos actuales/00_MasterDataScience/dataScienceGitR2/practicaFAD/kc_house_data_missing.csv",
                       header=TRUE, na = c("", "NA"), )
datos_miss
summary (datos_miss)

#recode data nominal #

datos_miss$waterfront[which(datos_miss$waterfront == 0)] <- "WF_NO"
datos_miss$waterfront[which(datos_miss$waterfront == 1)] <- "WF_SI"



datos_miss$condition[which(datos_miss$condition == 1)] <- "Co_1_Low"
datos_miss$condition[which(datos_miss$condition == 2)] <- "Co_2_Med_low"
datos_miss$condition[which(datos_miss$condition == 3)] <- "Co_3_Med"
datos_miss$condition[which(datos_miss$condition == 4)] <- "Co_4_High"
datos_miss$condition[which(datos_miss$condition == 5)] <- "Co_5_Top"



histogram(datos_miss$grade)



datos_miss$grade<-recode(datos_miss$grade, "0:6=1; 7=2; 8=3; 9=4; else=5")


histogram(datos_miss$grade)


##3 An?lisis exploratorio de datos faltantes: VIM##
aggr_plot <- aggr(datos_miss, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE,
                  labels=names(datos_miss), cex.axis=.8, gap=1, 
                  ylab=c("Histogram of missing data","Pattern"))


#ranking de las variables missing
#sqft_lot      59
#bedrooms      56
#sqft_living   41
#sqft_basement 41
#bathrooms     40
#sqft_above    40


# Visualizaci?n de valores faltantes

datos_miss %>% select(sqft_lot, condition) %>% marginplot()
#vemos que los valores missing de Bedrooms suele darse en valores de sqft_lot bajos.
#sobre todo en los primeros niveles. Imputaci?n a trav?s del algoritmo KNN de VIM

datos_miss %>% select(sqft_lot, bedrooms) %>% VIM::kNN() %>% marginplot(., delimiter="_imp")
#parece que no se aparta demasiado por lo que la imputaci?n es buena 



##########################################
#### Imputaci?n individual Libreria Mice##
##########################################



# Imputaci?n simple, regresi?n ordinaria
#norm.predict: Corresponde a imputaci?n por regresi?n lineal. Si configuramos m=1,
#entonces es equivalente a la imputaci?n simple con este m?todo descrita en la secci?n anterior.
# m es el n?mero de multiples imputaciones 




install.packages("Amelia")
library(Amelia)

####amelia#####


noms   = c( "waterfront","condition" )
ords   = c("bathrooms","floors","grade","view")
idvars = c( "id","date", "price", "lat", "long" )

data_imp  = amelia(datos_miss, m=5, p2s=2, parallel = "no",
                idvars= idvars,
                ords=ords,
                noms =  noms)  


plot(data_imp)


#analisis de los data sets imputados
#Diagnostics
#Amelia currently provides a number of diagnostic tools to inspect the imputationsthat are created




#overimpute 
#?son precisos los valores imputados? al tener m=5 imputaciones nos permite construir un IC para validar
#la calidad de la imputaci?n y=x indica la linea de perfecto acuerdo con IC al 90% , cuanto m?s se ajuste 
#a la linea x=y mejor predice la imputaci?n de missing 
#Parece m?s complejo para las ordinales...no es continuo ..existen casos extremos

  

overimpute(data_imp, var = "sqft_living")
overimpute(data_imp, var = "sqft_lot")
overimpute(data_imp, var = "bedrooms")
overimpute(data_imp, var = "bathrooms")
overimpute(data_imp, var = "floors")
overimpute(data_imp, var = "waterfront")
overimpute(data_imp, var = "view")
overimpute(data_imp, var = "condition")
overimpute(data_imp, var = "grade")
overimpute(data_imp, var = "sqft_above")
overimpute(data_imp, var = "sqft_basement")
overimpute(data_imp, var = "yr_built")
overimpute(data_imp, var = "yr_renovated")
overimpute(data_imp, var = "sqft_living15")
overimpute(data_imp, var = "sqft_lot15")




###analisis de la imputacion con los m?ximos locales a la hora de identificar una imputaci?n
#cuando la confunde con un m?ximo global, para evitarlo es interesante realizar , el algortimo se
#ve influenciado por el momento y sitio donde comienza , multiples imputaciones iniciales
#amelia proporciona un diagn?stico para validar el algoritmo desde valores iniciales distintos



#grafico donde todas las cadenas EM convergen al mismo modo, independientemente del valor inicial

disperse(data_imp, dims = 1, m = 5)

#numero de iteraciones 2

write.amelia( data_imp, file.stem ="C:/Users/olmosp/Desktop/pie/fad/etet")
datos_clean <-read.csv (file="C:/Users/olmosp/Desktop/pie/fad/etet2.csv",
                        header=TRUE, na = c("", "NA"), )
datos_clean
summary (datos_clean)


datos_clean$beds<-floor (datos_clean$bedrooms)
datos_clean$baths<-floor (datos_clean$bathrooms)

datos_clean$beds
datos_clean$baths

#SEMMA
#SEMMA 1. SAMPLE

#TRAIN 70% / CONTROL 30%



library(caret)
library(dplyr)

set.seed(5876)
inTraining <- createDataPartition(pull(datos_clean),
                                  p = .7, list = FALSE, times = 1)
price_training <- slice(datos_clean, inTraining)
price_testing  <- slice(datos_clean, -inTraining)


#SEMMA 2. EXPLORE

#ANALISIS 
#VISUALIZACI?N DE LOS DATOS
#OUTLIER


#variables discretas


ggplot(price_training, aes(price_training$condition)) + geom_bar() + ggtitle("Condition")
ggplot(price_training, aes(price_training$beds))  + geom_bar() + ggtitle("bedRooms")
ggplot(price_training, aes(price_training$baths)) + geom_bar() + ggtitle("bathrooms")
ggplot(price_training, aes(price_training$floors))    + geom_bar() + ggtitle("floors")
ggplot(price_training, aes(price_training$waterfront))    + geom_bar() + ggtitle("waterfront")
ggplot(price_training, aes(price_training$view))     + geom_bar() + ggtitle("view")
ggplot(price_training, aes(price_training$grade))    + geom_bar() + ggtitle("grade")
ggplot(price_training, aes(price_training$yr_built))     + geom_bar() + ggtitle("yr_built")
ggplot(price_training, aes(price_training$yr_renovated))    + geom_bar() + ggtitle("yr_renovated")


histogram(price_training$condition)
histogram(price_training$bedrooms)
histogram(price_training$bathrooms)
histogram(price_training$floors)
histogram(price_training$waterfront)
histogram(price_training$view)
histogram(price_training$grade)
histogram(price_training$yr_built)
histogram(price_training$yr_renovated)


##analisis por el precio de la vivienda

price_training %>%
  group_by(condition) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=condition, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Condicion")

price_training %>%
  group_by(beds) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=beds, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio medio por Habitaciones")

price_training %>%
  group_by(baths) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=baths, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Banyos")

price_training %>%
  group_by(floors) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=floors, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Plantas")

price_training %>%
  group_by(waterfront) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=waterfront, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Vista al Mar")

price_training %>%
  group_by(view) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=view, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Numero de Visitas")


price_training %>%
  group_by(grade) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=grade, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Grado")

price_training %>%
  group_by(yr_built) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=yr_built, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Anyo Construccion")


price_training %>%
  group_by(yr_renovated) %>% 
  summarise(avg_price = mean(price)) %>%
  ggplot(aes(x=yr_renovated, y=avg_price)) + geom_bar(stat = "identity") + 
  ggtitle("Precio Medio por Anyo Reforma")

######################
#variables continuas##
######################


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
     xlab="Car Weight ", ylab="Miles Per Gallon ", pch=100)

library(car)
scatterplot(price_training$sqft_living ~ price_training$price | price_training$baths, data=price_training,
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



glimpse(price_training)



boxplot(price ~ beds, data = price_training)
boxplot(price ~ baths, data = price_training)                      
boxplot(price ~ condition, data = price_training)
boxplot(price ~ grade, data = price_training)  
boxplot(price ~ waterfront    , data = price_training)
boxplot(price ~ view, data = price_training)
boxplot(price ~ floors, data = price_training)


#ANALISIS EXLORATORIO DE LOS DATOS


####Transformaciones para igualar dispersi?n#####
#podemos ver que sus valores para t odos los grupos est?n muy sesgados. 
#Ser?a conveniente transformarla para que la distribuci?n de valores 
#fuese m?s homog?nea.
#Este resultado se consigue aplicando una transformaci?n logar?tmica.


p1 <- datos_root %>% select(new, price) %>%
  na.omit() %>%
  ggplot(aes(x=price, colour=new)) +
  geom_density()

p2 <- datos_root %>% mutate(log10_price = log10(price)) %>%
  select(new, log10_price) %>%
  na.omit() %>%
  ggplot(aes(x=log10_price, colour=new)) +
  geom_density()


p1
p2



boxplot(price ~ new, data = datos_root)
boxplot(price ~ condition, data = datos_root)

###trabajo con los outlier#######

###analisis de las correlaciones###

df <- datos_root[, c(3,4,5,6,7,8,9,10,12,13,14,15,16,20,21)]
# Correlation plot
ggcorr(df, palette = "RdBu", label = TRUE)




##GRAFICO CON LA TRANFORMACION LOG10

########################################################
###analisis de las variables discretas y  ordinales#####
########################################################

##bedrooms

tabla.frec  <- table(datos_root$bedrooms)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ bedrooms, xlab="camas",ylab="frecuencia",main="histograma camas", col="red")

#newbedroom
datos_root$new_bedrooms<-recode(datos_root$bedrooms,"c(6,7,8,9,10,11,33)='6'")
tabla.frec  <- table(datos_root$new_bedrooms)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ new_bedrooms, xlab="camas",ylab="frecuencia",main="histograma camas", col="red")


##bathrooms


tabla.frec  <- table(datos_root$bathrooms)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ bathrooms, xlab="bathrooms",ylab="frecuencia",main="histograma bathrooms", col="red")

#newbathrooms
datos_root$newbathrooms<-recode(datos_root$bathrooms,"4.75:hi=5")
tabla.frec  <- table(datos_root$newbathrooms)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ newbathrooms, xlab="banyos",ylab="frecuencia",main="histograma banyos", col="red")


#floors


tabla.frec  <- table(datos_root$floors)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ floors, xlab="floors",ylab="frecuencia",main="histograma floors", col="red")


#NEWFLOORS 


datos_root$newfloors<-recode(datos_root$floors,"2.5:hi=3")
tabla.frec  <- table(datos_root$newfloors)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ newfloors, xlab="pisos",ylab="frecuencia",main="histograma pisos", col="blue")


#waterfront

tabla.frec  <- table(datos_root$waterfront)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ waterfront, xlab="waterfront",ylab="frecuencia",main="histograma waterfront", col="red")



#view

tabla.frec  <- table(datos_root$view)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ view, xlab="view",ylab="frecuencia",main="histograma view", col="red")

#newview

datos_root$newview<-recode(datos_root$view,"1:hi=1")
tabla.frec  <- table(datos_root$newview)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ newview, xlab="visitadp",ylab="frecuencia",main="histograma visitado", col="blue")

#condition


tabla.frec  <- table(datos_root$condition)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ condition, xlab="condition",ylab="condition",main="histograma condition", col="red")


#grade


tabla.frec  <- table(datos_root$grade)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(datos_root $ grade, xlab="grade",ylab="grade",main="histograma grade", col="red")

#tiempo desde la construccion  hasta la venta

tabla.frec  <- table(datos_root$yr_built)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 

tabla.frec  <- table(datos_root$date)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 

date1 <-  as.Date(datos_root$date,'%m/%d/%Y')
year1 <- as.numeric(format(date1,'%Y'))
tabla.frec  <- table(year1)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 


antiguedad<-(year1-datos_root$yr_built)
tabla.frec  <- table(antiguedad)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(antiguedad, xlab="antiguedad",ylab="frecuencia",main="histograma antiguedad", col="blue")


#flag reforma si/no

tabla.frec  <- table(datos_root$yr_renovated)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 


flag_reforma<-recode(datos_root$yr_renovated,"1:hi=1")
tabla.frec  <- table(flag_reforma)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 
hist(flag_reforma, xlab="flag_reforma",ylab="frecuencia",main="histograma flag_reforma", col="blue")



#analisis de las zonas codigo postal

tabla.frec  <- table(datos_root$zipcode)   # Crea la tabla de frecuencias
as.data.frame(tabla.frec) 



########################################################
###analisis de las variables continuas             #####
########################################################

#trasnformacion para precio

price1 <- datos_root %>% select(condition, price) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=price, fill=condition)) +
  geom_boxplot()

price2 <- datos_root %>% mutate(log10_price = log10(price)) %>%
  select(condition, log10_price) %>%
  na.omit() %>%
  ggplot(aes(x=condition, y=log10_price, fill=condition)) +
  geom_boxplot()


grid.arrange(price1, price2, nrow = 1)


#transformacion sqft_living

sqft_liv1 <- datos_root %>% select(new, sqft_living) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=sqft_living, fill=new)) +
  geom_boxplot()

sqft_liv2 <- datos_root %>% mutate(log10_sqft_living = log10(sqft_living)) %>%
  select(new, log10_sqft_living) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=log10_sqft_living, fill=new)) +
  geom_boxplot()

grid.arrange(sqft_liv1, sqft_liv2, nrow = 1)



#transformacion sqft_lot

sqft_lot1<- datos_root %>% select(new, sqft_lot) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=sqft_lot, fill=new)) +
  geom_boxplot()

sqft_lot2 <- datos_root %>% mutate(log10_sqft_lot = log10(sqft_lot)) %>%
  select(new, log10_sqft_lot) %>%
  na.omit() %>%
  ggplot(aes(x=new, y=log10_sqft_lot, fill=new)) +
  geom_boxplot()


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
  ggtitle("Salario promedio por categor?a")



####analisis de los outliers#####




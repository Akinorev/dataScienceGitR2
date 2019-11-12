


# base de datos de impago en credito . Target=1 Impago #

base<- read.csv (file="C:/Users/olmosp/Desktop/pie/credit-card/application_data.csv", header=TRUE, sep=",")
names (base)
summary (base)
base
#Motive!
#This data set is uploaded in order to get the insights of Credit card Defaultees based on the respective attributes!
#We have attributes such as Income_Total,AMT_APPLICATION,AMT_CREDIT and around 122 Columns in Application Data Set. 
#The interesting thing is if you intend to see the patterns and variations, we can use the PREVIOUS APPLICATION data set also, 
#in order to get more insights.!

# El modelo de datos tiene que poder dividirse en dos periodos de tiempo 
#  entiendo que aqui lo que quiere es una variable que nos sirva para contrastar con el target, tenemos varias a nivel discreto
#  Discretas Ejemplo
#    .-Género
#    .-Flags
#    .-tipo de casa
#    .-ORGANIZATION_TYPE
#    .-OCCUPATION_TYPE
#    .-NAME_EDUCATION_TYPE   
#    .-NAME_FAMILY_STATUS 
#    .-NAME_HOUSING_TYPE
    
#  Continuas Ejemplo
#    .-AMT_INCOME_TOTAL 
#    .-AMT_CREDIT 
#    .-AMT_ANNUITY 
#    .-AMT_GOODS_PRICE
#    .-edad
#    .-Antiguedad en el empleo
    
  
# vamos a plantear si existen diferencias significativas entre las variables comentadas a nivel Univariable con el Target

table(base$TARGET)
prop.table(table(base$TARGET))
# EL 8% DE LOS CREDITOS CONCEDIDOS SON IMPAGADOS#

##################################
#1.-Muestreo del conjunto de datos
##################################

#Muestra aleatoria Simple
#m.a.s de 5000 items

set.seed(5876)
baset <- data.table(base)
mas<-baset[sample(.N, 5000)]
table(mas$TARGET)
prop.table(table(mas$TARGET))



#muestreo estratificado para el nivel de educacion
table(base$NAME_EDUCATION_TYPE)
prop.table(table(base$NAME_EDUCATION_TYPE))


install.packages("stratified")
library(sampling)
sum(is.na(base$NAME_EDUCATION_TYPE))
#the method is 'srswor' (equal probability, without replacement)
strata.base=strata(base,c("NAME_EDUCATION_TYPE"),size=c(10,5,5,5,2), method="srswor",TRUE)
strata.base



############################################################
#2.- Proponer alguna características que se quiera estudiar.
############################################################

#1.-Cuanto es la media del importe de crédito solicitado
#2.-Cuanto es el ingreso medio de los clientes 
#3.-¿cual es la edad media del cliente que solicita?
#4.-¿cual es la media de la antigüedad en la empresa del cliente medio


############################################################
#3.-Estimacion Puntual de dicha característica 
############################################################



#Estimacion puntual de la media del importe de crédito solicitado

#importe solicitado del cliente Media Poblacion
media.importe=mean(base$AMT_CREDIT)
dt.importe=sd(base$AMT_CREDIT)
media.importe
dt.importe

#importe solcitado del cliente Media Muestral
media.importe_mas<-mean(mas$AMT_CREDIT)
dt.importe_mas<-sd(mas$AMT_CREDIT)
media.importe_mas
dt.importe_mas



#Estimacion puntual de la media de los ingresos del cliente

#ingresos del cliente Media Poblacion
media.ingresos=mean(base$AMT_INCOME_TOTAL)
media.ingresos

#ingresos del cliente Media Muestral
media.ingresos_msa<-mean(mas$AMT_INCOME_TOTAL)
media.ingresos_msa


#Estimacion puntual de la media de la edad de los clientes
#edad media poblacional 
dias=(base$DAYS_BIRTH*-1)/365.25
media.edad= mean (dias)
media.edad

#edad media muestral
dias_mas=(mas$DAYS_BIRTH*-1)/365.25
media.edad_mas= mean (dias_mas)
media.edad_mas



#Estimacion puntual de la media de la antiguedad en la empresa de los clientes
#antiguedad en la empresa poblacional
antg=(base$DAYS_EMPLOYED)/365.25
media.antg= mean (antg)
media.antg

#antiguedad en la empresa muestral
antg_mas=(mas$DAYS_EMPLOYED)/365.25
media.antg_mas= mean (antg_mas)
media.antg_mas





#DEFICINICION DE LOS 2 SUBSET 
#t1 impago
t1<-subset(base, TARGET=="1")
t1

#t0 pago
t0<-subset(base, TARGET=="0")
t0


######################################################################
# 4 intervalos de Hipotesis 
######################################################################




#######################################################################
#5 INTERVALOS DE CONFIANZA de toda la base de Datos para cada subpoblacion
#######################################################################



#ingresos del cliente TARGET 0
media.ingresos=mean(t0$AMT_INCOME_TOTAL)
media.ingresos
desviacion.ingresos=sd(t0$AMT_INCOME_TOTAL)
desviacion.ingresos

t0_ci=media.ingresos-qnorm(0.95)*desviacion.ingresos/sqrt(length(t0))
t0_cs=media.ingresos+qnorm(0.95)*desviacion.ingresos/sqrt(length(t0))
c(t0_ci,t0_cs)

#ingresos del cliente TARGET 1
media.ingresos=mean(t1$AMT_INCOME_TOTAL)
media.ingresos
desviacion.ingresos=sd(t1$AMT_INCOME_TOTAL)
desviacion.ingresos

t1_ci=media.ingresos-qnorm(0.95)*desviacion.ingresos/sqrt(length(t1))
t1_cs=media.ingresos+qnorm(0.95)*desviacion.ingresos/sqrt(length(t1))
c(t1_ci,t1_cs)





#importe medio de los clientes TARGET 0
media.importe=mean (t0$AMT_CREDIT)
media.importe
desviacion.importe=sd(t0$AMT_CREDIT)
desviacion.importe

t0_ci=media.importe-qnorm(0.95)*desviacion.importe/sqrt(length(t0))
t0_cs=media.importe+qnorm(0.95)*desviacion.importe/sqrt(length(t0))
c(t0_ci,t0_cs)

#importe medio de los clientes TARGET 1
media.importe=mean (t1$AMT_CREDIT)
media.importe
desviacion.importe=sd(t1$AMT_CREDIT)
desviacion.importe

t1_ci=media.importe-qnorm(0.95)*desviacion.importe/sqrt(length(t1))
t1_cs=media.importe+qnorm(0.95)*desviacion.importe/sqrt(length(t1))
c(t1_ci,t1_cs)




 
# edad de los clientes TARGET 0
dias=(t0$DAYS_BIRTH*-1)/365.25
media.edad= mean (dias)
media.edad
desviacion.edad=sd(dias)
desviacion.edad

t0_ci=media.edad-qnorm(0.95)*desviacion.edad/sqrt(length(t0))
t0_cs=media.edad+qnorm(0.95)*desviacion.edad/sqrt(length(t0))
c(t0_ci,t0_cs)


# edad de los clientes TARGET 1
dias=(t1$DAYS_BIRTH*-1)/365.25
media.edad= mean (dias)
media.edad
desviacion.edad=sd(dias)
desviacion.edad

t1_ci=media.edad-qnorm(0.95)*desviacion.edad/sqrt(length(t1))
t1_cs=media.edad+qnorm(0.95)*desviacion.edad/sqrt(length(t1))
c(t1_ci,t1_cs)






#antiguedad en la empresa TARGET 0
antg=(t0$DAYS_EMPLOYED)/365.25
media.antg= mean (antg)
media.antg
desviacion.antg=sd(antg)
desviacion.antg

t0_ci=media.antg-qnorm(0.95)*desviacion.antg/sqrt(length(t0))
t0_cs=media.antg+qnorm(0.95)*desviacion.antg/sqrt(length(t0))
c(t0_ci,t0_cs)


#antiguedad en la empresa TARGET 1
antg=(t1$DAYS_EMPLOYED)/365.25
media.antg= mean (antg)
media.antg
desviacion.antg=sd(antg)
desviacion.antg

t1_ci=media.antg-qnorm(0.95)*desviacion.antg/sqrt(length(t1))
t1_cs=media.antg+qnorm(0.95)*desviacion.antg/sqrt(length(t1))
c(t1_ci,t1_cs)




#####################################################################
### 6 Contrastes de hipótesis de independencia de las muestras
####################################################################

#muestra1 ---Target 0
#muestra2 ---Target 1

###analisis para Ingresos de la poblacion#####

Ho: Igualdad de Medias en Ingresos para la Poblacion T0 y T1
H1: No igualdad...

set.seed(5876)
test <- t.test(t0$AMT_INCOME_TOTAL,t1$AMT_INCOME_TOTAL) # Prueba t de Student
print(test)
# p-value es < 0.05 no podemos Rechazamos la Hipotesis Nula . El valor del estadístico t es muy pequeño
boxplot(t0$AMT_INCOME_TOTAL,t1$AMT_INCOME_TOTAL,names=c("t0","t1"))


#sin outliers parece que nos están mucho más próximos intuitivamente las medias#
##ESTUDIAR QUITAR LOS OUTLIER
boxplot(t0$AMT_INCOME_TOTAL,t1$AMT_INCOME_TOTAL,names=c("t0","t1"),outline=FALSE)
plot(t0$AMT_INCOME_TOTAL)
plot(t1$AMT_INCOME_TOTAL)


###analisis para importe medio de la poblacion#####

Ho: Igualdad de Medias en importe medio de credito solicitado para la Poblacion T0 y T1
H1: No igualdad...


set.seed(5876)
test <- t.test(t0$AMT_CREDIT,t1$AMT_CREDIT) # Prueba t de Student
print(test)
# p-value < 2.2e-16 RECHAZAR la Hipotesis Nula . El valor del estadístico t es muy pequeño
boxplot(t0$AMT_CREDIT,t1$AMT_CREDIT,names=c("t0","t1"))





###analisis para EDAD MEDIA de la poblacion#####

Ho: Igualdad de edad de los clientes que solicitan credito para la Poblacion T0 y T1
H1: No igualdad...


set.seed(5876)
dias_t0<-(t0$DAYS_BIRTH*-1)/365.25
dias_t1<-(t1$DAYS_BIRTH*-1)/365.25
test <- t.test(dias_t0,dias_t1) # Prueba t de Student
print(test)
# p-value < 2.2e-16  RECHAZAR la Hipotesis Nula . El valor del estadístico t es muy pequeño
boxplot(dias_t0,dias_t1,names=c("t0","t1"))




###analisis parala antiguedad en la empresa de la poblacion#####

Ho: Igualdad de edad de los clientes que solicitan credito para la Poblacion T0 y T1
H1: No igualdad...


set.seed(5876)
antg_t0<-(t0$DAYS_EMPLOYED)/365.25
antg_t1<-(t1$DAYS_EMPLOYED)/365.25
test <- t.test(antg_t0,antg_t1) # Prueba t de Student
print(test)
# p-value < 2.2e-16  RECHAZAR la Hipotesis Nula . El valor del estadístico t es muy pequeño
boxplot(dias_t0,dias_t1,names=c("t0","t1"))


##################################################################
### contrastes de hipotesis de Independencia
##################################################################
#-Existen diferencias significativas en el nivel de estudios entre los clientes que Pagan/Impagan
#-Existen diferencias significativas en la ocupación entre los clientes que Pagan/Impagan
#-Existen diferencias significativas en tipo de casa entre los clientes que Pagan/Impagan
#-Existen diferencias significativas en el estado civil entre los clientes que Pagan/Impagan
##############################################################


#### test chi2
#### Ho : Nivel de Estudios e Impago de Crédito son Independientes
#### H1 : existe dependencia

chisq.test(base$TARGET,base$NAME_EDUCATION_TYPE,correct=FALSE )
chisq.test(base$TARGET,base$NAME_EDUCATION_TYPE)$expected
mosaicplot(base$TARGET,base$NAME_EDUCATION_TYPE, color=TRUE, main="Plot de mosaico")

##Valor del estadistico X2 1019, y el p-value < 2.2e-16 . Rechazamos la Ho 
##PARA NUESTRA BASE No existe independencia entre el impago y el Nivel de estudios
## Vamos a sacar una distribucion de datos para ver en frecuencuias cuales son los estudios que más nos impagan
uno<-table (base$NAME_EDUCATION_TYPE,base$TARGET)
prop.table(uno,1)

###Intuitivamente vemos que Higher education  pagan mejor, y Lower secondary pagan peor







#### test chi2
#### Ho : Ocupacion e Impago de Crédito son Independientes
#### H1 : existe dependencia


chisq.test(base$TARGET,base$OCCUPATION_TYPE,correct=FALSE )

##Valor del estadistico X2 1975.1, muchos grados de Libertad debido a las muchas profesiones  y el p-value < 2.2e-16 . Rechazamos la Ho 
##PARA NUESTRA BASE No existe independencia entre el impago y la profesion
## Vamos a sacar una distribucion de datos para ver en frecuencias cuales son los estudios que más nos impagan
dos<-table (base$OCCUPATION_TYPE,base$TARGET)
prop.table(dos,1)


###Intuitivamente vemos que   Accountants  pagan mejor, y Low-skill Laborers , drivers ,Cooking staff aiters/barmen staff pagan mucho  peor






#### test chi2
#### Ho : tipo de casa e Impago de Crédito son Independientes
#### H1 : existe dependencia


chisq.test(base$TARGET,base$NAME_HOUSING_TYPE,correct=FALSE )

##Valor del estadistico X2 420.56, 5 grados de libertad  y el p-value < 2.2e-16 . Rechazamos la Ho 
##PARA NUESTRA BASE No existe independencia entre el impago y el tipo de casa
## Vamos a sacar una distribucion de datos para ver en frecuencias cuales son los estudios que más nos impagan
tres<-table (base$NAME_HOUSING_TYPE,base$TARGET)
prop.table(tres,1)


###Intuitivamente vemos que    House / apartment  pagan mejor, y   Rented apartment and with parents pagan mucho  peor







#### test chi2
#### Ho : estado civil e Impago de Crédito son Independientes
#### H1 : existe dependencia


chisq.test(base$TARGET,base$NAME_FAMILY_STATUS)

## mucho cuaido a tener en cuenta que nos advuierte que quizá no sea fiable el test de chi2 porque hay una categoria
##con Unknown apenan alimentada, que puede ser un error de la base de datos que nos puede dar pie a errores
## eliminamos esta categoria de la base de datos para este test

temporal <-subset(base, base$NAME_FAMILY_STATUS!="Unknown")
cuatro<-table (temporal$NAME_FAMILY_STATUS,temporal$TARGET)
cuatro
chisq.test(temporal$TARGET,temporal$NAME_FAMILY_STATUS)

##Valor del estadistico X2 504.52, 4 grados de libertad  y el p-value < 2.2e-16 . Rechazamos la Ho 
##PARA NUESTRA BASE No existe independencia entre el impago y el estado civil
## Vamos a sacar una distribucion de datos para ver en frecuencias cuales son los estudios que más nos impagan
prop.table(cuatro,1)


###Intuitivamente vemos que widow  pagan mejor, y Civil marriage pagan  peor 






#### test chi2
#### Ho : tipo de organizacion donde trabaja e Impago de Crédito son Independientes
#### H1 : existe dependencia


chisq.test(base$TARGET,base$ORGANIZATION_TYPE)

## mucho cuaido a tener en cuenta que nos advuierte que quizá no sea fiable el test de chi2 porque hay una categoria
##con Unknown apenan alimentada, que puede ser un error de la base de datos que nos puede dar pie a errores
## eliminamos esta categoria de la base de datos para este test

temporal <-subset(base, base$NAME_FAMILY_STATUS!="Unknown")
cinco<-table (temporal$ORGANIZATION_TYPE,temporal$TARGET)
cinco


##Valor del estadistico X2 1609.2 57 grados de libertad  y el p-value < 2.2e-16 . 
#a mayor grados de libertad aumenta el x2 y puede parecer que explica más Rechazamos la Ho 
##PARA NUESTRA BASE No existe independencia entre el impago y el la empresa donde trabaja el cliente
## Vamos a sacar una distribucion de datos para ver en frecuencias cuales son los estudios que más nos impagan
prop.table(cinco,1)


###Intuitivamente vemos que Trade: type 4 pagan mejor, y Transport: type 3 pagan  peor 




#########################################################################################
#########################################################################################
## 7  Contraste de hipótesis de normalidad para una de las muestras.
#########################################################################################
#########################################################################################

### Media del importe solicitado

library(normtest)
library(nortest) 


###Prueba de Anderson-Darling###
norm<-ad.test(base$AMT_CREDIT)
norm0<-ad.test(t0$AMT_CREDIT)
norm1<-ad.test(t1$AMT_CREDIT)

###Pruena de Lilliefors (Kolmogorov-Smirnov)###
lillie.test(base$AMT_CREDIT)
lillie.test(t0$AMT_CREDIT)
lillie.test(t1$AMT_CREDIT)





#librerias que vamos a utilizar en la practica#

install.packages("PASWR2")
install.packages("lattice")
install.packages("ggplot2")
install.packages("nortest")
install.packages("FAdist")
library (nortest)
library (PASWR2)
library (ggplot2)
library (lattice)
library (scales)
library (e1071)
library (FAdist)

datos <- BATTERY
datos

########################################################################################
######################Actividad 1#######################################################
########################################################################################


#1.1.histograma de los datos#
hist(datos$lifetime, main = expression("Histograma lifetime"),
     xlab = expression("Lifetime"*" ("*symbol("m")*mol/m^2*s*")"),
     col = "steelblue", border = "white", bg = "white", freq = FALSE)

#1.2. crea dos conjuntos de datos #
summary(datos)
datosA<-subset(datos, facility=="A")
datosB<-subset(datos, facility=="B")


datosA
datosB

summary(datosA)
summary(datosB)


ggplot(datos, aes(lifetime)) +
  geom_histogram(fill="white", colour="black") +
  ggtitle('Histograma del valor lifetime')


ggplot(datos, aes(lifetime, fill =facility)) +
  geom_histogram()  +
  ggtitle('Histograma del valor lifetime')



#1.3 Realiza un histogram de cada uno de los subset y analizar su distribuc�n Normal#
hist(datosA$lifetime, main = expression("Histograma lifetime poblaci�n A"),
     xlab = expression("Lifetime"*" ("*symbol("m")*mol/m^2*s*")"),
     col = "steelblue", border = "white", bg = "white", freq = FALSE  )
curve(dnorm(x, mean(datosA$lifetime), sd(datosA$lifetime)), add = TRUE, lwd = 3, lty = 3)
qqnorm(datosA$lifetime, pch = 20, col = alpha("red4", 0.5), las = 1)
grid()
qqline(datosA$lifetime, lwd = 2)




hist(datosB$lifetime, main = expression("Histograma lifetime pobaci�n B"),
     xlab = expression("Lifetime"*" ("*symbol("m")*mol/m^2*s*")"),
     col = "RED", border = "white", bg = "white", freq = FALSE)
curve(dnorm(x, mean(datosB$lifetime), sd(datosB$lifetime)), add = TRUE, lwd = 2, lty = 2)

qqnorm(datosB$lifetime, pch = 20, col = alpha("red4", 0.5), las = 1)
grid()
qqline(datosB$lifetime, lwd = 2)


#CONTRASTES DE NORMALIDAD#

shapiro.test(datosA$lifetime)
shapiro.test(datosB$lifetime)

#OTROS CONTRASTES DE NORMALIDAD#

#Anderson-Darling#
ad.test(datosA$lifetime)
ad.test(datosB$lifetime)

#Cramer-von Mises normality test#
cvm.test(datosA$lifetime)
cvm.test(datosB$lifetime)

#Lilliefors (Kolmogorov-Smirnov) normality test#
lillie.test(datosA$lifetime)
lillie.test(datosA$lifetime)

#Pearson chi-square normality test#
pearson.test(datosA$lifetime)
pearson.test(datosB$lifetime)

#Shapiro-Francia normality test#
sf.test(datosA$lifetime)
sf.test(datosB$lifetime)

#########################################################################################
#actividad   2         ##################################################################
#########################################################################################

#2.1 Realiza una estimaci�n puntual de la media y la desviaci�n t�pica de la
#poblaci�n de cada tipo de bater�as#

mean_A<-mean(datosA$lifetime, na.rm = TRUE)
std_A <-sd(datosA$lifetime, na.rm = TRUE)
summary (datosA$lifetime)
kurtosis(datosA$lifetime)

mean_B<-mean(datosB$lifetime, na.rm = TRUE)
std_B <-sd(datosB$lifetime, na.rm = TRUE)
summary (datosA$lifetime)
kurtosis(datosB$lifetime)



#2.2 Calcula la probabilidad de que una bater�a tomada al azar del tipo A dure m�s de 210 horas#

#para la poblacion A#
pnorm(q = 210, mean = mean_A, sd = std_A, lower.tail = FALSE)

#para la poblacion B#
pnorm(q = 210, mean = mean_B, sd = std_B, lower.tail = FALSE)



#2.3 Calcula la probabilidad de que una bater�a tomada al azar del tipo B dure menos de 175 horas#

#para la poblacion B#
1-pnorm(q = 175, mean = mean_A, sd = std_A, lower.tail = FALSE)

#2.4 Encuentra cu�l es la duraci�n m�xima del 3% de las pilas del tipo B que duran menos (ayuda: esto es#
#equivalente a encontrar el cuantil 0.03 de la distribuci�n)#

qnorm(0.9,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.8,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.7,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.6,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.5,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.4,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.3,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.2,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.1,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.05,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)
qnorm(0.03,mean = mean_B, sd = std_B, lower.tail = TRUE, log.p = FALSE)




#########################################################################################
#actividad3##############################################################################
#########################################################################################

#PUNTO DE CORTE 175 HORAS DE VIDA#DISTRIBUCION BINOMIAL#
#3.1 Calcula la probabilidad de que en un lote de 10 bater�as, no haya ninguna defectuosa (ayuda: distribuci�n binomial).#
#HAY QUE CALCULAR LA PROBABILIDAD DE QUE SEA MENOR A 175 HORAS EN LA POBLACION B#
#para la poblacion B#
1-pnorm(q = 175, mean = mean_B, sd = std_B, lower.tail = FALSE)
pnorm(q = 175, mean = mean_B, sd = std_B, lower.tail = TRUE)

dbinom(0, size=10, prob=0.9810957)


#3.2. Imagina que las bater�as se fabrican en serie e independientemente. �Cu�l es la probabilidad de que la#
#bater�a producida en quinto lugar sea la primera defectuosa? (ayuda: distribuci�n geom�trica.)#
#Distribuci�n Geom�trica
#Definici�n
#X: N�mero de fracasos hasta obtener el primer �xito en una serie de pruebas
#independientes de Bernoulli con probabilidad de �xito p


1-pnorm(q = 175, mean = mean_B, sd = std_B, lower.tail = TRUE)
pgeom(q = 5, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 1, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 2, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 3, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 4, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 5, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 6, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 7, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 8, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 9, prob = 0.01890433, lower.tail = TRUE)
pgeom(q = 10, prob = 0.01890433, lower.tail = TRUE)


#3.3.  � Supongamos que en una caja de 20 bater�as van 3 defectuosas. �Cu�l es la probabilidad de que al
#tomar una muestra sin reposici�n de 5 bater�as al menos una sea defectuosa? (ayuda: distribuci�n
#                                                                             hipergeom�trica)

#P=3/20--0.15
dhyper(x = 1, m = 3, k = 5, n = 20-3)




#######################################################################################
#actividad 4  ###########################################################################
#########################################################################################

# 4.1 �Cu�l es la probabilidad de que un d�a se produzcan m�s de 20 bater�as defectuosas?#

1-ppois(q = 20, lambda = 12)



# 4.2 �Cu�l es la probabilidad de que un d�a no salga ninguna bater�a defectuosa de la f�brica?

ppois(q = 0, lambda = 12)


# 4.3 La f�brica funciona de lunes a viernes. �Qu� distribuci�n sigue el n�mero de bater�as defectuosas por
#semana? Justifica qu� propiedad se aplica

#a priori sigue una distribuci�n de Poisson, pero hay que darle una vuelta por si es pregunta trampa





#########################################################################################
#actividad 5  ###########################################################################
#########################################################################################

# 5.1 distribuci�n de Weibull con par�metros a = 100 y b = 185#
#Realiza una simulaci�n de la producci�n semanal de bater�as (recuerda: 5 d�as de produccci�n, a 1000
#bater�as por d�a). Guarda los datos en un vector. We(a, b)

#pide una simulacion en un vector#

#los parametros a y b de una Weibull
simulacion
simulacion <-rweibull(1000, 100, 185)
simulacion_semanal<- c(rweibull(1000, 100, 185),rweibull(1000, 100, 185),rweibull(1000, 100, 185),
                       rweibull(1000, 100, 185),rweibull(1000, 100, 185))
simulacion_semanal


media_simulacion_semanal<-mean (simulacion_semanal)
media_simulacion_semanal


rweibull(n, shape, scale = 1, alpha = shape, beta = scale)


#####5.2 Con este nuevo proceso, �se mejora realmente la duraci�n media de las bater�as?
##### (ayuda: puedes usar los datos simulados o la expresi�n de la esperanza de una Weibull)

#la media es 183.9266 y la de la poblaci�n datos B es 179.6805 .Todo perfecto
#La vida media de las baterias es muy superior a la de los datos B 183 horas sobre 179



### 5.3 � Los ingenieros no lo tienen muy claro (parece que la diferencia no es tanta en promedio y los nuevos
#materiales son costosos). Para demostrarles que merece la pena, calcula la proporci�n de bater�as
#defectuosas que producir� probablemente el nuevo proceso y comp�rala con el anterior (la p que
#                                                                                      calculamos en la actividad 2)



#en una semana de trabajo
#CONDICIONES PREVIAS PARA EL CALCULO DE LA PROPORCION DE BATERIAS DEFECTUOSAS EN LOS 2 PROCESOS

#�ESTAS SON LAS DEFECTUOSAS?
#Calcula la probabilidad de que una bater�a tomada al azar del tipo B dure menos de 175 horas

#para la poblacion B#
pb<-1-pnorm(q = 175, mean = mean_B, sd = std_B, lower.tail = FALSE)
defectuosas<-1000*pb
defectuosas
#Para la nueva poblaci�n#
pn<-pweibull(175,100, 185)
defectuosas_new<-1000*pn
defectuosas
defectuosas_new


#entendemos que en una poblaci�n de 1000 unidades fabricas con el nuevo proceso obtendremos en media 3.8 
#unidades defectuosas y con el proceso anterior 12.22 unidades defectuosas
#siempre considerando que llamamos defectuosa a aquella bateria cuya esperanza media de vida es inferior a 175 horas





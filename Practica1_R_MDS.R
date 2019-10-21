

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


#1.3 Realiza un histogram de cada uno de los subset y analizar su distribucón Normal#
hist(datosA$lifetime, main = expression("Histograma lifetime población A"),
     xlab = expression("Lifetime"*" ("*symbol("m")*mol/m^2*s*")"),
     col = "steelblue", border = "white", bg = "white", freq = FALSE  )
curve(dnorm(x, mean(datosA$lifetime), sd(datosA$lifetime)), add = TRUE, lwd = 3, lty = 3)
qqnorm(datosA$lifetime, pch = 20, col = alpha("red4", 0.5), las = 1)
grid()
qqline(datosA$lifetime, lwd = 2)



hist(datosB$lifetime, main = expression("Histograma lifetime pobación B"),
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

#2.1 Realiza una estimación puntual de la media y la desviación típica de la
#población de cada tipo de baterías#

mean(datosA$lifetime, na.rm = TRUE)
sd(datosA$lifetime, na.rm = TRUE)
summary (datosA$lifetime)
kurtosis(datosA$lifetime)

mean(datosB$lifetime, na.rm = TRUE)
sd(datosB$lifetime, na.rm = TRUE)
summary (datosA$lifetime)
kurtosis(datosB$lifetime)



#2.2 Calcula la probabilidad de que una batería tomada al azar del tipo A dure más de 210 horas#

#para la poblacion A#
pnorm(q = 210, mean = 200.5, sd = 2.75, lower.tail = FALSE)

#para la poblacion B#
pnorm(q = 210, mean = 179.68, sd = 2.08, lower.tail = FALSE)



#2.3 Calcula la probabilidad de que una batería tomada al azar del tipo B dure menos de 175 horas#

#para la poblacion B#
1-pnorm(q = 175, mean = 179.68, sd = 2.08, lower.tail = FALSE)

#2.4 Encuentra cuál es la duración máxima del 3% de las pilas del tipo B que duran menos (ayuda: esto es#
#equivalente a encontrar el cuantil 0.03 de la distribución)#

qnorm(0.9,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.8,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.7,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.6,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.5,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.4,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.3,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.2,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.1,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.05,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)
qnorm(0.03,mean = 179.68, sd = 2.08, lower.tail = TRUE, log.p = FALSE)




#########################################################################################
#actividad3##############################################################################
#########################################################################################

#PUNTO DE CORTE 175 HORAS DE VIDA#DISTRIBUCION BINOMIAL#
#3.1 Calcula la probabilidad de que en un lote de 10 baterías, no haya ninguna defectuosa (ayuda: distribución binomial).#
#HAY QUE CALCULAR LA PROBABILIDAD DE QUE SEA MENOR A 175 HORAS EN LA POBLACION B#
#para la poblacion B#
1-pnorm(q = 175, mean = 170.68, sd = 2.08, lower.tail = FALSE)
pnorm(q = 175, mean = 170.68, sd = 2.08, lower.tail = TRUE)

dbinom(0, size=10, prob=0.9810957)


#3.2. Imagina que las baterías se fabrican en serie e independientemente. ¿Cuál es la probabilidad de que la#
#batería producida en quinto lugar sea la primera defectuosa? (ayuda: distribución geométrica.)#
#Distribución Geométrica
#Definición
#X: Número de fracasos hasta obtener el primer éxito en una serie de pruebas
#independientes de Bernoulli con probabilidad de éxito p


1-pnorm(q = 175, mean = 170.68, sd = 2.08, lower.tail = TRUE)
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


#3.3.  • Supongamos que en una caja de 20 baterías van 3 defectuosas. ¿Cuál es la probabilidad de que al
#tomar una muestra sin reposición de 5 baterías al menos una sea defectuosa? (ayuda: distribución
#                                                                             hipergeométrica)

#P=3/20--0.15
dhyper(x = 1, m = 3, k = 5, n = 20-3)




#######################################################################################
#actividad 4  ###########################################################################
#########################################################################################

# 4.1 ¿Cuál es la probabilidad de que un día se produzcan más de 20 baterías defectuosas?#

1-ppois(q = 20, lambda = 12)



# 4.2 ¿Cuál es la probabilidad de que un día no salga ninguna batería defectuosa de la fábrica?

ppois(q = 0, lambda = 12)


# 4.3 La fábrica funciona de lunes a viernes. ¿Qué distribución sigue el número de baterías defectuosas por
#semana? Justifica qué propiedad se aplica

#a priori sigue una distribución de Poisson, pero hay que darle una vuelta por si es pregunta trampa





#########################################################################################
#actividad 5  ###########################################################################
#########################################################################################

# 5.1 distribución de Weibull con parámetros a = 100 y b = 185#
#Realiza una simulación de la producción semanal de baterías (recuerda: 5 días de produccción, a 1000
#baterías por día). Guarda los datos en un vector. We(a, b)

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


#####5.2 Con este nuevo proceso, ¿se mejora realmente la duración media de las baterías?
##### (ayuda: puedes usar los datos simulados o la expresión de la esperanza de una Weibull)

#la media es 183.9266 y la de la población datos B es 179.6805 .Todo perfecto
#La vida media de las baterias es muy superior a la de los datos B 183 horas sobre 179



### 5.3 • Los ingenieros no lo tienen muy claro (parece que la diferencia no es tanta en promedio y los nuevos
#materiales son costosos). Para demostrarles que merece la pena, calcula la proporción de baterías
#defectuosas que producirá probablemente el nuevo proceso y compárala con el anterior (la p que
#                                                                                      calculamos en la actividad 2)



#en una semana de trabajo
#CONDICIONES PREVIAS PARA EL CALCULO DE LA PROPORCION DE BATERIAS DEFECTUOSAS EN LOS 2 PROCESOS

#¿ESTAS SON LAS DEFECTUOSAS?
#Calcula la probabilidad de que una batería tomada al azar del tipo B dure menos de 175 horas

#para la poblacion B#
pb<-1-pnorm(q = 175, mean = 179.68, sd = 2.08, lower.tail = FALSE)
defectuosas<-1000*pb
defectuosas
#Para la nueva población#
pn<-pweibull(175,100, 185)
defectuosas_new<-1000*pn
defectuosas
defectuosas_new


#entendemos que en una población de 1000 unidades fabricas con el nuevo proceso obtendremos en media 3.8 
#unidades defectuosas y con el proceso anterior 12.22 unidades defectuosas
#siempre considerando que llamamos defectuosa a aquella bateria cuya esperanza media de vida es inferior a 175 horas





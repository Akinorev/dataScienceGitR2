

hap15 <-read.csv(file="C:/Users/Pablo/Desktop/Master/Practica_Inferencia/2015.csv", header=TRUE,sep=",")
hap16 <-read.csv(file="C:/Users/Pablo/Desktop/Master/Practica_Inferencia/2015.csv", header=TRUE,sep=",")
hap17 <-read.csv(file="C:/Users/Pablo/Desktop/Master/Practica_Inferencia/2015.csv", header=TRUE,sep=",")


hap15
hap16
hap17

summary(hap15)
summary(hap16)
summary(hap17)

names(hap15)
names(hap16)
names(hap17)

#rename de los datos#

names(hap15)[names(hap15) == "Happiness.Rank"] <- "Happiness.Rank15"
names(hap15)[names(hap15) == "Happiness.Score"] <- "Happiness.Score15"
names(hap15)[names(hap15) == "Standard.Error"] <- "Standard.Error15"
names(hap15)[names(hap15) == "Economy..GDP.per.Capita."] <- "Economy..GDP.per.Capita.15"
names(hap15)[names(hap15) == "Family"] <- "Family15"
names(hap15)[names(hap15) == "Health..Life.Expectancy."] <- "Health..Life.Expectancy.15"
names(hap15)[names(hap15) == "Freedom"] <- "Freedom15"
names(hap15)[names(hap15) == "Trust..Government.Corruption."] <- "Trust..Government.Corruption.15"
names(hap15)[names(hap15) == "Generosity"] <- "Generosity15"
names(hap15)[names(hap15) == "Dystopia.Residual"] <- "Dystopia.Residual15"
names(hap15)



names(hap16)[names(hap16) == "Happiness.Rank"] <- "Happiness.Rank16"
names(hap16)[names(hap16) == "Happiness.Score"] <- "Happiness.Score16"
names(hap16)[names(hap16) == "Standard.Error"] <- "Standard.Error16"
names(hap16)[names(hap16) == "Economy..GDP.per.Capita."] <- "Economy..GDP.per.Capita.16"
names(hap16)[names(hap16) == "Family"] <- "Family16"
names(hap16)[names(hap16) == "Health..Life.Expectancy."] <- "Health..Life.Expectancy.16"
names(hap16)[names(hap16) == "Freedom"] <- "Freedom16"
names(hap16)[names(hap16) == "Trust..Government.Corruption."] <- "Trust..Government.Corruption.16"
names(hap16)[names(hap16) == "Generosity"] <- "Generosity16"
names(hap16)[names(hap16) == "Dystopia.Residual"] <- "Dystopia.Residual16"
names(hap16)



names(hap17)[names(hap17) == "Happiness.Rank"] <- "Happiness.Rank17"
names(hap17)[names(hap17) == "Happiness.Score"] <- "Happiness.Score17"
names(hap17)[names(hap17) == "Standard.Error"] <- "Standard.Error17"
names(hap17)[names(hap17) == "Economy..GDP.per.Capita."] <- "Economy..GDP.per.Capita.17"
names(hap17)[names(hap17) == "Family"] <- "Family17"
names(hap17)[names(hap17) == "Health..Life.Expectancy."] <- "Health..Life.Expectancy.17"
names(hap17)[names(hap17) == "Freedom"] <- "Freedom17"
names(hap17)[names(hap17) == "Trust..Government.Corruption."] <- "Trust..Government.Corruption.17"
names(hap17)[names(hap17) == "Generosity"] <- "Generosity17"
names(hap17)[names(hap17) == "Dystopia.Residual"] <- "Dystopia.Residual17"
names(hap17)


#3 join set de las 3 bases de datos##


df1<-merge(x=hap15,y=hap16 ,by = c("Country","Region"),all=TRUE)
df2<-merge(x=df1,y=hap17   ,by = c("Country","Region"),all=TRUE)


summary (df2)

boxplot(Happiness.Score17 ~ Region, data = df2, ylab = "Happiness.Score17", xlab = "Region")




#    hemos unido las tres bases de datos a nivel Country y a nivel Region
#    hemos renombrado las variables a su anyo


# 1.  -Primer punto realizar un muestreo de la base de Datos #
# 1.1.-Muestreo aleatorio Simple sin repeticion de 50 
  
index      <- sample( 1:nrow( df2 ), 50 )
df2.random <- df2[ index, ]
df2.random


# TODO Contrastamos la validad de la variable Happiness_Score117 para La Base y la mas 


# 1.2.-Muestreo estratificado por Region
library( sampling )
ma_estraificado <- strata( df2, stratanames = c("Region"), size = c(20,20,20), method = "systematic" )
summary (df2$Region)

ma_estraificado <- strata( df2, stratanames = c("Region"), size= c() method = "systematic")



##2Proponer alguna características que se quiera estudiar.
#  .-Ideas 
#    1.-Queremos estudiar si existen diferencias entre el HappineS_Score
#       por Region para los años 15,16y 17
#       ¿EXISTEN DIFERENCIAS SIGNIFICATIVAS EN LAS MEDIAS DE LAS REGIONES?
#       ¿LO HACEMOS PARA PAÍSES EN CONCRETO ? MEDIA DEL TOP5 UP AND DOWN?
    
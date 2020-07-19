# Que se necesita para la migración AWS

## Tienda online se divide en los siguientes servicios

### Necesidades para un e-commerce

* Que los servidores estén siempre funcionando (un servidor inactivo = perder dinero)
* Sistema escalable que pueda crecer en función de la época del año (es posible que se hagan más ventas en navidad)
* Sistema de backup que la base de datos esté protegida en caso de fallo
* Que sea ampliable, que se puedan incluir nuevos servicios de monitorización del entorno
* Pagar solo por el consumo, hay que evitar pagar lo mismo cada mes, ya que los sistemas no siempre tendrán la misma carga
* Que sea seguro, las transacciones deben mantenerse en privado y garantizar la seguridad del usuario y los propios sistemas.

### Base de datos

#### Instacias de las bbdd

El proyecto debe contar con al menos dos bbdd (Si bien no tenemos estimaciones exactas de como de conocida es la plataforma y como será su demanda).

Cogiendo como ejemplo Aurora MySQL

Así que al menos necesitaremos 2 nodos.

Tipo de máquina elegida:

db.r5.large
(CPU:2 Memory: 16GB Network Performance: up to 10 Gb)

Instance family: memory optimized

Pricing model: OnDemand

Result:

0.58 USD x 730 hours in a month = 423.40 USD
Amazon Aurora MySQL Compatible cost (monthly): 423.40 USD

#### Almacenamiento

Si entendemos que colocar un producto en el carrito es ya una petición a la base de datos, tanto de bloqueo de item como de liberación si se opta por no comprar.

Al ser una tienda conocida (pero no tenemos estos datos) solo podemos hacer una estimación.

Para nuestra simulación entendemos que se hacen de media unos 2 millones de peticiones al mes.

Hay que tener en cuenta también que los compradores indecisos que hacen y deshacen el carrito a su vez generan peticiones.

Entendemos que es una tienda grande, por lo que tendrá un buen inventario. También debemos guardar un histórico por motivos legales de las transacciones, usuarios y demaáades que tiene un e-commerce.

Nuestro storage es de 2TB y el número aproximado de I/O al mes es de 2Millones. Los dos millones de I/O se toma de la siguiente estimación, 5000 usuarios al día * 7 peticiones I/O * 30 dias de mes = 1.050.000 aprox

En el caso de AWS el número mínimo de peticiones I/O que acepta al mes es de 1.000.000 por lo que no se pueden hacer las estimaciones para 1.000 usuarios.

Unit conversions
Storage amount: 2 TB x 1024 GB in a TB = 2048 GB
Pricing calculations
2,048 GB x 0.10 USD = 204.80 USD (Database Storage Cost)
2 x 1000000 multiplier for million x 0.0000002 USD = 0.40 USD (I/O Rate Cost)
204.80 USD + 0.40 USD = 205.20 USD
Total Storage Cost (monthly): 205.20 USD

#### Backup storage

Vamos a guardar los 2TB ya que en nuestro caso no podemos perder transacciones. Esto podría generar dobles cobros o productos gratis, que a cierto nivel puede repercutir en malas opiniones dañando la imagen de la empresa

Unit conversions
Additional backup storage: 2 TB x 1024 GB in a TB = 2048 GB
Pricing calculations
2,048 GB x 0.021 USD = 43.01 USD
Additional backup storage cost (monthly): 43.01 USD


#### Backtrack

Por si acaso incluiremos servicio de backtrack, así en caso de que haya una caída de los servidores podemos revertir el estado recuperando al menos los datos de la última hora.

El servicio no es muy caro y en caso de necesidad puede salvarnos de las perdidas que se obtendrían en caso de no tenerlo.

Unit conversions
Average statements: 100 per second * (60 seconds in a minute x 60 minutes in an hour x 730 hours in a month) = 262800000 per month
Pricing calculations
262,800,000 average statements x 0.38 change records x 1 hours x 0.000000012 USD = 1.20 USD (Backtrack cost)
Backtrack cost (monthly): 1.20 USD

#### Costes totales

#####Amazon Aurora MySQL-Compatible estimate

Amazon Aurora MySQL Compatible cost (monthly)
423.40 USD
Additional backup storage cost (monthly)
43.01 USD
Total Storage Cost (monthly)
205.20 USD
Backtrack cost (monthly)
1.20 USD
Total monthly cost:
672.81 USD

### Servidores web

#### DNS Amazon Route 53
Como estamos migrando todo eso incluye nuestros servicios web. Entre ellos un DNS, tanto para la intraweb que se pueda tener (para la parte de logística, información de la empresa... etc) como para la venta de cara al exterior.

Entre hosting hacia el exterior como interno, entendemos que aproximadamente tendremos mínimo 1 hosting.

Y hemos elegido Geo DNS queries ya que queremos ofrecer el mejor servicio web independientemente de donde este nuestro usuario. Ya que Tajo ofrece servicio en todo el mundo.

Tiered price for: 1
1 x 0.5000000000 USD = 0.50 USD
Total tier cost = 0.50 USD (Hosted Zone cost)
1 policy record per month x 50.00 USD = 50.00 USD (Traffic Flow cost)
5 million queries x 1000000 multiplier for million = 5,000,000.00 billable Geo DNS queries
Tiered price for: 5000000.00 Geo DNS queries
5000000 Geo DNS queries x 0.0000007000 USD = 3.50 USD
Total tier cost = 3.50 USD (Geo DNS queries cost)
0.50 USD + 50.00 USD + 3.50 USD = 54.00 USD
Route53 Hosted Zone cost (monthly): 54.00 USD

Como e-commerce que somos, una parte importante son los Health Checks. Para ello nos aseguramos de que nuestro sistema funcione de la forma adecuada. Calculamos una media de 15 pruebas mensuales de cada tipo para comprobar que todo está bien.

Tiered price for: 5 Basic Checks (AWS)
5 Basic Checks (AWS) x 0.0000000000 USD = 0.00 USD
Total tier cost = 0.00 USD (Basic Checks cost (AWS))
15 Basic Checks (non-AWS) x 0.75 USD = 11.25 USD (Basic Checks cost (non-AWS))
15 HTTPS Checks (AWS) x 1.00 USD = 15.00 USD (HTTPS Checks cost (AWS))
15 HTTPS Checks (non-AWS) x 2.00 USD = 30.00 USD (HTTPS Checks cost (non-AWS))
15 String Matching (AWS) x 1.00 USD = 15.00 USD (String Matching Checks cost (AWS))
15 String Matching Checks (non-AWS) x 2.00 USD = 30.00 USD (String Matching Checks cost (non-AWS))
15 Fast Interval (AWS) x 1.00 USD = 15.00 USD (Fast Interval Checks cost (AWS))
15 Fast Interval Checks (non-AWS) x 2.00 USD = 30.00 USD (Fast Interval Checks cost (non-AWS))
15 Latency Measurement Checks(AWS) x 1.00 USD = 15.00 USD (Latency Measurement Checks cost (AWS))
15 Latency Measurement Checks (non-AWS) x 2.00 USD = 30.00 USD (Latency Measurement Checks cost (non-AWS))
11.25 USD + 15.00 USD + 30.00 USD + 15.00 USD + 30.00 USD + 15.00 USD + 30.00 USD + 15.00 USD + 30.00 USD = 191.25 USD
Route53 DNS Failover Health Checks cost (monthly): 191.25 USD

Finalmente Amazon, nos exige un mínimo de 2 Elastic Network interfaces e indicamos que se harán aproximadamente unos 3 millones de queries al mes. Unos seran de clientes y otros de empleados.

2 ENI x 0.125 USD x 730 hours in a month = 182.50 USD (Cost for ENI)
3 million queries x 1000000 multiplier for million = 3,000,000.00 billable DNS resolver queries
Tiered price for: 3000000.00
3000000 x 0.0000004000 USD = 1.20 USD
Total tier cost = 1.20 USD (Cost for DNS queries)
182.50 USD + 1.20 USD = 183.70 USD
Route53 Resolver cost (monthly): 183.70 USD

#### Coste total

##### Amazon Route 53

Route53 Hosted Zone cost (monthly)
54.00 USD
Route53 DNS Failover Health Checks cost (monthly)
191.25 USD
Route53 Resolver cost (monthly)
183.70 USD
Total monthly cost:
428.95 USD


## Estimations can be found on:
https://calculator.aws/#/estimate?id=2325fdedc9fbc4026cba71316d915b1e039329d3


#### WEB

Para la web lo ideal seria usar Amazon CloudFront, ya que soporta https. Este servicio a su vez contiene lo siguiente:

* AWS Shield para mitigacion de ataques DDoS
* Amazon S3
* Elastic Load Balancing o Amazon EC2

Los costes estimados son una media. Hay que tener en cuenta que en los e-commerce tienen picos de ventas como podría ser el blackfriday o la época de Navidades.

Debido a que nuestra compañía esta en EEUU (fundada por españoles expatriados) la mayoría de las ventas las encontramos allí.

Aun así también hace ventas al extranjero. Los ultimos análisis establecieron el siguiente volumen de ventas:

United States 50%
Canada 5%
Europe & Israel 15%
Hong Kong, Philippines, S. Korea, Singapore & Taiwan 10%
South America 10%
South Africa 5%
Middle East 5%

Data Transfer:
   Data Transfer Out: 7 GB/Week
   Data Transfer Out to Origin: 7 GB/Week
Requests:
   Average Object Size: 20KB
Type of Requests:
	HTTPS
    Field Level Encryption for HTTPS Requests: 3000000 Requests
    Invalidation Requests: 100000 Requests

##### Coste total CloudFront
    Amazon CloudFront Service: $507.03
        Data Transfer Out: $2.91
        Data Transfer Out to Origin:$1.22
        Requests: $1.90
        Field Level Encryptions for HTTPS Requests: $6.00
        Invalidations: $495.00

    AWS Support (Basic) $0.00
    Free Tier Discount: $-4.81
    Total Monthly Payment: $502.22



### Generacion de informes

#### Cluster Hadoop Baja frecuencia

Para esta funcionalidad se elige el servicio de Elastic Map Reduce. Se utilizará para calcular el coste de generar los informes diarios y mensuales.

Las condiciones necesarias para nuestro EMR son los siguientes:

- Generar informes básicos de ventas dos veces al día
- Generar un informe completo una vez al mes
- Escenario 1 = 1.000 usuarios
- Escenario 2 = 5.000 usuarios
- Envío de informes a servidores
- Guardado como copia de seguridad

Los requisitos del sistema son:

1. Memoria estimada de procesamiento
2. Instancias para la puesta en marcha del cluster Hadoop
3. Número de instancias del cluster
4. Uso mensual
5. Almacenamiento de informes
6. Copia de seguridad de los informes

##### La memoria estimada de procesamiento

Tabla con los precios del espacio minimo estimado para el correcto dimensionamiento del cluster EMR

|   Escenario    | Tipo de informe | Información media por usuario | Espacio en memoria |
| :------------: | :-------------: | :---------------------------: | :----------------: |
| 1.000 usuarios |     Diario      |              2MB              |        2 GB        |
| 1.000 usuarios |     Mensual     |             10 MB             |       10 GB        |
| 5.000 usuarios |     Diario      |             2 MB              |       10 GB        |
| 5.000 usuarios |     Mensual     |             10 MB             |       50 GB        |

##### Instancias necesarias

Para este caso vamos a usar las instancias R de amazon optimizadas para memoria ya que se diseñaron con el objetivo de brindar un rendimiento rápido para las cargas de trabajo que procesan grandes conjuntos de datos en la memoria.

Los casos de uso de las instancias R son por lo general aplicaciones de memoria intensiva como bases de datos de código abierto, cachés en memoria y análisis de big data en tiempo real

Dentro de la gama R seleccionaremos las R4 por relación precio-rendimiento, están pensadas para aplicaciones de uso intensivo de memoria y ofrecen un precio mejor por GiB de RAM que las instancias R3.

Características de las R4:

- Procesadores Intel Xeon E5-2686 v4 (Broadwell) de alta frecuencia
- Memoria DDR4
- Soporte para redes mejoradas

|   Escenario    | Tipo instancia | CPU virtual | Memoria (GIB) | Almacenamiento instancia | Ancho banda red |
| :------------: | :------------: | :---------: | :-----------: | :----------------------: | :-------------: |
| 1.000 usuarios |    r4.large    |      2      |      16       |         Solo EBS         |    Hasta 10     |
| 5.000 usuarios |   r4.xlarge    |      4      |     30.5      |         Solo EBS         |    Hasta 10     |

##### Número de instancias necesarias

Dado que no conocemos muchos datos del proyecto comenzaremos con un cluster base y posteriormente usaremos la herramienta de Auto-scaling para generar un rango de instancias. Además debemos contar con que AWS Auto Sacling es totalmente gratuito

|   Escenario    |    Operación    | Tipo instancia | Min. instancias | Memoria total (GB) |
| :------------: | :-------------: | :------------: | :-------------: | :----------------: |
| 1.000 usuarios | Informe diario  |    r4.large    |        1        |         16         |
| 1.000 usuarios | Informe mensual |    r4.large    |        1        |         16         |
| 5.000 usuarios | Informe diario  |    r4.large    |        1        |         16         |
| 5.000 usuarios | Informe mensual |   r4.xlarge    |        2        |         61         |

##### Uso mensual

Para hacerlo sencillo suponemos que un mes tiene 30 días, y que el tiempo necesario para eliminar un informe diario con los clusters en ejecución es de 2 horas, mientras que para el informe mensual es de 3 horas

|   Escenario    |    Tipo de informe    | Tiempo de procesado | Horas al día | Horas al mes |
| :------------: | :-------------------: | :-----------------: | :----------: | :----------: |
| 1.000 usuarios | Diario mañana y tarde |     1 h/informe     |      2       |      60      |
| 1.000 usuarios |        Mensual        |     4 h/informe     |      -       |      4       |
| 5.000 usuarios | Diario mañana y tarde |     2 h/informe     |      4       |     120      |
| 5.000 usuarios |        Mensual        |     6 h/informe     |      -       |      4       |

##### Almacenamiento de los informes en S3

Una vez generados los informes se almacenan en un bucket S3 generado exlusivamente para el almacenamiento temporal de éstos. Asumimos que el guardado temporal de los informes es mensual.

|   Escenario    | Espacio por informe | Informes mensuales | Tiempo de guardado | Espacio necesario |
| :------------: | :-----------------: | :----------------: | :----------------: | :---------------: |
| 1.000 usuarios |       500 Kb        |         61         |      mensual       |      0,26 GB      |
| 5.000 usuarios |        1 Mb         |         61         |      mensual       |      0,56 GB      |

#### Estimacion de costes de EMR

##### Estimacion de costes por servicio

**Amazon EMR**

|   Escenario    | Informe | Tipo de instancia | Uso horas/mes | Número instancias | USD hora | Coste estimado |
| :------------: | ------- | ----------------- | :-----------: | :---------------: | :------: | :------------: |
| 1.000 usuarios | diario  | r4.large          |      60       |         1         |  0.167   |    10,02 $     |
| 1.000 usuarios | mensual | r4.large          |       4       |         1         |  0.167   |     0,67 $     |
| 5.000 usuarios | diario  | r4.large          |      120      |         1         |  0.167   |    20,04 $     |
| 5.000 usuarios | mensual | r4.xlarge         |       4       |         2         |  0.333   |     1,33 $     |

**Amazon S3**

|   Escenario    |  Servicio  | Espacio  | Coste por GB | Coste estimado |
| :------------: | :--------: | :------: | :----------: | :------------: |
| 1.000 usuarios | Amazon S3  | 0,26 GB  |   0,023 $    |    0,006 $     |
| 1.000 usuarios | S3 Glacier | 0,845 GB |    0,01 $    |    0,008 $     |
| 5.000 usuarios | Amazon S3  | 0,56 GB  |   0,023 $    |    0,013 $     |
| 5.000 usuarios | S3 Glacier | 1,464 GB |    0,01 $    |    0,015 $     |

##### Costes totales de EMR

| Escenario      | Coste total mensual |
| -------------- | ------------------- |
| 1.000 usuarios | 10.71 $             |
| 5.000 usuarios | 21.53 $             |

##### Copia de seguridad de los informes en S3 Glacier

Asumimos que la información de seguridad de todos los informes se elimina cada 2 años.

|   Escenario    | Espacio por informe | Informes mensuales | Tiempo de guardado | Tiempo de recuperación | Espacio necesario |
| :------------: | :-----------------: | :----------------: | :----------------: | :--------------------: | :---------------: |
| 1.000 usuarios |       500 Kb        |         61         |       2 años       |        Estándar        |     0,845 GB      |
| 5.000 usuarios |        1 Mb         |         61         |       2 años       |        Estándar        |     1,464 GB      |



#### Machine learning: Apredizaje y recomendaciones a usuarios

Para el sistema de recomendación de ventas, vamos a utilizar lo siguiente: Personalize.

Es un sistema gestionado por Amazon, por lo que debemos despreocuparnos de los detalles sobre como generar un sistema de aprendizaje por cuenta de la empresa. Esto permite ahorrar los costes de formación en Data Science.

Para este apartado tenemos en cuenta los dos escenarios, ya que el coste de este producto es alto

##### Machine learning época de baja demanda

Número de Visitas 1000 visitas al día
Número de Clientes que no han realizado visitas este día, estimamos 200 clientes.
Mensualmente cargamos 252 Gb
Emplearemos una capacidad de inferencia de 10 TPS por 720 horas al mes para generar recomendaciones en tiempo real.

La factura del mes por el uso de Amazon Personalize incluirá lo siguiente:

Cargo por procesamiento y almacenamiento de datos = 252 GB x 0,05 USD por GB = 12,6 USD

Cargo por entrenamiento = 300 horas de entrenamiento x 0,24 USD por hora de entrenamiento = 72 USD

Cargo por inferencia (en tiempo real) = 10 x 720 x 0,20 USD/TPS-hora = 1440 USD
Estamos dentro de los 20 millones de recomendaciones al mes

Costo total = 12,6 USD + 72 USD + 1440 USD = 1524,6 USD

##### Machine learning epoca de alta demanda

Número de Visitas 5000 visitas al día
Número de Clientes que no han realizado visitas este día, estimamos 5000 clientes.
Mensualmente cargamos 1,2 TB

La factura del mes por el uso de Amazon Personalize incluirá lo siguiente:

Cargo por procesamiento y almacenamiento de datos = 1155 GB x 0,05 USD por GB = 57,75 USD

Cargo por entrenamiento = 300 horas de entrenamiento x 0,24 USD por hora de entrenamiento = 72 USD

Cargo por inferencia (en tiempo real) = 10 x 720 x 0,20 USD/TPS-hora = 1440 USD
Estamos dentro de los 20 millones de recomendaciones al mes

Costo total = 57.75 USD + 72 USD + 1440 USD = 1569,75 USD

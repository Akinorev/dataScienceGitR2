# Que se necesita para la migracion AWS

## Tienda online se divide en los siguientes servicios

### Necesidades para un ecommerce

* Que los servidores esten siempre funcionando (un servidor inactivo = perder dinero)
* Sistema escalable que pueda crecer en funcion de la epoca del año (es posible que se hagan mas ventas en navidad)
* Sistema de backup que la base de datos este protegida en caso de fallo
* Que sea ampliable, que se puedan incluir nuevos servicios de monitorizacion del entorno
* Pagar solo por el consumo, hay que evitar pagar lo mismo cada mes ya que los sistemas no siempre tendran la misma carga
* Que sea seguro, las transacciones deben mantenerse en privado y garantizar la seguridad del usuario y los propios sistemas.

### Base de datos

#### Instacias de las bbdd

El proyecto debe contar con al menos dos bbdd (Si bien no tenemos estimaciones exactas de como de conocida es la plataforma y como sera su demanda) y con diferencia geografica.

Cogiendo como ejemplo Aurora MySQL

Asi que al menos necesitaremos 2 nodos.

Tipo de maquina elegida:

db.r5.large
(CPU:2 Memory: 16GB Network Performance: up to 10 Gb)

Instance family: memory optimized

Pricing model: OnDemand

Result:

0.58 USD x 730 hours in a month = 423.40 USD
Amazon Aurora MySQL Compatible cost (monthly): 423.40 USD

#### Almacenamiento

Si entendemos que colocar un producto en el carrito es ya una peticion a la base de datos, tanto de bloqueo de item como de liberacion si se opta por no comprar.

Al ser una tienda conocida (pero no tenemos estos datos) solo podemos hacer una estimacion.

Para nuestra simulacion entendemos que se hacen de media unos 2 millones de peticiones al mes.

Hay que tener en cuenta tambien que los compradores indecisos que hacen y deshacen el carrito tambien generan peticiones.

Entendemos que es una tienda grande, por lo que tendra un buen inventario. Tambien debemos guardar un historico por motivos legales de las transacciones, usuarios y demas necesidades que tiene un ecommerce.

Nuestro storage es de 2TB y el numero aproximado de I/O al mes es de 2Millones. Los dos millones de I/O se toma de la siguiente estimacion, 5000 usuarios al dia * 7 peticiones I/O * 30 dias de mes = 1.050.000 aprox

Unit conversions
Storage amount: 2 TB x 1024 GB in a TB = 2048 GB
Pricing calculations
2,048 GB x 0.10 USD = 204.80 USD (Database Storage Cost)
2 x 1000000 multiplier for million x 0.0000002 USD = 0.40 USD (I/O Rate Cost)
204.80 USD + 0.40 USD = 205.20 USD
Total Storage Cost (monthly): 205.20 USD

#### Backup storage

Vamos a guardar los 2TB ya que en nuestro caso no se podemos perder transacciones. Esto podria generar dobles cobros o productos gratis, que a cierto nivel puede repercutir en malas opiniones dañando la imagen de la empresa

Unit conversions
Additional backup storage: 2 TB x 1024 GB in a TB = 2048 GB
Pricing calculations
2,048 GB x 0.021 USD = 43.01 USD
Additional backup storage cost (monthly): 43.01 USD


#### Backtrack

Por si acaso incluiremos servicio de backtrack, asi en caso de que haya una caida de los servidores podemos revertir el estado recuperando al menos los datos de la ultima hora.

El servicio no es muy caro y en caso de necesidad puede salvarnos de las perdidas que se obtendrian en caso de no tenerlo.

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
Como estamos migrando todo eso incluye nuestros servicios web. Entre ellos un DNS, tanto para la intraweb que se pueda tener (para la parte de logistica, info de la empresa... etc) como para la venta de cara al exterior.

Entre hosting hacia el exterior como interno, entendemos que aproximadamente tendremos minimo 1 hosting.

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

Como ecommerce que somos, una parte importante son los Health Checks. Para ello nos aseguramos de que nuestro sistema funcione de la forma adecuada. Calculamos una media de 15 pruebas mensuales de cada tipo para comprobar que todo esta bien.

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

Finalmente Amazon, nos exige un minimo de 2 Elastic Network interfaces e indicamos que se haran aproximadamente unos 3 millones de queries al mes. Unos seran de clientes y otros de potenciales clientes e intersados en nuestros productos.

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

Los costes estimados, son una media. Hay que tener en cuenta que en los ecommerce tienen picos de ventas como podria ser el blackfriday o epoca de Navidades.

Debido a que nuestra compañia esta en EEUU (fundada por españoles expatriados) la mayoria de las ventas las encontramos alli.

Aun asi tambien hace ventas al extranjero. Los ultimos analisis establecieron el siguiente volumen de ventas:

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

Amazon recomienda EMR: https://aws.amazon.com/es/getting-started/hands-on/analyze-big-data/services-costs/

Con un coste aproximado de 769 USD

https://aws.amazon.com/es/emr/pricing/

##### S3 Bucket


#### Cluster Hadoop Alta frecuencia

##### S3 Bucket



#### Machine learning Baja frecuencia

Para el sistema de recomendacion de ventas, vamos a utilizar lo siguiente: Personalize

Tabla costes Personalize: https://aws.amazon.com/es/personalize/pricing/

#### Machine learning Alta frecuencia



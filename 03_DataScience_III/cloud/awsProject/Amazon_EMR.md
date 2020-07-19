## Cluster Hadoop

En este apartado vamos a estimar los coster del uso del servicio *Elastic Map Reduce* para calcular la generación de informes diarios y mensuales.



### 1. Condicionantes:

- Generar informes básicos de ventas dos veces al día
- Generar un informe completo una vez al mes
- Escenario 1 = 1.000 usuarios
- Escenario 2 = 5.000 usuarios
- Envío de informes a servidores
- Guardado como copia de seguridad



### 2. Requerimientos

1. Memoria estimada de procesamiento
2. Instancias para la puesta en marcha del cluster Hadoop
3. Número de instancias del cluster
4. Uso mensual
5. Almacenamiento de informes
6. Copia de seguridad de los informes



#### Memoria estimada de procesamiento

En este apartado vamos a estimar el espacio mínimo necesario para el correcto dimensionado del cluster EMR.

|   Escenario    | Tipo de informe | Información media por usuario | Espacio en memoria |
| :------------: | :-------------: | :---------------------------: | :----------------: |
| 1.000 usuarios |     Diario      |              2MB              |        2 GB        |
| 1.000 usuarios |     Mensual     |             10 MB             |       10 GB        |
| 5.000 usuarios |     Diario      |             2 MB              |       10 GB        |
| 5.000 usuarios |     Mensual     |             10 MB             |       50 GB        |



#### Instancias necesarias

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



#### Número de instancias necesarias

Dado que no conocemos muchos datos del proyecto comenzaremos con un cluster base y posteriormente usaremos la herramienta de Auto-scaling para generar un rango de instancias. Además debemos contar con que AWS Auto Sacling es totalmente gratuito

|   Escenario    |    Operación    | Tipo instancia | Min. instancias | Memoria total (GB) |
| :------------: | :-------------: | :------------: | :-------------: | :----------------: |
| 1.000 usuarios | Informe diario  |    r4.large    |        1        |         16         |
| 1.000 usuarios | Informe mensual |    r4.large    |        1        |         16         |
| 5.000 usuarios | Informe diario  |    r4.large    |        1        |         16         |
| 5.000 usuarios | Informe mensual |   r4.xlarge    |        2        |         61         |



#### Uso mensual

Para hacerlo sencillo suponemos que un mes tiene 30 días, y que el tiempo necesario para eliminar un informe diario con los cluster en ejecución es de 2 horas, mientras que para el informe mensual es de 3 horas

|   Escenario    |    Tipo de informe    | Tiempo de procesado | Horas al día | Horas al mes |
| :------------: | :-------------------: | :-----------------: | :----------: | :----------: |
| 1.000 usuarios | Diario mañana y tarde |     1 h/informe     |      2       |      60      |
| 1.000 usuarios |        Mensual        |     4 h/informe     |      -       |      4       |
| 5.000 usuarios | Diario mañana y tarde |     2 h/informe     |      4       |     120      |
| 5.000 usuarios |        Mensual        |     6 h/informe     |      -       |      4       |



#### Almacenamiento de los informes en S3

Una vez generados los informes se almacenan en un bucket S3 generado exlusivamente para el almacenamiento temporal de éstos. Asumimos que el guardado temporal de los informes es mensual.

|   Escenario    | Espacio por informe | Informes mensuales | Tiempo de guardado | Espacio necesario |
| :------------: | :-----------------: | :----------------: | :----------------: | :---------------: |
| 1.000 usuarios |       500 Kb        |         61         |      mensual       |      0,26 GB      |
| 5.000 usuarios |        1 Mb         |         61         |      mensual       |      0,56 GB      |



#### Copia de seguridad de los informes en S3 Glacier

Asumimos que la información de seguridad de todos los informes se elimina cada 2 años.

|   Escenario    | Espacio por informe | Informes mensuales | Tiempo de guardado | Tiempo de recuperación | Espacio necesario |
| :------------: | :-----------------: | :----------------: | :----------------: | :--------------------: | :---------------: |
| 1.000 usuarios |       500 Kb        |         61         |       2 años       |        Estándar        |     0,845 GB      |
| 5.000 usuarios |        1 Mb         |         61         |       2 años       |        Estándar        |     1,464 GB      |



### 3. Estimación de costes

Para la estimación de los costes del servicio EMR vamos a usar la calculadora de *SIMPLE MONTHLY CALCULATOR* de AWS.

#### Costes por servicio

En este primer cuadro vamos a resumir los servicios y los costes recordando todos los parámetros decididos con anterioridad.

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



#### Costes totales

| Escenario      | Coste total mensual |
| -------------- | ------------------- |
| 1.000 usuarios | 10.71 $             |
| 5.000 usuarios | 21.53 $             |



### 4. Referencias y Links

- https://aws.amazon.com/es/emr/pricing/
- https://docs.aws.amazon.com/emr/index.html
- https://calculator.s3.amazonaws.com/index.html
- https://aws.amazon.com/es/autoscaling/pricing/


Docker compose:

3 contenedores

1- Parseador del libro el señor de los anillos y volcado de datos
2- Generador del grafo usando los datos volcados
3- Visualizacion del grafo en un Apache server (o similar)

Usar un volumen compartido para todos los contenedores!

De momento:
Hay dos contenedores, uno que es el script de Python y el otro que es un servidor web Apache.

Como funciona?
El primer punto es crear el contenedor Python, ya que se usa desde local. Para ello en esta misma ruta hay que ejecutar el siguiente comando:

docker build -f Dockerfile.python -t testing .

Esto lo que hara es construir nuestro contenedor en local.

El siguiente paso es ya levantar todo el sistema:

docker-compose up -d

La pagina web donde se puede leer el resumen del libro es en la siguiente url:
http://172.25.0.7/output.html

Tarda un poco ya que tiene que parsear todo.

El siguiente punto sera poner un load balancer (por complicar un poco las cosas)

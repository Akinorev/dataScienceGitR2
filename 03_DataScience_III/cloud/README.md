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

docker-compose up

Al no usar el flag -d podremos ir viendo las trazas.

Ahora en otra pestaña, elegimos cuantos servidores apache queremos levantar:

docker-compose scale apacheServer=<numero de servers>

A continuacion, cuando veamos que en los logs ha terminado el contenedor del script de python, podemos ver la pagina web en el siguiente sitio:

La pagina web donde se puede leer el resumen del libro es en la siguiente url:
http://localhost/output.html

Tarda un poco ya que tiene que parsear todo.

La magia esta ahora en que cada vez que se refresque el navegador estaremos usando un apacheServer distinto.

Ejemplo de las trazas que indico:

lb_1            | INFO:haproxy:Old HAProxy(PID: 9) ended after 0.00430393218994 sec
pythonScript_1  | working on the second part
pythonScript_1  | working on creating nodes, edges and the list
pythonScript_1  | adding nodes and edges to the graph
pythonScript_1  | calculating the find most important nodes (the ones with more edges)
cloud_pythonScript_1 exited with code 0
apacheServer_1  | 172.23.0.4 - - [14/Jul/2020:17:16:08 +0000] "GET / HTTP/1.1" 200 45
apacheServer_2  | 172.23.0.4 - - [14/Jul/2020:17:16:08 +0000] "GET /favicon.ico HTTP/1.1" 404 196
apacheServer_3  | 172.23.0.4 - - [14/Jul/2020:17:16:32 +0000] "GET /output.html HTTP/1.1" 200 197352
apacheServer_1  | 172.23.0.4 - - [14/Jul/2020:17:16:32 +0000] "GET /favicon.ico HTTP/1.1" 404 196
apacheServer_2  | 172.23.0.4 - - [14/Jul/2020:17:16:40 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_3  | 172.23.0.4 - - [14/Jul/2020:17:16:42 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_1  | 172.23.0.4 - - [14/Jul/2020:17:16:44 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_2  | 172.23.0.4 - - [14/Jul/2020:17:16:46 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_3  | 172.23.0.4 - - [14/Jul/2020:17:16:47 +0000] "GET /output.html HTTP/1.1" 304 -


Con este sistema tenemos un Docker-compose de un minimo de tres contenedores:
- Script de python con su Dockerfile que parsea un libro
- Un high availability proxy
- 1+ Servidores Apache

Creo que ya cumplimos de sobra con lo que se pide en la practica para la parte de Docker... si tengo algo mas de tiempo podemos mirar si incluir un DNS o algun contenedor para almacenar la solucion (de momento se usa un volumen compartido)

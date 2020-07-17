# Cloud

## Docker compose
La meta de esta practica es conocer a fondo la versatilidad de Docker compose como herramienta para crear entornos a base de contenedores desde un unico yaml.

### La aplicacion
A grandes rasgos nuestra aplicacion resume el libro del señor de los anillos, elige aquellos personajes que son mas importantes (por numero de apariciones) para a continuacion publicar el resumen via Web.

Para el desarrollo de este entorno hemos creado lo siguiente. Consiste en tres o mas contenedores (como se explicara en detalle mas adelante). Los contenedores utilizados son:

* pythonscriptbook: es el contenedor mas pesado, se trata de una aplicacion que se desarrollo para una de las asignaturas del master. Dicho contenedor coge en nuestro caso, El señor de los anillos: La comunidad del anillo y realiza un resumen sobre el texto. El libro viene originalmente en formato pdf por lo que el script parsea el libro, analiza los personajes, su peso (cuantas veces aparece) y crea enlaces con otros personajes (en el caso de que aparezcan en la misma frase). Un vez generado el resumen se guarda en un shared volume y el contenedor se para.
* apacheserver: Se trata de un servidor Apache que publicara en una pagina web los resultados obtenidos del contenedor anterior. La url de acceso es: localhost/output.html. Este contenedor es persistente.
* lb: Nuestro tercer contenedor es un load balancer basado en un haproxy. La idea de incluir este contenedor es que nos va a permitir levantar tantos contenedores Apache como deseemos tener. Gracias a esto conseguimos tener una alta disponibilidad, ya que el trafico se distribuye entre los X apache servers que deseemos tener. Este contenedor tambien es persistente.

### Como recrear el contenedor scriptpythonbook en local

En la practica incluimos lo necesario para generar el contendor que creara nuestro resumen desde una maquina local.

El contenido de la carpeta es el siguiente:

* Dockerfile.python: Contiene las instrucciones necesarias para crear el contenedor
* requirments.txt: Son los requisitos de librerias Python, estas se cargaran de forma automatica en nuestro contenedor. Se puede especificar en caso necesario la version de la liberia.
* data: Contiene el libro del Señor de los anillos en formato pdf.
* scripts: Contiene el script que va a parsear y generar el resumen del libro.


En la misma carpeta llamada container ejecutamos lo siguiente:

```sh
$  docker build -f Dockerfile.python -t scriptpythonbook .

```

### Como ejecutar
Para ejecutar y lanzar nuestro entorno antes debemos estar en el mismo path donde tenemos el docker-compose.yml. A continuacion bastara con lanzar el siguiente comando:

```sh
$ docker-compose up
```

En nuestro caso preferimos lanzarlo sin el flag de -d ya que gracias a las trazas podremos observar su comportamiento.

Se debe tener en cuenta que el contenedor que ejecuta el script para resumir el libro puede tardar. Sabremos que ha ejecutado directamente por las siguientes trazas:

```sh
pythonScript_1  | working on the second part
pythonScript_1  | working on creating nodes, edges and the list
pythonScript_1  | adding nodes and edges to the graph
pythonScript_1  | calculating the find most important nodes (the ones with more edges)
cloud_pythonScript_1 exited with code 0
```

A continuacion viene la parte mas interesante de nuestro entorno. Por defecto solo levantamos un servidor Apache, por lo que debemos indicar a docker compose que levante mas instancias. Esto se puede hacer de la siguiente manera:

```sh
$  docker-compose scale apacheServer=3
WARNING: The scale command is deprecated. Use the up command with the --scale flag instead.
Starting cloud_apacheServer_1 ... done
Creating cloud_apacheServer_2 ... done
Creating cloud_apacheServer_3 ... done

```

Ahora gracias a que monitorizamos el entorno en la consola donde lo hemos levantado se podran observar las siguientes trazas:

```sh
lb_1            | backend default_service
lb_1            |   server cloud_apacheServer_1 cloud_apacheServer_1:80 check inter 2000 rise 2 fall 3
lb_1            |   server cloud_apacheServer_2 cloud_apacheServer_2:80 check inter 2000 rise 2 fall 3
lb_1            |   server cloud_apacheServer_3 cloud_apacheServer_3:80 check inter 2000 rise 2 fall 3
lb_1            | INFO:haproxy:Config check passed
lb_1            | INFO:haproxy:Reloading HAProxy
lb_1            | INFO:haproxy:Restarting HAProxy gracefully
lb_1            | INFO:haproxy:HAProxy is reloading (new PID: 11)
lb_1            | INFO:haproxy:===========END===========
lb_1            | INFO:haproxy:Old HAProxy(PID: 9) ended after 6.59373903275 sec
apacheServer_1  | 172.23.0.4 - - [17/Jul/2020:19:59:16 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_1  | 172.23.0.4 - - [17/Jul/2020:19:59:17 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_2  | 172.23.0.4 - - [17/Jul/2020:19:59:18 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_3  | 172.23.0.4 - - [17/Jul/2020:19:59:19 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_1  | 172.23.0.4 - - [17/Jul/2020:19:59:20 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_2  | 172.23.0.4 - - [17/Jul/2020:19:59:22 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_3  | 172.23.0.4 - - [17/Jul/2020:19:59:23 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_1  | 172.23.0.4 - - [17/Jul/2020:19:59:24 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_2  | 172.23.0.4 - - [17/Jul/2020:19:59:25 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_3  | 172.23.0.4 - - [17/Jul/2020:19:59:26 +0000] "GET /output.html HTTP/1.1" 304 -
apacheServer_1  | 172.23.0.4 - - [17/Jul/2020:19:59:27 +0000] "GET /output.html HTTP/1.1" 304 -
```

Tenemos el haproxy configurado de tal forma que puede detectar nuevas instancias Apache. Para obtener estas trazas donde vemos como van alternando las peticiones nos bastara con refrescar la pagina donde se encuentra el resumen.

Este resumen se puede ver en: http://localhost/output.html

A continuacion incluimos un fragmento del resumen:

---
**Ejemplo de resumen**

When Mr. Bilbo Baggins of Bag End announced that hewould shortly be celebrating his eleventy-ï¬rst birthday witha party of special magniï¬cence, there was much talk andexcitement in Hobbiton. Bilbo was very rich and very peculiar, and had been thewonder of the Shire for sixty years, ever since his remarkabledisappearance and unexpected return. The riches he hadbrought back from his travels had now become a local legend,and it was popularly believed, whatever the old folk mightsay, that the Hill at Bag End was full of tunnels stuffed withtreasure. Time wore on, but itseemed to have little effect on Mr. Baggins. But so far trouble had not come; and as Mr. Baggins wasgenerous with his money, most people were willing to for-give him his oddities and his good fortune. When Mr. Bilbo Baggins of Bag End announced that hewould shortly be celebrating his eleventy-ï¬rst birthday witha party of special magniï¬cence, there was much talk andexcitement in Hobbiton. Bilbo was very rich and very peculiar, and had been thewonder of the Shire for sixty years, ever since his remarkabledisappearance and unexpected return. The riches he hadbrought back from his travels had now become a local legend,and it was popularly believed, whatever the old folk mightsay, that the Hill at Bag End was full of tunnels stuffed withtreasure.

---

### Como limpiar el entorno

Para asegurarnos de limpiar por completo nuestra maquina recomendamos los siguientes pasos:

Paramos los contenedores:

```sh
$ docker-compose down
```

Normalmente con el paso previo se paran los contenedores, esto nos garantiza que paramos todos:

```sh
$ docker rm -f $(docker ps -a -q)

```

Eliminamos el volumen creado:

```sh
$ docker volume rm $(docker volume ls -q)

```

### Mejoras que nos gustaria aplicar

El contenedor de python es muy grande, no se termina de aprovechar al maximo las cualidades de los contenedores (esto es que sean lo mas ligeros posible). Se debe en parte a que el contenedor usado de base es ya pesado de por si y hay que añadirle las librerias extra que necesitamos para la ejecucion correcta de nuestros script en Python.



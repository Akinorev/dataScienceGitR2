Como usar el entorno:

Prerrequisitos:

Instalar docker-compose en el caso de usar Linux, si se instala docker en windows ya contiene el docker compose.

Como lanzar:

1. Nos vamos a la carpeta de kafka-spark-streaming-zeppelin-docker
2. Usamos el siguiente comando para levantar el entorno: docker-compose up -d

Le puede llevar unos minutos en arrancar las GUIS

Como acceder a Zeppelin:

Tiene su propia url: http://172.25.0.19:8080

Si se quiere probar con el notebook de ejemplo hay que ir a: http://172.25.0.19:8080/#/notebook/2EAB941ZD

Ya se puede trabajar sobre el. Si quereis mas info sobre el entorno y el propio notebook toda la info esta en:

https://github.com/EthicalML/kafka-spark-streaming-zeppelin-docker

Y ahora... 

Donde estan las cosas en local...

El csv que se usa para la practica esta guardado en kafka-spark-streaming-zeppelin-docker -> zeppelin -> datadrive 

Como son volumenes compartidos, todo lo que vaya a esta carpeta sera accesible (en este caso) desde Zeppelin.

El notebook se guardara seguramente en kafka-spark-streaming-zeppelin-docker -> zeppelin -> pyspark-notebooks

He tenido que hacer unas modificaciones sobre los notebooks hasta que he conseguido uno que funciona (he arreglado el notebook que viene en el ejemplo)

el enlace para acceder a dicho notebook una vez esta todo levantado es el siguiente:

http://172.25.0.19:8080/#/notebook/2FE5M35JR


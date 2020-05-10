Titulo: DS-Bases de datos no convencionales.
Fecha: 20-05-10
Autores: Carlos Grande, Pablo Olmos, Verónica Gómez
Descripcion: Creación de la base de datos dblp en MongoDB. 
Librarías: json, re, lxml, pymongo, pandas
---
Ejecución:
01. Descargar el fichero dblp.xml.gz del repositorio 
https://dblp.uni-trier.de/xml/

02. Ejecutar el script 01_xmlParser.py para generar un fichero
dblp_parsed.json

03. Ejecutar el script 02_MongoLoader.py para la creación de la
base de datos y la carga del fichero en MongoDB.

04. Ejecutar el script 03_MongoFinder.py para realizar las
consultas propuestas en MongoDB.

--- Fin ---
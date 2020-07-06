# Visualización: accidentes UK

Este repositorio contiene toda la informaciñón necesaria para reproducir la práctica. Se ha seleccionado una base de datos con 3 tablas que contienen información sobre los accidentes de Reino Unido desde 2005 hasta 2014. 

Estos datos pueden obtenerse a través de este enlace: https://www.kaggle.com/benoit72/uk-accidents-10-years-history-with-many-variables

## 1. Miembros del equipo

- Verónica Gómez 

- Carlos Grande 

- Pablo Olmos

  

## 2. Estructura del repositorio

The repository is organize by folders following the next categories:

- **01_data**: this folder contains all the data needed for the assignment.
  - cncf_git_data.json
  - cncf_git_mapping.json
- **02_scripts**: this folder contains the library needed to load data and execute the notebooks.
  - elastic_loader.py
  - elastic_finder.py
- **03_notebooks**: this folder contains the notebooks elaborated for the work.
  - 01_LoadingData.ipynb
  - 02_ExploratoryDataAnalysis.ipynb
  - 03_SurvivalAnalysis.ipynb
- **04_screenshots**: this folder contains the resulting images from the Dashboards.
  - Screen_01.png
  - Screen_02.png
  - Screen_Dashboard.png
- **05_exports**: this folder contains the final objects exported from kibana.
- **README.md**: file with the instructions to understand the repository.
- **MDS_Memoria.pdf**: final report from the assignment.



## 3. Ejecución del repositorio

To run the repository you need to follow the next instructions:

1. Run **ElasticSearch** and **Kibana**.
2. Open de **DataLoader** notebook, and follow the instructions.
3. Once the Elastic Index has been created run **the notebooks**.
4. Finally open the kibana site and import the objects from the **05_exports** folder.

## 4. Resultados

![Screen_Dashboard](E:\Datos\00_WIP\00_MasterDataScience\03_DataScience III\RecuperacionInformacion\04_Practicas\0621_PracticaFinal\04_results\Screen_Dashboard.png)

## Referencias y links

- Cloud Native Computing Foundations website: https://www.cncf.io/
- Github repository: 
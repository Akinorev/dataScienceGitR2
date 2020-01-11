#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Título: Práctica 01

Asignatura: Obtención de datos.

Fecha de entrega: 15 de enero de 2020.

@Equipo: Carlos Grande Nuñez, Veronica Gomez Gomez y Pablo Olmos Martinez
"""

# IMPORTADO DE LIBRERIAS
from bs4 import BeautifulSoup as bs
import urllib.request
import re
import pandas as pd

# FUNCIONES

def openFile(file):
    # esta funcion importa un fichero .txt
    # POR ALGUN MOTIVO NO FUNCIONA BIEN, NO HACE BIEN EL RETURN
    try:
        data = ""
        if "csv" in line:
            data = pd.read_csv(file)
        elif "txt" in line:
            data = pd.read_csv(file, sep=",")

    except:
        print('Error opening file')
    return(data)

def filterData(dataSet,col,filterStr):
    return dataSet.loc[dataSet[col].str.contains(filterStr)]

# GUARDAMOS LOS FICHEROS EN VARIABLES
# FILTRAMOS LOS DATASET DE LOS STOP PARA OBTENER SOLO AQUELLAS ENTRADAS QUE NOS INTERESAN
scraperFile = pd.read_csv("scraper_output.csv", encoding='utf8')
#CONVIERTO LOS NOMBRES DE LAS ESTACIONES A MINUSCULAS
scraperFile['stop_name'] = scraperFile['stop_name'].str.lower()
# FILTRO EN SUBSETS
scraperMetro = filterData(scraperFile,"transportmean_name","METRO")
scraperLigero = filterData(scraperFile,"transportmean_name","ML")
scraperCercanias = filterData(scraperFile,"transportmean_name","CR")

# FILTRO EN SUBSETS PARA QUEDARNOS SOLO CON LAS ESTACIONES
metroStops = pd.read_csv("stops_metro.txt", encoding='utf8')
metroStops['stop_name'] = metroStops['stop_name'].str.lower()
metroStopsSubset = filterData(metroStops,"stop_id","est")

ligeroStops = pd.read_csv("stops_ligero.txt", encoding='utf8')
ligeroStops['stop_name'] = ligeroStops['stop_name'].str.lower()
ligeroStopsSubset = filterData(ligeroStops,"stop_id","est")

cercaniasStops = pd.read_csv("stops_cercanias.txt", encoding='utf8')
cercaniasStops['stop_name'] = cercaniasStops['stop_name'].str.lower()
cercaniasStopsSubset = filterData(cercaniasStops,"stop_id","est")

# LEFT JOIN DONDE SCRAPER* ESTARA A LA IZQ Y LA INFO DE LAS ESTACIONES A LA DRCH
mergedMetro = pd.merge(left=scraperMetro, right=metroStopsSubset, how='left', left_on='stop_name', right_on='stop_name')
mergedLigero = pd.merge(left=scraperLigero, right=ligeroStopsSubset, how='left', left_on='stop_name', right_on='stop_name')
mergedCercanias = pd.merge(left=scraperCercanias, right=cercaniasStopsSubset, how='left', left_on='stop_name', right_on='stop_name')

print(mergedMetro)
mergedMetro.to_csv('merged_test_output.csv', index=False)

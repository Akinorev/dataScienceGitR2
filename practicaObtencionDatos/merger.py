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

def filterData(dataSet,filterStr):
    return dataSet.loc[dataSet['stop_id'].str.contains(filterStr)]

# GUARDAMOS LOS FICHEROS EN VARIABLES
# FILTRAMOS LOS DATASET DE LOS STOP PARA OBTENER SOLO AQUELLAS ENTRADAS QUE NOS INTERESAN
scraperFile = pd.read_csv("scraper_output.csv")

metroStops = pd.read_csv("stops_metro.txt")
metroStopsSubset = filterData(metroStops,"est")

ligeroStops = pd.read_csv("stops_ligero.txt")
ligeroStopsSubset = filterData(metroStops,"est")

cercaniasStops = pd.read_csv("stops_cercanias.txt")
cercaniasStopsSubset = filterData(metroStops,"est")
#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Título: Práctica 01
    
Asignatura: Obtención de datos.
    
Fecha de entrega: 15 de enero de 2020.

@Equipo: Carlos Grande Nuñez, Veronica Gomez Gomez y Pablo Olmos Martinez
"""


# IMPORTADO DE LIBRERIAS Y AJUSTES DE PANDAS
from bs4 import BeautifulSoup as bs
import urllib.request
import re
import pandas as pd
pd.set_option('display.max_rows', 20)
pd.set_option('display.max_columns', 20)
pd.set_option('display.width', 1000)

### -------------------------------------------------------------

# FUNCIONES
def parser(url):
    # esta funcion obtiene el hmtl de cualquier página
    try:
        page = urllib.request.urlopen(url) # conexión
    except:
        print('Error')
    # parser con bs4
    soup = bs(page, 'html.parser')
    return(soup)

def get_lines(soup):
    # esta funcion obtiene del html las líneas de disponibles dentro del transporte
    regex = re.compile('^listaBotones.logos')
    main_content = soup.find('div', attrs={'class': regex}).find_all('a')
    semi_urls = [re.findall('\/.*aspx', str(i))[0] for i in main_content]

    # completado de urls
    home = 'https://www.crtm.es/'
    lineas_urls = [home + i for i in semi_urls]

    # extracción de los nombres de cada linea
    lineas_names = soup.find('div', attrs={'class': regex}).find_all('span', attrs={'class':'txt'})
    lineas_names = [i(text=True)[0] for i in lineas_names]

    # extracción de los numeros de cada linea
    lineas_numbers = soup.find('div', attrs={'class': regex}).find_all('span', attrs={'class': 'logo'})
    lineas_numbers = [i(text=True)[0] for i in lineas_numbers]

    return(lineas_names, lineas_urls, lineas_numbers)

def get_stops(soup):
    # esta funcion obtiene de las webs con la lineas las estaciones ordenadas dentro de cada línea
    regex = re.compile('estaciones')
    main_content = soup.find('tbody').find_all('a', attrs={'href': regex})
    estaciones_names = [i(text=True)[0] for i in main_content]
    return(estaciones_names)

### -------------------------------------------------------------

# 01 CODIGO: CAPTURA LINEAS
## links con las líneas de los diferentes trasportes y los títulos de cada transporte
transportes_links = ['https://www.crtm.es/tu-transporte-publico/metro/lineas.aspx',
        'https://www.crtm.es/tu-transporte-publico/metro-ligero/lineas.aspx',
        'https://www.crtm.es/tu-transporte-publico/cercanias-renfe/lineas.aspx']

transportes = ['METRO', 'ML', 'CR']

## ejecución del scraper para la obtención de las lineas de cada transporte
lineas_links = {}
lineas_names = {}
lineas_numbers = {}
for i in range(len(transportes_links)):
    ## parseado la web
    html = parser(transportes_links[i])

    ## captura y guardado de los parametros de las lineas
    scraped_lines = get_lines(html)
    lineas_names[transportes[i]] = scraped_lines[0]
    lineas_links[transportes[i]] = scraped_lines[1]
    lineas_numbers[transportes[i]] = scraped_lines[2]

### -------------------------------------------------------------

# 02 CODIGO: CAPTURA DE ESTACIONES DE CADA LÍNEA
dfs_list = []
## acceso a los diferentes transportes
for transporte in transportes:
    ## recorrido a cada uno de los indices de cada linea
    for i in range(len(lineas_links[transporte])):
        linea = lineas_links[transporte][i]
        html = parser(linea)
        estaciones_metro = get_stops(html)

        ## creación del data frame por cada línea con todos los parámetros obtenidos del scraper
        df_temp = pd.DataFrame({'transportmean_name': transporte,'line_number': lineas_numbers[transporte][i], 'line_name': lineas_names[transporte][i], 'order_number': range(len(estaciones_metro)), 'stop_name': estaciones_metro})
        dfs_list.append(df_temp)

## salvado y muestra del data frame
df_scraper = pd.concat(dfs_list).reset_index()
print(df_scraper)
df_scraper.to_csv('scraper_output.csv', index=False)


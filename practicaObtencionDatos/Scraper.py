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

    lineas_names = soup.find('div', attrs={'class': regex}).find_all('span', attrs={'class':'txt'})
    lineas_names = [i(text=True)[0] for i in lineas_names]

    # completado de urls
    home = 'https://www.crtm.es/'
    lineas_urls = [home + i for i in semi_urls]
    return(lineas_names, lineas_urls)

def get_stops(soup):
    # esta funcion obtiene del html las estaciones ordenadas dentro de cada línea
    regex = re.compile('estaciones')
    main_content = soup.find('tbody').find_all('a', attrs={'href': regex})
    estaciones_names = [i(text=True)[0] for i in main_content]
    return(estaciones_names)


# 01 CODIGO: CAPTURA LINEAS
transportes_links = ['https://www.crtm.es/tu-transporte-publico/metro/lineas.aspx',
        'https://www.crtm.es/tu-transporte-publico/metro-ligero/lineas.aspx',
        'https://www.crtm.es/tu-transporte-publico/cercanias-renfe/lineas.aspx']

transportes_nombres = ['metro', 'metro-ligero', 'cercanias-renfe']

all_lineas_links = {}
all_lineas_names = {}

for i in range(len(transportes_links)):
    # 02 parseado la web
    html = parser(transportes_links[i])

    # 03 recogida de links
    urls = get_lines(html)
    all_lineas_names[transportes_nombres[i]] = urls[0]
    all_lineas_links[transportes_nombres[i]] = urls[1]

print(all_lineas_links)
print(all_lineas_names)

# 02 CODIGO: CAPTURA DE ESTACIONES DE CADA LÍNEA
## captura de las estaciones de metro
lineas_links_metro = all_lineas_links['metro']
lineas_names_metro = all_lineas_names['metro']

dfs_list = []
for i in range(len(lineas_links_metro)):
    linea = lineas_links_metro[i]
    html = parser(linea)
    estaciones_metro = get_stops(html)
    print(estaciones_metro)
    df_temp = pd.DataFrame({str(lineas_names_metro[i]) + '_stops': estaciones_metro, str(lineas_names_metro[i]) + '_posicion': range(len(estaciones_metro))})

    print(df_temp)

## captura de las estaciones de cercanías


## captura de las estaciones de metro ligero





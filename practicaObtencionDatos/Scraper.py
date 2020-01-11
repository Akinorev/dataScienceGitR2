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


# FUNCIONES
def parser(url):
    try:
        page = urllib.request.urlopen(url) # conexión
    except:
        print('Error')
    # parser con bs4
    soup = bs(page, 'html.parser')
    return(soup)

def get_links(soup):
    # recogida de urls mediante expresiones regulares
    regex = re.compile('^listaBotones.logos')
    main_content = soup.find('div', attrs={'class': regex}).find_all('a')
    semi_urls = [re.findall('\/.*aspx', str(i))[0] for i in main_content]

    # completado de urls
    home = 'https://www.crtm.es/'
    urls = [home + i for i in semi_urls]
    return(urls)


# 01 CODIGO: CAPTURA DE URLS
transportes_links = ['https://www.crtm.es/tu-transporte-publico/metro/lineas.aspx',
        'https://www.crtm.es/tu-transporte-publico/metro-ligero/lineas.aspx',
        'https://www.crtm.es/tu-transporte-publico/cercanias-renfe/lineas.aspx']

transportes_nombres = ['metro', 'metro-ligero', 'cercanias-renfe']

lineas_links = {}
for i in range(len(transportes_links)):
    # 02 parseado la web
    html = parser(transportes_links[i])

    # 03 recogida de links
    urls = get_links(html)
    lineas_links[transportes_nombres[i]] = urls

print(lineas_links)

# 02 CODIGO:CAPTURA DE URLS



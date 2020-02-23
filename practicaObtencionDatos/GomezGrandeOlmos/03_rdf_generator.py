# -*- coding: utf-8 -*-
"""
Título: Práctica 01

Asignatura: Obtención de datos.

Fecha de entrega: 15 de enero de 2020.

@Equipo: Carlos Grande Nuñez, Veronica Gomez Gomez y Pablo Olmos Martinez
"""


from rdflib.namespace import RDF, FOAF, SKOS, RDFS
from rdflib import Namespace
from rdflib import Graph, Literal, URIRef
import pandas as pd



stops_df = pd.read_csv("02_merger_output.csv", sep=',', encoding='utf-8')
stops_df.head()
g = Graph()

#ontologias

 
obd_st      = Namespace("gtfs:Stop/")
obd_ln      = Namespace("gtfs:Route/")
gtfs_ns     = Namespace('http://vocab.gtfs.org/terms#')
crtm_ns     = Namespace('https://www.crtm.es/tu-transporte-publico/')

#prefijos para una lectura más legible


g.bind('entity', crtm_ns)



# creacion de la agencia
ctm = crtm_ns['CRTM']

g.add( (ctm, RDF.type, gtfs_ns.Agency) )
g.add( (ctm, FOAF.name, Literal('Consorcio Regional de Transportes de la Comunidad de Madrid')) )
g.add( (ctm, FOAF.page, Literal('http://www.crtm.es/')) )

# creacion de los tipos de rutas
madrid_metro = crtm_ns['Metro']
g.add( (madrid_metro, RDF.type, gtfs_ns.Subway) )
g.add( (madrid_metro, FOAF.name, Literal('Metro de Madrid')) )
g.add( (madrid_metro, gtfs_ns.agency, ctm) )

madrid_cr = crtm_ns['Cercanias']
g.add( (madrid_cr, RDF.type, gtfs_ns.Rail) )
g.add( (madrid_cr, FOAF.name, Literal('Cercanías Madrid')) )
g.add( (madrid_cr, gtfs_ns.agency, ctm) )

madrid_ml = crtm_ns['ML/T']
g.add( (madrid_ml, RDF.type, gtfs_ns.LightRail) )
g.add( (madrid_ml, FOAF.name, Literal('Metro Ligero/Tranvía de Madrid')) )
g.add( (madrid_cr, gtfs_ns.agency, ctm) )

#ordenamos 

stops_df.sort_values(by=["transportmean_name", "line_number", "order_number"], inplace=True)
stops_df['stop_name'].str.encode('utf-8')
stops_df.head()


transportmean_name = {'METRO': u'Metro', 
                      'CR': u'Cercanías', 
                      'ML': u'Metro Ligero/Tranvía'
                     }
transportmean_resource = {'METRO': madrid_metro, 
                          'CR': madrid_cr, 
                          'ML': madrid_ml
                     }



lln = None
for index, row in stops_df.iterrows():
    stop_id = (row["stop_id"])
    if  lln == None or lln != row["line_number"] :
        lln = row["line_number"]
        try:
            line_id = row["transportmean_name"].lower() + ':' 
            line_id = line_id + row["line_number"]
        except Exception:
            print("!!!!!!Error:" + str(row["transportmean_name"]) + '/' + str(row["line_number"]))
            continue
        line_name = u'Línea %s de %s' %(row['line_number'], transportmean_name[row['transportmean_name']])
        g.add ( (obd_ln[line_id], RDF.type, gtfs_ns.Route) )
        g.add ( (obd_ln[line_id], RDF.type, RDF.Seq) )
        g.add ( (obd_ln[line_id], gtfs_ns.shortName , Literal(row["line_number"])) )
        g.add ( (obd_ln[line_id], gtfs_ns.longName, Literal(line_name)) )
        g.add ( (obd_ln[line_id], gtfs_ns.routeType, transportmean_resource[row['transportmean_name']]) )
        """
        print (line_id)
        print (stop_id)
        print (transportmean_name)
        """
    order_id = u'http://www.w3.org/1999/02/22-rdf-syntax-ns#_' + str(row["order_number"]+1)
    #print((obd_ln[line_id], URIRef(order_id), obd_st[stop_id]))
    g.add ( (obd_ln[line_id], URIRef(order_id), obd_st[stop_id]) )
    
output_file = '03_rdf_output.rdf'
g.serialize(output_file, format='xml')    

# -*- coding: utf-8 -*-
"""
Created on Sun Jan 12 08:57:01 2020

@author: Pablo
"""



from rdflib.namespace import RDF, FOAF, SKOS, RDFS
from rdflib import Namespace
from rdflib import Graph, Literal, URIRef
import pandas as pd



stops_df = pd.read_csv("merged_test_output.csv", sep=',', encoding='latin-1')
stops_df.head()
g = Graph()

#ontologias

sch         = Namespace('https://schema.org')
mao         = Namespace('http://com.vortic3.MANTO#')   
obd_st      = Namespace("urn:transit_stations:community_of_madrid:")
obd_ln      = Namespace("urn:transit_routes:community_of_madrid:")
gtfs_ns     = Namespace('http://vocab.gtfs.org/terms#')
geo_ns      = Namespace('http://www.w3.org/2003/01/geo/wgs84_pos#')
dct_ns      = Namespace('http://purl.org/dc/terms/')
wikidata_ns = Namespace('https://www.wikidata.org/entity/')
naptan_ns   = Namespace('http://transport.data.gov.uk/def/naptan/')                

#prefijos para una lectura más legible

g.bind('sch', sch)
g.bind('mao', mao)
g.bind('foaf', FOAF)
g.bind('gtfs', gtfs_ns)
g.bind('geo', geo_ns)
g.bind('dct', dct_ns)
g.bind('entity', wikidata_ns)
g.bind('naptan', naptan_ns)
g.bind('obd-st', obd_st)
g.bind('obd-ln', obd_ln)



# creacion de la agencia
ctm = wikidata_ns['Q8350122']

g.add( (ctm, RDF.type, gtfs_ns.Agency) )
g.add( (ctm, FOAF.name, Literal('Consorcio Regional de Transportes de la Comunidad de Madrid')) )
g.add( (ctm, FOAF.page, Literal('http://www.crtm.es/')) )

# creacion de los tipos de rutas
madrid_metro = wikidata_ns['Q191987']
g.add( (madrid_metro, RDF.type, gtfs_ns.Subway) )
g.add( (madrid_metro, FOAF.name, Literal('Metro de Madrid')) )
g.add( (madrid_metro, gtfs_ns.agency, ctm) )

madrid_cr = wikidata_ns['Q1054785']
g.add( (madrid_cr, RDF.type, gtfs_ns.Rail) )
g.add( (madrid_cr, FOAF.name, Literal('Cercanías Madrid')) )
g.add( (madrid_cr, gtfs_ns.agency, ctm) )

madrid_ml = wikidata_ns['Q939283']
g.add( (madrid_ml, RDF.type, gtfs_ns.LightRail) )
g.add( (madrid_ml, FOAF.name, Literal('Metro Ligero/Tranvía de Madrid')) )
g.add( (madrid_cr, gtfs_ns.agency, ctm) )

#ordenamos 

stops_df.sort_values(by=["transportmean_name", "line_number", "order_number"], inplace=True)
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
    stop_id = (row["stop_name"])
    if  lln == None or lln != row["line_number"] :
        lln = row["line_number"]
        line_id = row["transportmean_name"].lower() + ':' + row["line_number"]
        line_name = u'Línea %s de %s' %(row['line_number'], transportmean_name[row['transportmean_name']])
        g.add ( (obd_ln[line_id], RDF.type, gtfs_ns.Route) )
        g.add ( (obd_ln[line_id], RDF.type, RDF.Seq) )
        g.add ( (obd_ln[line_id], gtfs_ns.shortName , Literal(row["line_number"])) )
        g.add ( (obd_ln[line_id], gtfs_ns.longName, Literal(line_name)) )
        g.add ( (obd_ln[line_id], gtfs_ns.routeType, transportmean_resource[row['transportmean_name']]) )
        print (line_id)
        print (stop_id)
        print (transportmean_name)            
    order_id = u'http://www.w3.org/1999/02/22-rdf-syntax-ns#_' + str(row["order_number"])
    g.add ( (obd_ln[line_id], URIRef(order_id), obd_st[stop_id]) )
    
output_file = 'obd.rdf'
g.serialize(output_file, format='xml')    
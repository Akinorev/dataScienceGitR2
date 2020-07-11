from collections import Counter
import copy
import json
import pdftotext
import spacy
import nltk
import networkx as nx
import matplotlib.pyplot as plt
from gensim.summarization.summarizer import summarize
import itertools
import sys

nlp = spacy.load('en_core_web_sm')

bookName = "j-r-r-tolkien-lord-of-the-rings-01-the-fellowship-of-the-ring.pdf"
compressionFactor = 0

def initVariables (book, compression):

    bookName = book
    compressionFactor = compression
    return bookName, compressionFactor


variables = initVariables(sys.argv[1], sys.argv[2])

bookName = variables[0]
compressionFactor = int(variables[1])




with open(bookName, "rb") as file:
    pdf = pdftotext.PDF(file)


textToPlay2 = pdf[55]
textToPlay = pdf[200]

cleanText = []



#book 1 from 55 to 309
#book 2 from 311 to 559
#for index in range(55, 309):
for index in range(55,559):

#Cleaning pages
#print(type(textToPlay))
    tmp = pdf[index]
    if "Chapter" in tmp:
    #Removing first chapter title ONLY FOR CHAPTER BEGINNINGS!
        tmp = tmp.split("\n",2)[2]
    #Elimino los saltos de linea
        tmp = tmp.replace('\n','')
        cleanText.append(tmp)
    if "BOOK TWO" in tmp:
        print("working on the second part")
    #Removing empty pages those starts with '.'
    if tmp.startswith('.'):
        tmp.replace('.','')
    else:
        #If not beginning of chapter just remove first line
        tmpSplit = tmp.split("\n",1)
        #Taking care of the images
        if len(tmpSplit) == 1:
            tmpSplit = ''
        else:
            tmp = tmpSplit[1]
        #Elimino los saltos de linea
        tmp = tmp.replace('\n','')
        cleanText.append(tmp)


#Processing the text using a modified version of the algorithm defined by David Duran Prieto


g = nx.Graph()

nodos = []
aristas = []
aristasLimpias = []

charPages = {"book":[]}

pagesTest = []

bookLen = len(cleanText)
print("working on creating nodes, edges and the list")
for i in range(0,bookLen):
    cleanPage = cleanText[i]
    tmpPage = {}
    tmpPage["page"] = i
    page = i
    charPages["book"].append(tmpPage)

    doc = nlp(cleanPage)
    for oracion in (doc.sents):
        namesList = []
        for i in range (0, len(oracion.ents)):
            chunk = oracion.ents[i]
            #Creating the nodes and creating a list also of only label_ = PERSON for creating tuples next
            if(chunk.label_ == 'PERSON'):
                namesList.append(chunk[0].text)
                char = chunk[0].text
                pageInfo = (page, char, oracion)
                pagesTest.append(pageInfo)
                if not (nodos.__contains__(chunk[0].text)):
                    nodos.append(chunk[0].text)
            #Creating the edges
            if (len(namesList) != 0 and len(namesList)!=1):
                for name in namesList:
                    # Now I need to create all possible combination of names into tuples (in both directions)
                    if name != char:
                        tupla = (char, name)
                        tupla2= (name,char)
                            #tupla = namesList
                        if (tupla not in aristas):
                            aristas.append(tupla)
                            aristas.append(tupla2)
                            #print(aristas)
                            chunkLimpio = chunk[1:]
                        else:
                            chunkLimpio = chunk
                        if not (nodos.__contains__(chunkLimpio.text)):
                            nodos.append(chunkLimpio.text)

nodosLimpios = list(filter(None, nodos))

#print(aristas)

seen = set()
noDuplicates = []

print("adding nodes and edges to the graph")

g.add_nodes_from(nodosLimpios)
g.add_edges_from(aristas)

#Busco darle pesos a los nodos
#print("adding some weight to the graph, just for visual purposes")
sizes = []
for nodo in g.nodes:
    tam = len(g.edges(nodo))*100
    sizes.append(tam)
    #print(len(g.edges((nodo))))
#nx.draw(g,node_size = sizes, with_labels=True)
#plt.show()

print("calculating the find most important nodes (the ones with more edges)")

popular = []


for nodo in nodosLimpios:
    #print(len(g.edges(nodo)))
    tuplaPopular = (len(g.edges(nodo)),nodo)
    popular.append(tuplaPopular)

popular.sort(key=lambda tup: tup[0], reverse=True)

#Calculate top elements based on compression index
top = int((len(popular) * compressionFactor) / 100)

highX = popular[:top]

#print(highX)
#Getting the sentences belonging to the character

resumen = []

for page in pagesTest:
    for char in highX:
        #print(page[1])
        #print(char[0])
        if str(page[1]) == str(char[1]):
            if page[2] not in resumen:
                resumen.append(page[2])

if (compressionFactor == 0):
    print(0)
elif (compressionFactor == 100):
    for i in range(0, bookLen):
        print(cleanText[i])
else:
    print(resumen)
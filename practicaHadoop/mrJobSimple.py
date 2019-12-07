"""The classic MapReduce job: count the frequency of words.
"""
from mrjob.job import MRJob
import re
import sys
import json
import string
import urllib
import urllib2

file = re.compile(r"[\w']+")


class MRWordFreqCount(MRJob):

    def mapper(self, _, line):
    	#Loading dictionary
        #Cargar el diccionario ingles en una valiable
        opener = urllib.URLopener()
        fileDict = opener.open('https://hadoopdatasciencetest.s3.amazonaws.com/AFINN-111.txt')

        scores = {} # initialize an empty dictionary
        for line in fileDict:
           term, score = line.split("\t")
           scores[term] = int(score)

        for word in file.findall(line):
            word = word.encode('ascii','ignore').lower()
            word = re.sub(r'[^a-zA-Z0-9]', '', word)

            if word in scores:
               sys.stderr.write("WORD WITH VALUE: ({0},{1})\n".format(word,scores[word]))
               yield (word,scores[word])
            else:
               sys.stderr.write("WORD NO VALUE: ({0},{1})\n".format(word,0))
               yield (word,0)
            
    def combiner(self, word, counts):
        yield (word, sum(counts))

    def reducer(self, word, counts):
        yield (word, sum(counts))


if __name__ == '__main__':
     MRWordFreqCount.run()

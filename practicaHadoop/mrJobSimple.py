"""The classic MapReduce job: count the frequency of words.
"""
from mrjob.job import MRJob
import re
import sys
import json
import string
import urllib
import urllib2


class MRWordFreqCount(MRJob):

    def mapper(self, _, line):
        #Loading dictionary
        #Cargar el diccionario ingles en una valiable
        sys.path.append('.')
        file = open("AFINN-111.txt")
        scores = {} # initialize an empty dictionary
        for row in file:
           term, score = row.split("\t")
           scores[term] = int(score)

        #for line in file:
                # Read tweet
        line = line.strip()
        tweet = json.loads(line)

        if ("place" in tweet.keys() 
            and tweet["place"] is not None 
            and tweet["place"]["country_code"] == "UY"):
            
            for word in tweet["text"].split(" "):
                word = word.encode('ascii','ignore').lower()
                word = re.sub(r'[^a-zA-Z0-9]', '', word)
                if word in scores:
                    yield (word,scores[word])
                else:
                    yield (word,0)

    def combiner(self, word, scores):
        yield (word, sum(scores))

    def reducer(self, word, scores):
        yield (word, sum(scores))


if __name__ == '__main__':
     MRWordFreqCount.run()

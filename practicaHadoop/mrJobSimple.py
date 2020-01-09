"""Twitter sentiment, analyzes a Twitter file and gives values to certain words.
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
        #Loading dictionary on a variable
        sys.path.append('.')
        file = open("AFINN-111.txt")
        scores = {} # initialize an empty dictionary
        for row in file:
           term, score = row.split("\t")
           scores[term] = int(score)

        #Gets every line in the file:
        #Loads and formats in Json style each line
        line = line.strip()
        tweet = json.loads(line)
        #We check if the value "place" exists in the Tweet, also we need to check that is not empty and finally that it belongs to the US
        if ("place" in tweet.keys() 
            and tweet["place"] is not None 
            and tweet["place"]["country_code"] == "US"):
            #If the Tweet complies with all the if's clause we only need to split the content on text,
            #it will be the part that needs to be analyzed
            for word in tweet["text"].split(" "):
                #We make sure that all words are in lower case, since the dictionary we use is also in lower case
                word = word.encode('ascii','ignore').lower()
                #Also we take sure of removing all special characters
                word = re.sub(r'[^a-zA-Z0-9]', '', word)
                #After all the cleaning we give values to the words. If they appear on the dictionary we give the corresponding value
                #If not we give value 0
                if word in scores.keys():
                    yield (word,scores[word])
                else:
                    yield (word,0)

    def combiner(self, word, scores):
        yield (word, sum(scores))

    def reducer(self, word, scores):
        yield (word, sum(scores))


if __name__ == '__main__':
     MRWordFreqCount.run()

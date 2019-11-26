#!/usr/bin/env python

import sys
import json
import string
import re

sys.path.append('.')

# Import the dictionary

fileDict = open("AFINN-111.txt")
scores = {} # initialize an empty dictionary
for line in fileDict:
   term, score = line.split("\t")
   scores[term] = int(score)
#   print scores.items()


file = sys.stdin

#print [obj for obj in file if(obj['country_code'] == 'UY')]


# Read each line from STDIN
#for line in sys.stdin:
for line in file:

   if '"country_code":"US"' in line:
   #Filter here, each line still consist on Json format
      jsonLine = json.loads(line)
   # Get the words in each line
      words = line.split()

   # Generate the count for each word
      for word in words:
 
      # Write the key-value pair to STDOUT to be processed by the reducer.
      # First we compare if the word appears on the dictionary
      # If it appears we give it corresponding value, if not we just give zero value
         if word in scores:
            print '{0}\t{1}'.format(word,scores[word])
         else:
            print '{0}\t{1}'.format(word,0)

#cat sherlock.txt | ./mapper.py | sort -t 1 | ./reducer.py

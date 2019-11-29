#!/usr/bin/env python

import sys
import json
import string
import re
from argparse import ArgumentParser


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
#parser = ArgumentParser()

#parser.add_argument('-c','--country', type=str, help='Filter tweets by country code (example: UY')
#parser.add_argument('-h','--hashtag', type=str, help='Filter tweets by hashtag (example: #helloTwitter)')

#args = parser.parse_args()

#filterCountry = ""
#filterHashtag = ""

#if (args.country != ""):
#   filterCountry = '"country_code":"' + str(args.country) + '"'

#if (args.hashtag != ""):
#   filterHastag = str(args.hashtag)




# Read each line from STDIN
#for line in sys.stdin:
for line in file:

   jsonLine = ""

   # NEXT IF ONLY FOR EXTRA POINTS, USE OUTSIDE BETTER
 #  if (filterCountry != ""):   
 #     if filterCountry in line:
 #        jsonLine = line
 #        print jsonLine
 #  elif (filterHastag != ""):
 #     if filterHastag in line:
 #        jsonLine = line
 #  else:

   if '"country_code":"US"' in line:
      jsonLine = line
   # Get the words in each line
   words = jsonLine.split()

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

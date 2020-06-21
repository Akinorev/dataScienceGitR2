#!/usr/bin/env python

import sys
import json
import string
import re
from argparse import ArgumentParser

def read_input(file):
    for line in file:
        # split the line into words
        yield line.split()


def main(separator='\t'):

   sys.path.append('.')

# Import the dictionary

   fileDict = open("AFINN-111.txt")
   scores = {} # initialize an empty dictionary
   for line in fileDict:
      term, score = line.split("\t")
      scores[term] = int(score)
#   print scores.items()


   file = read_input(sys.stdin)
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
         # Transform to ascii and lower case, second step to remove punctuation
         word = word.encode('ascii','ignore').lower()
         word = re.sub(r'[^a-zA-Z0-9]', '', word)
      # Write the key-value pair to STDOUT to be processed by the reducer.
      # First we compare if the word appears on the dictionary
      # If it appears we give it corresponding value, if not we just give zero value
         if word in scores:
            print '%s%s%d' % (word,separator,scores[word])
         else:
            print '%s%s%d' % (word,separator,0)

if __name__ == "__main__":
    main()

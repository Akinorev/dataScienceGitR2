#!/usr/bin/env python
import sys
from itertools import groupby
from operator import itemgetter

curr_word = None
curr_count = 0
word = None

def read_mapper_output(file, separator='\t'):
    for line in file:
        yield line.rstrip().split(separator, 1)

def main(separator='\t'):
# Process each key-value pair from the mapper
   for line in sys.stdin:

      # Get the key and value from the current line
      word, count = line.split('\t')

      # Convert the count to an int
      count = int(count)

      # If the current word is the same as the previous word, increment its
      # count, otherwise print the words count to STDOUT
      if word == curr_word:
         curr_count += count
      else: 

         # Write word and its number of occurrences as a key-value pair to STDOUT
         if curr_word:
            print '{0}\t{1}'.format(curr_word, curr_count)

         curr_word = word
         curr_count = count

   # Output the count for the last word
   if curr_word == word:
      print '{0}\t{1}'.format(curr_word, curr_count)

if __name__ == "__main__":
   main()
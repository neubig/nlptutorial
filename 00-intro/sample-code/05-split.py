#!/usr/bin/python

import string

sentence = "this is a pen"
words = sentence.split(" ")

for word in words:
    print word

print string.join(words, " ||| ")

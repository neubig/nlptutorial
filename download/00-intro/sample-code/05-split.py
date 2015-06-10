#!/usr/bin/python3

sentence = "this is a pen"
words = sentence.split(" ")

for word in words:
    print(word)

print(" ||| ".join(words))

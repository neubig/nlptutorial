#!/usr/bin/python

from nltk.tree import Tree
import sys

# A program to display parse trees (in Penn treebank format) with NLTK
#
#  To install NLTK on ubuntu: sudo apt-get install python-nltk

for line in sys.stdin:
    t = Tree.parse(line)
    t.draw()
#!/usr/bin/python

from collections import defaultdict

my_dict = defaultdict(lambda: 0)

my_dict["eric"] = 33

print my_dict["eric"]
print my_dict["fred"]

for foo, bar in sorted(my_dict.items()):
    print "%s --> %r" % (foo, bar)




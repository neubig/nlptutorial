#!/usr/bin/python3

my_dict = {"alan": 22, "bill": 45, "chris": 17, "dan": 27}

my_dict["eric"] = 33

print(len(my_dict))
print(my_dict["chris"])

if "dan" in my_dict:
    print("dan exists in my_dict")

for foo, bar in sorted(my_dict.items()):
    print("%s --> %r" % (foo, bar))




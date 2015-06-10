#!/usr/bin/python3

def add_and_abs(x, y):
    z = x + y
    if z >= 0:
        return z
    else:
        return z * -1

print(add_and_abs(-4, 1))

def test_add_and_abs():
    if add_and_abs(3, 1) != 4:
        print("add_and_abs(3, 1) != 4 (== %d)" % add_and_abs(3, 1))
        return 0
    if add_and_abs(-4, 1) != 3:
        print("add_and_abs(-4, 1) != 3 (== %d)" % add_and_abs(-4, 1))
        return 0
    return 1

print(test_add_and_abs())

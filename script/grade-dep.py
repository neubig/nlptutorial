#!/usr/bin/python

import sys

ref_file = open(sys.argv[1], "r")
refs = ref_file.readlines()
tst_file = open(sys.argv[2], "r")
tsts = tst_file.readlines()

total = 0
correct = 0
for i, ref_line in enumerate(refs):
    tst_line = tsts[i]
    ref_line = ref_line.strip()
    tst_line = tst_line.strip()
    if len(ref_line) > 0:
        (rnum, rname, rname1, rpos, rpos1, runder, rhead, rdep) = ref_line.split('\t')
        (tnum, tname, tname1, tpos, tpos1, tunder, thead, tdep) = tst_line.split('\t')
        total += 1
        if rhead == thead:
            correct += 1

print "%f%% (%d/%d)" % (float(correct)/total*100, correct, total)

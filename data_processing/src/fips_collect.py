#!/usr/bin/python

import sys

for line in open(sys.argv[1]):
    line = line.strip()
    w = line.split('\t')
    print w[0] + "\t" + w[1] + "\t" + w[2] + w[3]

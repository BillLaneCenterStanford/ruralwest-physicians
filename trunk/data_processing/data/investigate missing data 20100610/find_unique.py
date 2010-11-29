import sys
import re

setFIPS = set([])
for line in open(sys.argv[1]):
    for s in re.findall('\d{5}', line):
        setFIPS.add(s)

print len(setFIPS)

setFinal = set([])
for line in open(sys.argv[2]):
    s = line.strip().split()[0]
    if len(s) == 5:
        setFinal.add(s)

#print len(setFinal)

#print len(setFIPS.difference(setFinal))

#print len(setFinal.difference(setFIPS))

#print '\n'.join(setFIPS.difference(setFinal))



import os
import sys
import re
from xml.dom import minidom

# TODO remove the fips 100000

path = '../data'
for f in os.listdir(path):
    segs = f.split('.')
    fname = segs[0]
    ext = ''
    if len(segs) > 1:
        ext = segs[1]
    if fname.startswith('census') and ext == 'xml':
        # open xml file
        print path + '/' + f
        xmldoc = minidom.parse(path + '/' + f)

        # output file
        print path + '/' + fname + '_totalpop.csv'
        fout = open(path + '/' + fname + '_totalpop.csv', 'w')

        for county in xmldoc.firstChild.getElementsByTagName('county'):
            fips = str(county.getElementsByTagName('fips')[0].firstChild.data) 
            totPop = str(county.getElementsByTagName('totPop')[0].firstChild.data)

            if fips == '100000':
                continue

            line = '%05d,%s' %(int(fips), totPop)
            print line

            fout.write(line + '\n')

        fout.close()


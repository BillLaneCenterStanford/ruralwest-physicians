import os
import sys

def visit(nouse, dirname, names):
    dirname = dirname.replace(' ', '\\ ')
    for n in names:
        if n == '.svn':
            print 'rm -rf ' + dirname + '/' + n

os.path.walk(sys.argv[1], visit, 'nouse')


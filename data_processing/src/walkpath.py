import os

def visit(nouse, dirname, names):
    print 'in dir ' + dirname
    for n in names:
        print '\t' + n


os.path.walk('../', visit, 'nouse')

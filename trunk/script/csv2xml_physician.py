
import sys
from xml.dom.minidom import Document

def atomNode(doc, field_name, value_text):
    result_node = doc.createElement(field_name)
    text_node = doc.createTextNode(value_text)
    result_node.appendChild(text_node)
    return result_node

fi = sys.argv[1]
fo = sys.argv[2]
#fi = '../data/physician_by_county_1909.csv'
#fo = '../data/physician_by_county_1909.xml'

# create a document object and append a records node
doc = Document()
records = doc.createElement('records')
doc.appendChild(records)

line_to_skip = 0 # no skip
for line in open(fi):
    # skip initial lines
    if line_to_skip > 0:
        line_to_skip -= 1
        continue

    # create a user data node
    user = doc.createElement('county')

    [fips, countyname, numPhys, numPop, state] =\
        line.strip().split('\t')

    fips = str(int(fips))
    countyname = countyname.lower()
    state = state.lower()

    user.appendChild(atomNode(doc, 'fips', fips))
    user.appendChild(atomNode(doc, 'countyname', countyname))
    user.appendChild(atomNode(doc, 'numPhys', numPhys))
    user.appendChild(atomNode(doc, 'numPop', numPop))
    user.appendChild(atomNode(doc, 'state', state))

    records.appendChild(user)

print doc.toprettyxml()
doc.writexml(open(fo, 'w'), indent = '  ', addindent = '  ', newl='\n')


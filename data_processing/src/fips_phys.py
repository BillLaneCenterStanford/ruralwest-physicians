#!/usr/bin/python

import sys
import os

# construct double-map to query fips
dict_fips = {}
for line in open('../data/FIPS.txt'):
    line = line.strip().lower()
    words = line.split('\t')
    state = words[0]
    county = words[1]
    fips = words[2]
    if not dict_fips.has_key(state):
        dict_fips[state] = {}
    dict_fips[state][county] = fips

# query example, expect output "06085"
#print dict_fips['california']['santa clara']

# read physician data
dict_phys = {}
path = '../data/physician_by_state'
for f in os.listdir(path):
    state = f.split('.')[0].lower()
    if not dict_phys.has_key(state):
        dict_phys[state] = {}

    for line in open(path + '/' + f):
        words = line.strip().lower().split('\t')
        if len(words) < 4:      # ignore incomplete lines
            continue
        county = words[2]
        if not dict_phys[state].has_key(county):
            dict_phys[state][county] = [0, 0]
        # no. of physicians
        dict_phys[state][county][0] += int(words[3])
        # no. of population
        if words[1].isdigit():
            dict_phys[state][county][1] += int(words[1])
        else:   # ignore those with 'n-a'
            dict_phys[state][county][1] += 0

# output result, number of physicians in each county
for k1 in dict_phys.keys():
    for k2 in dict_phys[k1].keys():
        state = k1
        county = k2
        if not dict_fips[k1].has_key(county):
            # a county no longer exist
            continue
        fips = dict_fips[state][county]
        cnt_phys = str(dict_phys[state][county][0])
        cnt_popu = str(dict_phys[state][county][1])
        print '%s\t%s\t%s\t%s\t%s' % (fips, county, cnt_phys, cnt_popu, state)

# find unique number of county
list_county = []
for f in os.listdir(path):
    state = f.split('.')[0].lower()
    for line in open(path + '/' + f):
        county = line.strip().lower().split('\t')[2]
        list_county.append(state + ' ' + county)
set_county = set(list_county)
#print len(set_county)




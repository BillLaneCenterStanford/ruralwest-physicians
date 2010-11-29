
import sqlite3
import os
import sys

# create a connection
con = sqlite3.connect('../database')

# create a cursor object
c = con.cursor()



###############################################################################
# create table physician by county
c.execute('drop table physician_by_county')
c.execute('''create table physician_by_county
             (fips text, county text, num_phys long, num_pop long, state text)
             ''')

# insert data
num_line_to_skip = 1
for line in open('../data/physician by county.txt'):
    if num_line_to_skip > 0:
        num_line_to_skip -= 1
        continue
    words = line.strip().lower().split('\t')
    words[2] = int(words[2])
    words[3] = int(words[3])
    c.execute('insert into physician_by_county values (?, ?, ?, ?, ?)', words)

# save the changes
con.commit()

# show tuples
c.execute('select * from physician_by_county order by num_phys desc limit 10')
for row in c:
    print row



###############################################################################
# create table county to FIPS mapping
c.execute('drop table county_fips')
c.execute('''create table county_fips (state text, county text, fips text)''')

# insert data
for line in open('../data/FIPS.txt'):
    words = line.strip().lower().split('\t')
    c.execute('insert into county_fips values (?, ?, ?)', words)

# save changes
con.commit()

# show tuples
# join on fips, because there are counties with same name in different states
c.execute('''select physician_by_county.*, county_fips.*
             from physician_by_county, county_fips
             where physician_by_county.fips=county_fips.fips limit 20''')
for row in c:
    print row







# save the changes
con.commit()

# close cursor
c.close()




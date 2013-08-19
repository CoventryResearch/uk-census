import pandas as pd
import numpy as np
import time
import logging
import sys
import csv

category = sys.argv[1]

logfile = 'log/census_to_' + category + '.log'
print "Opening log file " + logfile
logging.basicConfig(filename=logfile, level=logging.DEBUG)

lookupfile = "data/OA11LookUp.txt"
print 'Reading lookup file' + lookupfile
lookupdata = pd.read_csv(lookupfile, delimiter='\t')
# lookupdata = lookupdata[0:999]

censusfile = 'data/Census11Data.txt'
print 'Reading census file '+censusfile
censusdata = pd.read_csv(censusfile, delimiter='\t', na_values=[-1])
for col in ['oaid', 'popx', 'popy']:
	censusdata = censusdata.drop(col, axis=1)

print "Grouping lookup data by " + category
grouped_lookup = lookupdata.groupby(category)
size = grouped_lookup.size()

print "Summing census data over " + category + " values"
rows_list = []
group_list = []
for name, group in grouped_lookup:
	oacode_list = group['OACode'].values
	# print name
	# print oacode_list
	filtered_censusdata = censusdata[censusdata['oacode'].isin(oacode_list)] # Bottleneck
	summed_filtered_censusdata = filtered_censusdata.sum()
	rows_list.append(summed_filtered_censusdata)
	group_list.append(name)

print 'Creating data frame'
df = pd.DataFrame(rows_list)

print 'Appending ' + category + ' ids'
df[category] = group_list

print 'Reordering ' + category + ' column'
df = df.reindex(columns=pd.Index([category]).append(df.columns - [category]))

outfile = 'data/Census11_by_'+category+'.csv'
print 'Writing to ' + outfile
df.to_csv(outfile, sep=',', index_label='index')#, quoting=csv.QUOTE_NONNUMERIC)

print 'Done'
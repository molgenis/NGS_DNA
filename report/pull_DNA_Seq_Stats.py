import argparse
import os
import os.path
import math
import sys, getopt
import json
import functools
import locale
import subprocess
import threading
import time
import tempfile
import warnings
import Queue
import pprint
import operator
import re 
import decimal

# valid column names
# from http://picard.sourceforge.net/picard-metric-definitions.shtml#gcBias
COLNAMES_HS = {
	'GENOME_SIZE': 'Genome size (bp)',
 	'BAIT_TERRITORY': 'Bait size (bp)',
 	'TARGET_TERRITORY': 'Target size (bp)',
 	'TOTAL_READS': ',Total number of reads',
 	'PCT_PF_UQ_READS_ALIGNED': 'Fraction reads aligned (UQ)',
 	'PF_UQ_BASES_ALIGNED': 'Aligned bases (Mb)',
 	'ON_BAIT_BASES': 'onBaitBases',
 	'NEAR_BAIT_BASES': 'nearBaitBases',
 	'OFF_BAIT_BASES': 'offBaitBases',
 	'MEAN_BAIT_COVERAGE': 'Mean bait coverage',
 	'MEAN_TARGET_COVERAGE': 'Mean target coverage',
	'PCT_TARGET_BASES_2X': 'Fraction target covered >= 2x',
	'PCT_TARGET_BASES_10X': 'Fraction target covered >= 10x',
	'PCT_TARGET_BASES_20X': 'Fraction target covered >= 20x',
	'PCT_TARGET_BASES_30X': 'Fraction target covered >= 30x',
	'PCT_USABLE_BASES_ON_TARGET': 'Fraction usable bases on target'

}
COLNAMES_INSERTSIZE = {
	'MEDIAN_INSERT_SIZE' : 'medianInsertSize',
	'MEAN_INSERT_SIZE' :'meanInsertSize',
	'STANDARD_DEVIATION' : 'standardDeviation'
}
COLNAMES_ALIGNMENT = {
	'MEAN_READ_LENGTH' : 'meanReadLength', 
	'STRAND_BALANCE' : 'strandBalance'	
}

COLNAMES_CONCORDANCE = {
	'nSNPs':'nSNPs',
 	'Overall_concordance': 'overallConcordance'
}

import re

def natural_sort(l): 
    convert = lambda text: int(text) if text.isdigit() else text.lower() 
    alphanum_key = lambda key: [ convert(c) for c in re.split('([0-9]+)', key) ] 
    return sorted(l, key = alphanum_key)

def meanStd(d):
    """
    Calculate the mean and standard deviation of histogram d.

    @arg d: Histogram of real values.
    @type d: dict[int](float)

    @returns: The mean and standard deviation of d.
    @rtype: tuple(float, float)
    """
    sum_l = 0
    sumSquared_l = 0
    n = 0

    for i in d:
        sum_l += i * d[i]
        sumSquared_l += (d[i] * (i * i))
        n += d[i]
    #for
    
    mean = sum_l / float(n)
    return {'Mean.insertsize' : mean, 'stDev' :+math.sqrt((sumSquared_l / float(n)) - (mean * mean))}
    
def parse_hs_metrics_file(hs_metrics_path):
    """Given a path to a Picard CollectHsMetrics output file, return a
    dictionary consisting of its column, value mappings.
    """
    data_mark = 'BAIT_SET'
    tokens = []
    with open(hs_metrics_path, 'r') as source:
        line = source.readline().strip()
        fsize = os.fstat(source.fileno()).st_size
        while True:
            if not line.startswith(data_mark):
                # encountering EOF before metrics is an error
                if source.tell() == fsize:
                    raise ValueError("Metrics not found inside %r" % \
                            hs_metrics_path)
                line = source.readline().strip()
            else:
                break

        assert line.startswith(data_mark)
        # split header line and append to tokens
        tokens.append(line.split('\t'))
        # and the values (one row after)
        tokens.append(source.readline().strip().split('\t'))
    data = {}
    for col, value in zip(tokens[0], tokens[1]):
      if col not in COLNAMES_HS:
        continue;	
      else:
	
        if not value:
            data[COLNAMES_HS[col]] = None
        elif col.startswith('PCT') or col.startswith('MEDIAN') or col.startswith('MEAN'):
            if value != '?':
                data[COLNAMES_HS[col]] = float(value)
            else:
                warnings.warn("Undefined value for %s in %s: %s" % (col,
                    hs_metrics_path, value))
                data[COLNAMES_HS[col]] = None
	elif col == "BAIT_SET":
	    data[COLNAMES_HS[col]] = value
    return data
def parse_concordance_file(concordance_path):
    """Given a path to a concordance output file, return a
    dictionary consisting of its column, value mappings.
    """
    data_mark = 'name'
    tokens = []
    with open(concordance_path, 'r') as source:
        line = source.readline().strip()
        fsize = os.fstat(source.fileno()).st_size
        while True:
            if not line.startswith(data_mark):
                # encountering EOF before metrics is an error
                if source.tell() == fsize:
                    raise ValueError("Metrics not found inside %r" % \
                            concordance_path)
                line = source.readline().strip()
            else:
                break

        assert line.startswith(data_mark)
        # split header line and append to tokens
        tokens.append(line.split('\t'))
        # and the values (one row after)
        tokens.append(source.readline().strip().split('\t'))
    data = {}
    for col, value in zip(tokens[0], tokens[1]):
      if col not in COLNAMES_INSERTSIZE:
        continue;
      else:
        if not value:
            data[COLNAMES_CONCORDANCE[col]] = None
        elif col.startswith('PCT') or col.startswith('MEDIAN'):
            if value != '?':
                data[COLNAMES_CONCORDANCE[col]] = float(value)
            else:
                warnings.warn("Undefined value for %s in %s: %s" % (col,
                    concordance_path, value))
                data[COLNAMES_CONCORDANCE[col]] = None
    return data

def parse_insertSize_metrics_file(insertSize_metrics_path):
    """Given a path to a Picard CollectMultipleMetrics [insertSize] output file, return a
    dictionary consisting of its column, value mappings.
    """
    data_mark = 'MEDIAN_INSERT_SIZE'
    tokens = []
    with open(insertSize_metrics_path, 'r') as source:
        line = source.readline().strip()
        fsize = os.fstat(source.fileno()).st_size
        while True:
            if not line.startswith(data_mark):
                # encountering EOF before metrics is an error
                if source.tell() == fsize:
                    raise ValueError("Metrics not found inside %r" % \
                            insertSize_metrics_path)
                line = source.readline().strip()
            else:
                break

        assert line.startswith(data_mark)
        # split header line and append to tokens
        tokens.append(line.split('\t'))
        # and the values (one row after)
        tokens.append(source.readline().strip().split('\t'))
    data = {}
    for col, value in zip(tokens[0], tokens[1]):
	if col not in COLNAMES_INSERTSIZE:
          continue;
	else:
          if not value:
              data[COLNAMES_INSERTSIZE[col]] = None
          elif value != '?':
              data[COLNAMES_INSERTSIZE[col]] = float(value)
          else:
              warnings.warn("Undefined value for %s in %s: %s" % (col,
              insertSize_metrics_path, value))
              data[COLNAMES_INSERTSIZE[col]] = None

    return data
def parse_alignment_metrics_file(alignment_metrics_path):
    """Given a path to a Picard CollectMultipleMetrics [alignmentMetrics] output file, return a
    dictionary consisting of its column, value mappings.
    """
    data_mark = 'CATEGORY'
    tokens = []
    with open(alignment_metrics_path, 'r') as source:
        line = source.readline().strip()
        fsize = os.fstat(source.fileno()).st_size
        while True:
            if not line.startswith(data_mark):
                # encountering EOF before metrics is an error
                if source.tell() == fsize:
                    raise ValueError("Metrics not found inside %r" % \
                            alignment_metrics_path)
                line = source.readline().strip()            
	    else:
                break

        assert line.startswith(data_mark)
        # split header line and append to tokens
        tokens.append(line.split('\t'))
        # and the values (one row after)
        tokens.append(source.readline().strip().split('\t'))

        if line.startswith('UNPAIRED'):
          # and the values (one row after)
          tokens.append(line.split('\t'))
        else:
          # and the values (three rows after)
          source.readline().strip()
          tokens.append(source.readline().strip().split('\t'))

    data = {}
    for col, value in zip(tokens[0], tokens[1]):
        if col not in COLNAMES_ALIGNMENT:
                continue;
        else:
	  if not value:
            data[COLNAMES_ALIGNMENT[col]] = None
          elif value != '?':
            data[COLNAMES_ALIGNMENT[col]] = float(value)
          else:
            warnings.warn("Undefined value for %s in %s: %s" % (col,
            alignment_metrics_path, value))
            data[COLNAMES_HS[col]] = None

    return data

def getFlagstat(fsFile):
  """
  Get the number of mapped reads from flagstat.
  """

  with open (fsFile, 'r') as f:
    for line in f:
      line = line.rstrip('\n')
      if "total" in line:
        total = int(line.split(' ')[0])
      if "mapped (" in line:
        mapped = int(line.split(' ')[0])
      if "duplicates" in line:
        dup = int(line.split(' ')[0])
	print dup 
	print total
    percentage=float(dup)/float(total) *100
    return {'Total number of mapped reads' : mapped, 'Total number of reads' : total , 'Number of Duplicates' : dup , 'Duplicate percentage' : percentage}

def getHist(file, begin, end):
  """
  Get the GC content per sequence from the fastqc data file given a sampleid.
  """

  collect = False
  data = {}

  with open (file, 'r') as f:
    for line in f:
      line = line.rstrip('\n')
      if collect and end in line:
        collect = False
      if collect and len(line)>0:
        data[int(line.split('\t')[0])]=float(line.split('\t')[1])
      if begin in line:
        collect = True
  return data

def main(argv):
  """
  Main entry point.
  """
  alignmentMetrics= ''
  concordance= ''
  hsMetrics= ''
  insertSizeMetrics= ''
  flagstats = ''
   
  try:
    opts, args = getopt.getopt(argv,"h:a:c:s:i:f:",["alignmentMetrics=","concordance=","hsMetrics=","insertSizeMetrics=","flagstats="])
         
  except getopt.GetoptError:
    print 'pull_DNA_Seq_Stats.py\n -a <alignmentMetrics>\n -c <concordance>\n -s <hsMetrics>\n -i <insertSizeMetrics>\n -f <flagstats>\n'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'pull_DNA_Seq_Stats.py\n -a <alignmentMetrics>\n -c <concordance>\n -s <hsMetrics>\n -i <insertSizeMetrics>\n -f <flagstats>\n'
      sys.exit(2)
    elif opt in ("-a", "--alignmentMetrics"):
       alignmentMetrics = arg
    elif opt in ("-c", "--concordance"):
       concordance = arg
    elif opt in ("-s", "--hsMetrics"):
       hsMetrics = arg
    elif opt in ("-i", "--insertSizeMetrics"):
       insertSizeMetrics = arg
    elif opt in ("-f", "--flagstats"):
       flagstats = arg   
         
  insertSizeFile = insertSizeMetrics
  flagstatFile = flagstats
  hsMetrics = hsMetrics
  concordance = concordance
  alignmentMetrics = alignmentMetrics
  data = {}
    
  if os.path.isfile(insertSizeFile) and os.access(insertSizeFile, os.R_OK):
    data['insertSizeHist'] = getHist(insertSizeFile, 'insert_size', 'EOF')

  data['insertSizeMetrics'] = parse_insertSize_metrics_file(insertSizeMetrics)
  data['map2Full'] = getFlagstat(flagstatFile)
  data['hsMetrics'] = parse_hs_metrics_file(hsMetrics)
  data['alignmentMetrics'] = parse_alignment_metrics_file(alignmentMetrics)
  data['concordance'] = parse_concordance_file(concordance)

  #print alignmentMetrics stats in tablular format
  alignmentMetrics = data['alignmentMetrics']
  for key in alignmentMetrics.keys():
    print("{0:<30s}\t{1:<40}".format(key, alignmentMetrics[key]))

  #print concordance stats in tablular format
  concordance = data['concordance']
  for key in concordance.keys():
    print("{0:<30s}\t{1:<40}".format(key, concordance[key]))

  #print hsMetrics stats in tablular format
  hsMetrics = data['hsMetrics']
  for key in natural_sort(hsMetrics.keys()):
    print("{0:<30s}\t{1:<40}".format(key, hsMetrics[key]))

  #print insertSizeMetrics stats in tablular format
  insertSizeMetrics = data['insertSizeMetrics']
  for key in insertSizeMetrics.keys():
    print("{0:<30s}\t{1:<40}".format(key, insertSizeMetrics[key]))

  #print flagstat stats in tablular format
  map2Full = data['map2Full']
  for key in map2Full.keys():
    print("{0:<30s}\t{1:<40}".format(key, map2Full[key]))

if __name__ == "__main__":
  main(sys.argv[1:])

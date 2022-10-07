import sys
import csv

reader = csv.DictReader(open(sys.argv[1], "rb"), delimiter=",")
print sys.argv[1],sys.argv[2]
barcode2file=sys.argv[2]+'/externalSampleIDs.txt'
with open(barcode2file, 'w') as out:
    for row in reader:
        for (k,v) in row.items():		
            if "externalSampleID" in row:
                open(barcode2file, 'a').close()
                if k == "externalSampleID":
                    out.write(v+'\n')

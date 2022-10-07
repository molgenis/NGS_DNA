import sys
import csv

reader = csv.DictReader(open(sys.argv[1], "rb"), delimiter=",")

count=0
for row in reader:
    for (k,v) in row.items():
        if "capturingKit" in row:
            if k == "capturingKit":
                if count == 0:
                    print v
                    count+=1

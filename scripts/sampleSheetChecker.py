import sys
import csv

reader = csv.DictReader(open(sys.argv[1], "rb"), delimiter=",")
project=open("project.txt.tmp","w")
build=open("build.txt.tmp","w")
species=open("species.txt.tmp","w")
sampleType=open("sampleType.txt.tmp","w")
externalSampleID=open("externalSampleID.txt.tmp","w")
capturingKit=open("capturingKit.txt.tmp","w")
for row in reader:
	for (k,v) in row.items():		
		if "project" in row:
			if k == "project":
				project.write(v+'\n')
		if "build" in row:
			if k == "build":
				build.write(v+'\n')
		if "species" in row:
			if k == "species":
				species.write(v+'\n')
		if "sampleType" in row:
			if k == "sampleType":
				sampleType.write(v+'\n')
		if "externalSampleID" in row:
			if k == "externalSampleID":
				externalSampleID.write(v+'\n')
		if "capturingKit" in row:
			if k == "capturingKit":
				capturingKit.write(v+'\n')

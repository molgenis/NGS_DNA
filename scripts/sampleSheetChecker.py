import sys
import csv

reader = csv.DictReader(open(sys.argv[1], "rb"), delimiter=",")
project=open("project.txt.tmp","w")
build=open("build.txt.tmp","w")
capturingKit=open("capturingKit.txt.tmp","w")
sampleType=open("sampleType.txt.tmp","w")
externalSampleID=open("externalSampleIDs.txt.tmp","w")

count=0
for row in reader:
	for (k,v) in row.items():		
		if "project" in row:
			if k == "project":
				project.write(v+'\n')
		if "capturingKit" in row:
			if k == "capturingKit":
				capturingKit.write(v+'\n')
		if "sampleType" in row:
			if k == "sampleType":
				sampleType.write(v+'\n')
		if "externalSampleID" in row:
			if k == "externalSampleID":
				externalSampleID.write(v+'\n')
	if count == 0:		
		if not "hpoIDs" in row:
			out=open(sys.argv[1]+'.temp',"w")
			print "no hpo id's"
			out.write(','.join(row.keys())+",hpoIDs"+'\n')
			out.write(','.join(row.values())+","+'\n')
			count+=1
			hpoID="no"
	elif hpoID == "no":
		out.write(','.join(row.values())+","+'\n')
			


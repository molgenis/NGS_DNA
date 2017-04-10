import sys
import csv

reader = csv.DictReader(open(sys.argv[1], "rb"), delimiter=",")
updatedSamplesheet=sys.argv[1]+'.tmp'
teller=0
genderBool='false'
with open(updatedSamplesheet, 'w') as out:
        for row in reader:
		if genderBool == 'true':
			break
		else:
                        if "Gender" in row.keys():
				print "Gender is already there, skipped"
				genderBool='true'
				break
			else:
				if teller == 0:
					out.write(','.join(row.keys())+",Gender"+'\n')
					out.write(','.join(row.values())+",Unknown"+'\n')
					teller+=1
				else:
					out.write(','.join(row.values())+",Unknown"+'\n')


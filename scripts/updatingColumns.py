import sys
import csv
from shutil import copyfile

reader = csv.DictReader(open(sys.argv[1], "rb"), delimiter=",")
columnName=sys.argv[2]
updatedSamplesheet=sys.argv[1]+'.tmp'
teller=0
columnBool='false'
with open(updatedSamplesheet, 'w') as out:
	for row in reader:
		if columnBool == 'true':
			break
		else:
			if columnName in row.keys():
				print columnName + " is already there, skipped"
				columnBool='true'
				copyfile(sys.argv[1], updatedSamplesheet)	
				break
			else:
				default=''
				if columnName == 'FirstPriority':
					default="FALSE"
				elif columnName == 'Gender':
					default="Unknown"
				print columnName
				if teller == 0:
					out.write(','.join(row.keys())+","+columnName+'\n')
					out.write(','.join(row.values())+","+default+'\n')
					teller+=1
				else:
					out.write(','.join(row.values())+","+default+'\n')


import sys
import csv

my_dict = {}
with open(sys.argv[1]) as inf:
	for line in inf:
		parts = line.rstrip("\n").split("\t") # split line into parts
		key = parts[0]+"^"+parts[1]+"^"+parts[2]+"^"+parts[3]+"^"+parts[5]+"^"+parts[6]

		if key not in my_dict:
			my_dict[key] = []
		my_dict[key].append(parts[4])


#for i in my_dict:
#	print(i,my_dict[i])
for k in my_dict:
	data = my_dict[k]
	print k+"^"+','.join(data)

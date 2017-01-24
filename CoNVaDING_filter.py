#!/usr/bin/env python
import sys

finallist=sys.argv[1]
totallist=sys.argv[2]
boom=sys.argv[3]
count = 0
call = []
good="no"
with open(finallist,'r') as f:
    for lines in f:
    	call=lines.split()
        chr = call[0]
	start = call[1]
        stop = call[2]
        gene = call[3]
        vier = call[4]
        vijf = call[5]
        zes = call[6]
        totalinfo = []
        with open(totallist,'r') as t:
                next(t)

                for line in t:
                        totalinfo = line.split()
                        start2 = totalinfo[1]
                        stop2 = totalinfo[2]
                        gene2 = totalinfo[3]
                        ratio = totalinfo[4]
                        auto_z = totalinfo[5]
                        VC = totalinfo[6]

                        if ratio == 'NA':
                                ratio2 = ratio.replace("NA", "0.0")
                        else:
                                ratio2 = ratio
                        if auto_z == 'NA':
                                auto_z2 = auto_z.replace("NA", "0.0")
                        else:
                                auto_z2 = auto_z
                        if VC == 'NA':
                                VC2 = VC.replace("NA", "0.0")
                        else:
                                VC2 = VC

                        ratio3 = float(ratio2)
                        auto_z3 = float(auto_z2)
                        VC3 = float(VC2)

                        if gene == gene2 and start2 >= start and stop2 <= stop:
                                if (ratio3 <= 0.60 or ratio3 >=1.45) and (auto_z3 <= -4 or auto_z3 >= 4.5) and VC3 < 0.1:
                                	count = count + 1

		                if count >= 1:
                                        if (ratio3 <= 0.65 or ratio3 >= 1.40) or (auto_z3 <= -3 or auto_z3 >= 3):
                                       		good="yes"

	if good == "yes":
		print chr,"\t",start,"\t",stop,"\t",gene,"\t",vier,"\t",vijf,"\t",zes,"\t",boom,"\tCoNVaDING has good values"
	else:
		print chr,"\t",start,"\t",stop,"\t",gene,"\t",vier,"\t",vijf,"\t",zes,"\t",boom,"\tCoNVaDING has no good values"

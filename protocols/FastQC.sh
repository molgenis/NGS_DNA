#MOLGENIS ppn=1 mem=2gb walltime=05:59:00

#Parameter mapping
#string tmpName
#string seqType
#string fastq1
#string fastq2
#string srBarcodeFqGz
#string stage
#string checkStage
#string fastqcVersion
#string intermediateDir
#string tmpDataDir
#string project
#string logsDir 
#string groupname

sleep 5

#Load module
${stage} ${fastqcVersion}
${checkStage}
makeTmpDir ${intermediateDir}
tmpIntermediateDir=${MC_tmpFile}

#If paired-end do fastqc for both ends, else only for one
if [ "${seqType}" == "PE" ]
then
	fastqc ${fastq1} \
	${fastq2} \
	-o ${tmpIntermediateDir}
	echo -e "\nFastQC finished succesfull. Moving temp files to final.\n\n"
	cp -r ${tmpIntermediateDir}/* ${intermediateDir}
	echo "copied ${tmpIntermediateDir}/* to ${intermediateDir}"
	rm -rf ${tmpIntermediateDir}
	echo "removed ${tmpIntermediateDir}"
else
	fastqc ${srBarcodeFqGz} \
	-o ${tmpIntermediateDir}
	echo -e "\nFastQC finished succesfull. Moving temp files to final.\n\n"
	cp -r ${tmpIntermediateDir}/* ${intermediateDir}
	echo "copied ${tmpIntermediateDir}/* to ${intermediateDir}"
	rm -rf ${tmpIntermediateDir}
	echo "removed ${tmpIntermediateDir}"
	
fi



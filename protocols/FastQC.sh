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
#string outputFolderFastQC
#string tmpDataDir
#string project
#string logsDir 
#string groupname

#Load module
${stage} "${fastqcVersion}"
${checkStage}

makeTmpDir "${outputFolderFastQC}"
tmpOutputFolderFastQC="${MC_tmpFile}"

#If paired-end do fastqc for both ends, else only for one
if [ "${seqType}" == "PE" ]
then
	fastqc "${fastq1}" \
	"${fastq2}" \
	-o "${tmpOutputFolderFastQC}"
	echo -e "\nFastQC finished succesfull. Moving temp files to final.\n\n"
	mv "${tmpOutputFolderFastQC}"/* "${outputFolderFastQC}"
else
	fastqc "${srBarcodeFqGz}" \
	-o "${tmpOutputFolderFastQC}"
	echo -e "\nFastQC finished succesfull. Moving temp files to final.\n\n"
	mv "${tmpOutputFolderFastQC}"/* "${outputFolderFastQC}"
	
fi



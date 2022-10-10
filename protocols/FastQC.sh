#Parameter mapping
#string tmpName
#string seqType
#string fastq1
#string fastq2
#string srBarcodeFqGz


#string fastqcVersion
#string outputFolderFastQC
#string tmpDataDir
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load module
module load "${fastqcVersion}"
module list

makeTmpDir "${outputFolderFastQC}" "${intermediateDir}"
tmpOutputFolderFastQC="${MC_tmpFile}"

#If paired-end do fastqc for both ends, else only for one
if [ "${seqType}" == "PE" ]
then
	fastqc "${fastq1}" \
	"${fastq2}" \
	-o "${tmpOutputFolderFastQC}"
	echo -e "\nFastQC finished succesfull. Moving temp files to final.\n\n"
	mv -v "${tmpOutputFolderFastQC}"/* "${outputFolderFastQC}"
else
	fastqc "${srBarcodeFqGz}" \
	-o "${tmpOutputFolderFastQC}"
	echo -e "\nFastQC finished succesfull. Moving temp files to final.\n\n"
	mv -v "${tmpOutputFolderFastQC}"/* "${outputFolderFastQC}"

fi

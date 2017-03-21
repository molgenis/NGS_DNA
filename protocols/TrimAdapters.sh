#MOLGENIS nodes=1 ppn=4 mem=4gb walltime=05:00:00

#Parameter mapping
#string logsDir

#string seqType
#string peEnd1BarcodeFqGz
#string peEnd2BarcodeFqGz
#string srBarcodeFqGz
#string peEnd1BarcodeTrimmedFqGz
#string peEnd2BarcodeTrimmedFqGz
#string srBarcodeTrimmedFqGz

#string intermediateDir
#string cutadaptVersion
#string project
#string groupname
#string tmpName


#Load module
module load ${cutadaptVersion}
module list


#If paired-end do cutadapt for both ends, else only for one
if [[ "${seqType}" == "PE" ]]
then
	cutadapt --format=fastq \
	-a AGATCGGAAGAG \
	-o ${peEnd1BarcodeTrimmedFqGz} \
	-p ${peEnd2BarcodeTrimmedFqGz} \
	${peEnd1BarcodeFqGz} ${peEnd2BarcodeFqGz}

	echo "adapters masked"

	mv ${peEnd1BarcodeTrimmedFqGz} ${peEnd1BarcodeFqGz}
	mv ${peEnd2BarcodeTrimmedFqGz} ${peEnd2BarcodeFqGz}
	echo -e "\ncutadapt finished succesfull. Moving temp files to final.\n\n"
	
elif [[ "${seqType}" == "SR" ]]
then
	cutadapt --format=fastq	\
        -a AGATCGGAAGAG \
        -o ${srBarcodeTrimmedFqGz} \
	${srBarcodeFqGz}
		
	mv ${srBarcodeTrimmedFqGz} {srBarcodeFqGz}
	echo -e "\ncutadapt finished succesfull. Moving temp files to final.\n\n"
fi

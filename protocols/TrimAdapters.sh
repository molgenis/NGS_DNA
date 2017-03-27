#MOLGENIS ppn=4 mem=8gb walltime=07:00:00

#Parameter mapping
#string logsDir

#string seqType
#string peEnd1BarcodeFqGz
#string peEnd2BarcodeFqGz
#string srBarcodeFqGz
#string peEnd1BarcodeTrimmedFqGz
#string peEnd2BarcodeTrimmedFqGz
#string peEnd1BarcodeTrimmedFq
#string peEnd2BarcodeTrimmedFq
#string srBarcodeTrimmedFqGz
#string srBarcodeTrimmedFq

#string intermediateDir
#string cutadaptVersion
#string project
#string groupname
#string tmpName

#Load module
module load ${cutadaptVersion}
module load pigz
module list


#If paired-end do cutadapt for both ends, else only for one
if [[ "${seqType}" == "PE" ]]
then
	cutadapt --format=fastq \
	-a AGATCGGAAGAG \
	-A GAGAAGGCTAGA \
	--minimum-length 20 \
	-o ${peEnd1BarcodeTrimmedFq} \
	-p ${peEnd2BarcodeTrimmedFq} \
	${peEnd1BarcodeFqGz} ${peEnd2BarcodeFqGz}
	
	echo "adapters masked, now gzipping with pigz"

	pigz ${peEnd1BarcodeTrimmedFq}
	pigz ${peEnd2BarcodeTrimmedFq}

	echo "copying ${peEnd1BarcodeTrimmedFqGz} ${peEnd1BarcodeFqGz}"
	echo "copying ${peEnd2BarcodeTrimmedFqGz} ${peEnd2BarcodeFqGz}"

	cp ${peEnd1BarcodeTrimmedFqGz} ${peEnd1BarcodeFqGz}
	cp ${peEnd2BarcodeTrimmedFqGz} ${peEnd2BarcodeFqGz}

	
	
elif [[ "${seqType}" == "SR" ]]
then
	cutadapt --format=fastq	\
        -a AGATCGGAAGAG \
	-A GAGAAGGCTAGA \
        -o ${srBarcodeTrimmedFq} \
	${srBarcodeFqGz}
		
	pigz ${srBarcodeTrimmedFq} 
	mv ${srBarcodeTrimmedFqGz} {srBarcodeFqGz}
	echo -e "\ncutadapt finished succesfull. Moving temp files to final.\n\n"
fi

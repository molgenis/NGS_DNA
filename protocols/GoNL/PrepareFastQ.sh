#MOLGENIS ppn=4 mem=8gb walltime=18:00:00 

#Parameter mapping
#string logsDir

#string seqType
#string peEnd1BarcodeFqGz
#string peEnd2BarcodeFqGz
#string srBarcodeFqGz
#string peEnd1BarcodeTrimmedFq
#string peEnd2BarcodeTrimmedFq
#string srBarcodeTrimmedFq
#string peEnd1BarcodeTrimmedPhiXRecodedFqGz
#string peEnd2BarcodeTrimmedPhiXRecodedFqGz

#string intermediateDir
#string cutadaptVersion
#string project
#string groupname
#string tmpName
#list externalSampleID
#string intermediateDir

#string phiXEnd1
#string phiXEnd2
#string seqTkVersion
#string pigzVersion


#Load module
module load ${cutadaptVersion}
module load ${seqTkVersion}
module load ${pigzVersion}
module list

array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

INPUTS=()
for sample in "${externalSampleID[@]}"
do
	array_contains INPUTS "$sample" || INPUTS+=("$sample")    # If bamFile does not exist in array add it
done


#If paired-end do cutadapt for both ends, else only for one
if [[ "${seqType}" == "PE" ]]
then
	cutadapt --format=fastq \
	-a AGATCGGAAGAG \
	-A GAGAAGGCTAGA \
	--minimum-length 20 \
	-o ${TMPDIR}/${peEnd1BarcodeTrimmedFq} \
	-p ${TMPDIR}/${peEnd2BarcodeTrimmedFq} \
	${peEnd1BarcodeFqGz} ${peEnd2BarcodeFqGz}
	echo "barcode trimmed"	
fi

echo "starting with phiX part"
# Spike phiX only once
samp=$(tail -10 ${TMPDIR}/${peEnd1BarcodeTrimmedFq})
phiX=$(tail -10 ${phiXEnd1})

if [ "$samp" = "$phiX" ]; 
then
	echo "Skip this step! PhiX was already spiked in!"
	exit 0
else
	if [ "${seqType}" == "PE" ]
	then
		echo "Append phiX reads"
		cat ${phiXEnd1} >> ${TMPDIR}/${peEnd1BarcodeTrimmedFq}
		cat ${phiXEnd2} >> ${TMPDIR}/${peEnd2BarcodeTrimmedFq}
	fi
fi
echo -e "finished with phiX part...\nstarting with IlluminaEncoding"

checkIlluminaEncoding() {
barcodeFq=$1
barcodeFinalFqGz=$2

lines=($(cat ${barcodeFq} | head -8000 | tail -192 | awk 'NR % 4 == 0'))
count=1
nodecision=0
numberoflines=0
for line in  ${lines[@]}
do
	numberoflines=$(( numberoflines+1 ))
	#check for illumina encoding 1.5
	if [[ "$line" =~ [P-Z] ]] || [[ "$line" =~ [a-g] ]]
		then
        	encoding="1.5"
	        if [[ ${count} -eq 1 ]]
        	then
            	lastEncoding=${encoding}
            	count=$(( count+1 ))
        	fi

        	if ! [ "${encoding}" == "${lastEncoding}" ]
        	then
	            	echo "error, encoding not possible"
			echo "${encoding} is not matching last encoding (${lastEncoding}"
            		echo "LINE: " $line
			exit 1
        	fi
        	lastEncoding=${encoding}

	#check for illumina encoding 1.8/1.9
	elif [[ "$line" =~ [0-9] ]] || [[ "$line" =~ [\<=\>?] ]]
     	then
        	encoding="1.9"
	        if [[ ${count} -eq 1 ]]
        	then
        		lastEncoding=${encoding}
	        	count=$(( count+1 ))
        	fi
        	if ! [ "${encoding}" == "${lastEncoding}" ]
        	then
                	echo "error, encoding not possible"
			echo "${encoding} is not matching last encoding (${lastEncoding}"
			echo "LINE: " $line
	                exit 1
                fi
              	lastEncoding="${encoding}"
	elif [[ "$line" =~ @ ]] || [[ "$line" =~ [A-J] ]]
        	then
                nodecision=$(( nodecision+1 ))
	else
		echo "The encoding is not matching to anything, check FastQ documentation (count=$count)"
	fi
done
if [ "${nodecision}" == "${numberoflines}" ]
then
	echo "Within all the lines, no decision was made about the encoding, all the encoding is between A and J. This is then probably an 1.9 encoding sample, so 1.9 is set as encoding"
	encoding="1.9"
fi

if [ "${encoding}" == "1.9" ]
then
	echo "encoding is Illumina 1.8 - Sanger / Illumina 1.9"
	echo "Only gzip the ${barcodeFq} to ${barcodeFinalFqGz}"
	pigz -c ${barcodeFq} > ${barcodeFinalFqGz}

else
	#make fastQ out of the fq.gz file
	echo "converting Illumina encoding"
	seqtk seq ${barcodeFq} -Q 64 -V > ${barcodeFq}.encoded.fq
	echo -e "done..\nNow gzipping ${barcodeFq}.encoded.fq > ${barcodeFinalFqGz}"
	pigz -c ${barcodeFq}.encoded.fq > ${barcodeFinalFqGz}

fi

}

#check illumina encoding using function checkIlluminaEncoding()

#If paired-end do fastqc for both ends, else only for one
if [ "${seqType}" == "PE" ]
then
        checkIlluminaEncoding ${TMPDIR}/${peEnd1BarcodeTrimmedFq} ${peEnd1BarcodeTrimmedPhiXRecodedFqGz}
        checkIlluminaEncoding ${TMPDIR}/${peEnd2BarcodeTrimmedFq} ${peEnd2BarcodeTrimmedPhiXRecodedFqGz}
else
	echo "SeqType unknown"
	exit 1
fi

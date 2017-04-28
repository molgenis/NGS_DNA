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
#list externalSampleID
#string intermediateDir

#Load module
module load ${cutadaptVersion}
module load pigz
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

for i in ${INPUTS[@]}
do
	 awk -v var="$i" -v var2="$intermediateDir" '{if ($2 == var){if ($5=="1"){print "M\nMale" > var2""$2".txt"}else{print "F\nFemale" > var2""$2".txt"}}}' ${intermediateDir}/children.ped
done

#If paired-end do cutadapt for both ends, else only for one
if [[ "${seqType}" == "PE" ]]
then
	cutadapt --format=fastq \
	-a AGATCGGAAGAG \
	-A AGATCGGAAGAG \
#	-A GAGAAGGCTAGA \
	--minimum-length 20 \
	-o ${peEnd1BarcodeTrimmedFq} \
	-p ${peEnd2BarcodeTrimmedFq} \
	${peEnd1BarcodeFqGz} ${peEnd2BarcodeFqGz}
	
	echo "adapters masked, now gzipping with pigz"
	
	
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

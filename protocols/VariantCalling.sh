#Parameter mapping
#string tmpName
#string projectResultsDir
#string gatkVersion
#string tempDir
#string intermediateDir
#string indexFile
#string capturedBatchBed
#string femaleCapturedBatchBed
#string dbSnp
#string sampleBatchVariantCalls
#string sampleBatchVariantCallsIndex
#string tmpDataDir
#string externalSampleID
#string project
#string logsDir
#string groupname
#string sampleMergedRecalibratedBam

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "${element}" == "${seeking}" ]]; then
            in=0
            break
        fi
    done
    return "${in}"
}

#Load GATK module
module load "${gatkVersion}"
module list

makeTmpDir "${sampleBatchVariantCalls}" "${intermediateDir}"
tmpSampleBatchVariantCalls="${MC_tmpFile}"

makeTmpDir "${sampleBatchVariantCallsIndex}" "${intermediateDir}"
tmpSampleBatchVariantCallsIndex="${MC_tmpFile}"

bams=()
INPUTS=()
for sampleID in "${externalSampleID[@]}"
do
        array_contains INPUTS "${sampleID}" || INPUTS+=("$sampleID")    # If bamFile does not exist in array add it
done
baitBatchLength=""
sex=$(less "${projectResultsDir}/general/${externalSampleID}.chosenSex.txt" | awk 'NR==2')
if [ -f "${capturedBatchBed}" ] 
then
	baitBatchLength=$(cat "${capturedBatchBed}" | wc -l)
fi

bams=($(printf '%s\n' "${sampleMergedRecalibratedBam[@]}" | sort -u ))
inputs=$(printf -- '--input=%s ' $(printf '%s\n' "${bams[@]}"))

genderCheck=""

if [[ "${sex}" == "Female" || "${sex}" == "Unknown" ]]
then
	genderCheck="Female"
else
	genderCheck="Male"
fi

ploidy=""
myBed="${capturedBatchBed}"
if [[ ! -f "${capturedBatchBed}" ||  ${baitBatchLength} -eq 0 ]]
then
	echo "skipped ${capturedBatchBed}, because the batch is empty or does not exist"
else
	if [ "${genderCheck}" == "Female" ]
	then
		if [[ "${capturedBatchBed}" == *batch-[0-9]*Y.bed || "${capturedBatchBed}" == *batch-Y.bed ]]
		then
			echo -e "Female, chrY => ploidy=1\nbedfile=${femaleCapturedBatchBed}"
			ploidy=1
			myBed="${femaleCapturedBatchBed}"
		else
			echo -e "Female, autosomal or chrX ==> ploidy=2"
			ploidy=2
		fi
	elif [[ "${genderCheck}" == "Male" ]]
	then
		if [[ "${capturedBatchBed}" == *batch-[0-9]*Y.bed || "${capturedBatchBed}" == *batch-Y.bed || "${capturedBatchBed}" == *batch-Xnp.bed ]]
		then
			ploidy=1
			echo -e "Male, chrY or chrXNonPar ==> ploidy=1"
		else
			ploidy=2
			echo -e "Male, autosomal or chrXPar ==> ploidy=2"
		fi
	fi

	gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx7g" HaplotypeCaller \
	--reference="${indexFile}" \
	${inputs} \
	--dbsnp="${dbSnp}" \
	--output="${tmpSampleBatchVariantCalls}" \
	--intervals="${myBed}" \
	--emit-ref-confidence=GVCF \
	--sample-ploidy="${ploidy}"

	echo -e "\nVariantCalling finished succesfull. Moving temp files to final.\n\n"
	if [ -f "${tmpSampleBatchVariantCalls}" ]
	then
		mv "${tmpSampleBatchVariantCalls}" "${sampleBatchVariantCalls}"
		mv "${tmpSampleBatchVariantCallsIndex}" "${sampleBatchVariantCallsIndex}"

	else
		echo "ERROR: output file is missing"
		exit 1
	fi
fi

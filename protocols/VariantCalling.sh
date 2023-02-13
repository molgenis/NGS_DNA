set -o pipefail
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
#string dedupBam
#string mergedBamRecalibratedTable

#Function to check if array contains value
array_contains () {
	local array="$1[@]"
	local seeking="${2}"
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
	array_contains INPUTS "${sampleID}" || INPUTS+=("${sampleID}")	# If bamFile does not exist in array add it
done
baitBatchLength=""
sex=$(less "${projectResultsDir}/general/${externalSampleID}.chosenSex.txt" | awk 'NR==2')
if [ -f "${capturedBatchBed}" ] 
then
	baitBatchLength=$(wc -l "${capturedBatchBed}" | awk '{print $1}')
fi
mapfile -t bams < <(printf '%s\n' "${dedupBam[@]}" | sort -u)
inputs=$(printf ' -I %s ' "$(printf '%s\n' "${bams[@]}")")

genderCheck=""

if [[ "${sex}" == "Female" || "${sex}" == "Unknown" ]]
then
	genderCheck="Female"
else
	genderCheck="Male"
fi

ploidy='2'
myBed="${capturedBatchBed}"
if [[ ! -f "${capturedBatchBed}" ||  ${baitBatchLength} -eq '0' ]]
then
	echo "skipped ${capturedBatchBed}, because the batch is empty or does not exist"
else
	if [[ "${capturedBatchBed}" == *batch-[0-9]*Y.bed || "${capturedBatchBed}" == *batch-Y.bed ]]
	then
		if [ "${genderCheck}" == "Female" ]
		then
			echo "female, Y"
			myBed="${femaleCapturedBatchBed}"
		else
			echo "male, Y"
		fi
		ploidy=1	
	fi
	# shellcheck disable=SC2086 #${inputs} => gatk needs seperate strings, not one captured in quotes
	gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx7g" HaplotypeCaller \
	-R "${indexFile}" \
	${inputs} \
	-D "${dbSnp}" \
	-O "${tmpSampleBatchVariantCalls}" \
	-L "${myBed}" \
	-ERC GVCF \
	-ploidy "${ploidy}"

	echo -e "\nVariantCalling finished succesfull. Moving temp files to final.\n\n"
	if [ -f "${tmpSampleBatchVariantCalls}" ]
	then
		mv -v "${tmpSampleBatchVariantCalls}" "${sampleBatchVariantCalls}"
		mv -v "${tmpSampleBatchVariantCallsIndex}" "${sampleBatchVariantCallsIndex}"

	else
		echo "ERROR: output file is missing"
		exit 1
	fi
fi

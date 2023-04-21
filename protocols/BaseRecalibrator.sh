set -o pipefail
#Parameter mapping
#string tmpName
#string tempDir
#string intermediateDir
#string project
#string logsDir
#string indexFile 
#string groupname
#string tmpDataDir
#string gatkVersion
#string dbSnp
#string sampleMergedBam
#string sambambaVersion
#string mergedBamRecalibratedTable

module load "${gatkVersion}"
module load "${sambambaVersion}"

module list

#Function to check if array contains value
array_contains () {
	local array="$1[@]"
	local seeking=${2}
	local in=1
	for element in "${!array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
			in=0
			break
		fi
	done
	return "${in}"
}

for bamFile in "${sampleMergedBam[@]}"
do
	array_contains INPUTS "${bamFile}" || INPUTS+=("-I ${bamFile}")    # If bamFile does not exist in array add it
	array_contains INPUTBAMS "${bamFile}" || INPUTBAMS+=("-I ${bamFile}")    # If bamFile does not exist in array add it
done

makeTmpDir "${mergedBamRecalibratedTable}" "${intermediateDir}"
tmpMergedBamRecalibratedTable="${MC_tmpFile}"

sambamba index "${sampleMergedBam}"

# shellcheck disable=SC2068 #${INPUTS} => gatk needs seperate strings, not one captured in quotes
gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx9g" BaseRecalibrator \
-R "${indexFile}" \
${INPUTS[@]} \
--known-sites "${dbSnp}" \
-O "${tmpMergedBamRecalibratedTable}"

mv -v "${tmpMergedBamRecalibratedTable}" "${mergedBamRecalibratedTable}"

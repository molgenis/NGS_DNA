#Parameter mapping
#string tmpName
#string tempDir
#string tmpDataDir
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string projectResultsDir
#string sampleGvcf2Bed
#string sampleMergedBatchVariantCalls
#string gatkVersion
#string gatkJar
#string indexFile
#string ngsversion
#string capturedBed

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


makeTmpDir "${sampleGvcf2Bed}" "${intermediateDir}"
tmpSampleGvcf2Bed="${MC_tmpFile}"

module load "${gatkVersion}"
module load "${ngsversion}"
module list

# Create string with input BAM files for gatk
# This check needs to be performed because Compute generates duplicate values in array

# THIS IS STILL BETA, needs an update once it (if it ever) is used
ml PythonPlus/3.7.4-foss-2018b-v20.02.1
export PYTHONPATH='/groups/umcg-atd/tmp01/umcg-rkanninga/tools/lib/python3.7/site-packages/:$PYTHONPATH'
echo "${PYTHONPATH}"

python "${EBROOTNGS_DNA}/scripts/gvcf2bed.py" \
-I "${sampleMergedBatchVariantCalls}" \
-O "${tmpSampleGvcf2Bed}" \
-b "${capturedBed}" \
-l INFO 
exit 0

mv -v "${tmpSampleGvcf2Bed}" "${sampleGvcf2Bed}"
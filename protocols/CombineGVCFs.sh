#Parameter mapping
#string tmpName
#string tempDir
#string tmpDataDir
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string projectResultsDir
#string externalSampleID
#string sampleMergedBatchVariantCalls
#string capturedBed
#string gatkVersion
#string gatkJar
#string indexFile

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

makeTmpDir "${sampleMergedBatchVariantCalls}" "${intermediateDir}"
tmpSampleMergedBatchVariantCalls="${MC_tmpFile}"

module load "${gatkVersion}"
module list

#Create string with input BAM files for Picard
#This check needs to be performed because Compute generates duplicate values in array
gvcfArray=()

for gvcf in "${projectResultsDir}/variants/gVCF/${externalSampleID}.batch-"*".variant.calls.g.vcf.gz"
do
	array_contains gvcfArray "--variant=${gvcf}" || gvcfArray+=("--variant=${gvcf}")    # If bamFile does not exist in array add it
done
if [  ${#gvcfArray[@]} -ne 0 ]
then
	gatk CombineGVCFs \
	--reference="${indexFile}" \
	"${gvcfArray[@]}" \
	--output="${tmpSampleMergedBatchVariantCalls}"
else
	echo "gvcfArray is empty for ${externalSampleID}"
fi	
echo " moving ${tmpSampleMergedBatchVariantCalls} to ${sampleMergedBatchVariantCalls}"
mv "${tmpSampleMergedBatchVariantCalls}" "${sampleMergedBatchVariantCalls}"

echo " moving ${tmpSampleMergedBatchVariantCalls}.tbi to ${sampleMergedBatchVariantCalls}.tbi"
mv "${tmpSampleMergedBatchVariantCalls}.tbi" "${sampleMergedBatchVariantCalls}.tbi"
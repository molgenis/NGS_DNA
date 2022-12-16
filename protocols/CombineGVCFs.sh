#Parameter mapping
#string tmpName
#string tempDir
#string tmpDataDir
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string projectResultsDir
#string projectBatchCombinedVariantCalls
#string batchID
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

makeTmpDir "${projectBatchCombinedVariantCalls}" "${intermediateDir}"
tmpProjectBatchCombinedVariantCalls="${MC_tmpFile}"

module load "${gatkVersion}"
module list

#Create string with input BAM files for Picard
#This check needs to be performed because Compute generates duplicate values in array

mapfile -t gvcfFiles < <(find ${projectResultsDir}/variants/gVCF/ -name *.batch-${batchID}.variant.calls.g.vcf.gz)

gvcfArray=()
if [[ "${#gvcfFiles[@]}" -ne '0' ]]
then
	for sbatch in "${gvcfFiles[@]}"
	do
		array_contains gvcfArray "--variant ${sbatch}" || gvcfArray+=("--variant ${sbatch}")
	done

	gatk CombineGVCFs \
	--reference "${indexFile}" \
	${gvcfArray[@]} \
	--output "${tmpProjectBatchCombinedVariantCalls}"
	
	mv -v "${tmpProjectBatchCombinedVariantCalls}" "${projectBatchCombinedVariantCalls}"
	mv -v "${tmpProjectBatchCombinedVariantCalls}.tbi" "${projectBatchCombinedVariantCalls}.tbi"
	
else
	echo "There are no gVCF files for batch ${batchID}"
fi	


#Parameter mapping
#string tmpName
#string gatkVersion
#string tempDir
#string intermediateDir
#string indexFile
#string capturedBatchBed
#string dbSnp
#string projectBatchGenotypedVariantCalls
#string project
#string projectBatchCombinedVariantCalls
#list variantCalls
#string tmpDataDir
#string projectJobsDir
#string logsDir
#string groupname

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

makeTmpDir "${projectBatchGenotypedVariantCalls}"
tmpProjectBatchGenotypedVariantCalls="${MC_tmpFile}"

#Load GATK module
module purge
module load "${gatkVersion}"
module list

ALLGVCFs=()

for sbatch in "${variantCalls[@]}"
do
	if [ -f "${sbatch}" ]
	then
		array_contains ALLGVCFs "--variant ${sbatch}" || ALLGVCFs+=("--variant ${sbatch}")
	fi
done
 
if [[ "${#ALLGVCFs[@]}" -ne '0' ]]
then
	gatk --java-options "-Xmx7g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir}" GenotypeGVCFs \
	-R "${indexFile}" \
	${ALLGVCFs[@]} \
	-L "${capturedBatchBed}" \
	-D "${dbSnp}" \
	-O "${tmpProjectBatchGenotypedVariantCalls}"

	mv -v "${tmpProjectBatchGenotypedVariantCalls}" "${projectBatchGenotypedVariantCalls}"
else
	echo ""
	echo "there is nothing to genotype, skipped"
	echo ""
fi

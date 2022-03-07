#Parameter mapping
#string groupname
#string tmpName
#string tmpDataDir
#string tempDir
#string intermediateDir
#string logsDir
#string project
#string projectJobsDir

#string gatkVersion

#string indexFile
#string capturedBatchBed
#string dbSnp

#string projectBatchCombinedVariantCalls
#list sampleBatchVariantCalls
#string projectBatchGenotypedVariantCalls


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

#Load GATK module.
module load "${gatkVersion}"
module list

makeTmpDir "${projectBatchCombinedVariantCalls}"
tmpProjectBatchCombinedVariantCalls="${MC_tmpFile}"

makeTmpDir "${projectBatchGenotypedVariantCalls}"
tmpProjectBatchGenotypedVariantCalls="${MC_tmpFile}"

SAMPLESIZE=$(wc -l "${projectJobsDir}/${project}.csv" | awk '{print $1}')
numberofbatches=$((${SAMPLESIZE} / 200))
ALLGVCFs=()
ALLGVCFsVariants=()

if [ "${SAMPLESIZE}" -gt 200 ]
then
	for b in $(seq 0 "${numberofbatches}")
	do
		if [ -f "${projectBatchCombinedVariantCalls}.${b}" ]
		then
			ALLGVCFsVariants+=("--variant ${projectBatchCombinedVariantCalls}.${b}")
		fi
	done
else
	for sbatch in "${sampleBatchVariantCalls[@]}"
	do
		if [ -f "${sbatch}" ]
		then
			array_contains ALLGVCFsVariants "--variant ${sbatch}" || ALLGVCFsVariants+=("--variant ${sbatch}")
			array_contains ALLGVCFs "${sbatch}" || ALLGVCFs+=("${sbatch}")
		fi
	done
fi 
skip="false"
gvcfSize=${#ALLGVCFsVariants[@]}
if [ "${gvcfSize}" -eq 0 ]
then
	echo ""
	echo "there is nothing to genotype, skipped"
	echo ""
	skip="true"
elif [ "${gvcfSize}" -gt 1 ]
then
	gatk --java-options "-Xmx5g -Djava.io.tmpdir=${tempDir}" CombineGVCFs \
	-R "${indexFile}" \
	"${ALLGVCFsVariants[@]}" \
	-O "${tmpProjectBatchCombinedVariantCalls}"
else
	echo "only 1 file"
	echo "tmpProjectBatchCombinedVariantCalls=${ALLGVCFs[0]}"
	tmpProjectBatchCombinedVariantCalls="${ALLGVCFs[0]}"
fi

if [[ "${skip}"	== "false" ]]
then
	gatk --java-options "-Xmx7g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir}" GenotypeGVCFs \
		-R "${indexFile}" \
		-V "${tmpProjectBatchCombinedVariantCalls}" \
		-L "${capturedBatchBed}" \
		-D "${dbSnp}" \
		-O "${tmpProjectBatchGenotypedVariantCalls}"

	mv "${tmpProjectBatchGenotypedVariantCalls}" "${projectBatchGenotypedVariantCalls}"
	echo "moved ${tmpProjectBatchGenotypedVariantCalls} to ${projectBatchGenotypedVariantCalls} "
fi

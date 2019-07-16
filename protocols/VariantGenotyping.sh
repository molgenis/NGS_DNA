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
#string gatkJar

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

SAMPLESIZE=$(cat "${projectJobsDir}/${project}.csv" | wc -l)
numberofbatches=$(("${SAMPLESIZE}" / 200))
ALLGVCFs=()

if [ "${SAMPLESIZE}" -gt 200 ]
then
    for b in $(seq 0 "${numberofbatches}")
    do
        if [ -f "${projectBatchCombinedVariantCalls}".$b ]
        then
            ALLGVCFs+=(--variant "${projectBatchCombinedVariantCalls}"."${b}")
        fi
    done
else
    for sbatch in "${sampleBatchVariantCalls[@]}"
        do
        if [ -f "${sbatch}" ]
        then
            array_contains ALLGVCFs "--variant ${sbatch}" || ALLGVCFs+=("--variant $sbatch")
        fi
        done
fi 

gvcfSize=${#ALLGVCFs[@]}
if [ ${gvcfSize} -ne 0 ]
then
    gatk --java-options "-Xmx5g -Djava.io.tmpdir=${tempDir}" CombineGVCFs \
        -R "${indexFile}" \
        "${ALLGVCFs[@]}" \
        -O "${tmpProjectBatchCombinedVariantCalls}"

    gatk --java-options "-Xmx7g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir}" GenotypeGVCFs \
        -R "${indexFile}" \
        --variant "${tmpProjectBatchCombinedVariantCalls}" \
        -L "${capturedBatchBed}" \
        --dbsnp "${dbSnp}" \
        -O "${tmpProjectBatchGenotypedVariantCalls}"

    mv "${tmpProjectBatchGenotypedVariantCalls}" "${projectBatchGenotypedVariantCalls}"
    echo "moved ${tmpProjectBatchGenotypedVariantCalls} to ${projectBatchGenotypedVariantCalls} "
else
    echo ""
    echo "there is nothing to genotype, skipped"
    echo ""
fi

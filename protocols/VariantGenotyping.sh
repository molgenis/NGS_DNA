#Parameter mapping
#string tmpName
#string gatkVersion
#string tempDir
#string intermediateDir
#string indexFile
#string capturedBatchBed
#string dbSnp
#string projectBatchGenotypedVariantCalls
#string projectBatchCombinedVariantCalls
#string project
#string tmpDataDir
#string projectJobsDir
#string logsDir
#string groupname

#Function to check if array contains value

makeTmpDir "${projectBatchGenotypedVariantCalls}"
tmpProjectBatchGenotypedVariantCalls="${MC_tmpFile}"

#Load GATK module
module purge
module load "${gatkVersion}"
module list

ALLGVCFs=()

if [[ -f ${projectBatchCombinedVariantCalls} ]]
then
	gatk --java-options "-Xmx7g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir}" GenotypeGVCFs \
	-R "${indexFile}" \
	--variant "${projectBatchCombinedVariantCalls}" \
	-L "${capturedBatchBed}" \
	-D "${dbSnp}" \
	-O "${tmpProjectBatchGenotypedVariantCalls}"

	mv -v "${tmpProjectBatchGenotypedVariantCalls}" "${projectBatchGenotypedVariantCalls}"
else
	echo ""
	echo "there is nothing to genotype, skipped"
	echo ""
fi

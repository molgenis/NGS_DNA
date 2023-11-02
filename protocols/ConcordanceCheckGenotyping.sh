set -o pipefail
#Parameter mapping
#string tmpName
#string gatkVersion
#string tempDir
#string intermediateDir
#string indexFile
#string project
#string tmpDataDir
#string projectJobsDir
#string logsDir
#string groupname
#string externalSampleID
#string concordanceCheckSnps
#string concordanceCheckCallsVcf
#string inputGVCF

#Function to check if array contains value

makeTmpDir "${concordanceCheckCallsVcf}"
tmpConcordanceCheckCallsVcf="${MC_tmpFile}"

#Load GATK module
module purge
module load "${gatkVersion}"
module list

if [[ -f "${inputGVCF}" ]]
then
	gatk --java-options "-Xmx7g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir}" GenotypeGVCFs \
	-R "${indexFile}" \
	--variant "${inputGVCF}" \
	--include-non-variant-sites true \
	-L "${concordanceCheckSnps}" \
	-O "${tmpConcordanceCheckCallsVcf}"

	mv -v "${tmpConcordanceCheckCallsVcf}" "${concordanceCheckCallsVcf}"
	
else
	echo "The ${inputGVCF} does not exist"
fi

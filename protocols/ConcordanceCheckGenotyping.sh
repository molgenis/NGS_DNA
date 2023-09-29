set -o pipefail
#Parameter mapping
#string tmpName
#string gatkVersion
#string tempDir
#string intermediateDir
#string indexFile
#string capturedBatchBed
#string dbSnp
#string project
#string tmpDataDir
#string projectJobsDir
#string logsDir
#string groupname
#string externalSampleID
#string concordanceCheckSnps
#string concordanceCheckCallsVcf

#Function to check if array contains value

makeTmpDir "${concordanceCheckCallsVcf}"
tmpConcordanceCheckCallsVcf="${MC_tmpFile}"

#Load GATK module
module purge
module load "${gatkVersion}"
module list

if [[ -f "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz" ]]
then
	gatk --java-options "-Xmx7g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir}" GenotypeGVCFs \
	-R "${indexFile}" \
	--variant "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz" \
	-L "${concordanceCheckSnps}" \
	-O "${tmpConcordanceCheckCallsVcf}"

	mv -v "${tmpConcordanceCheckCallsVcf}" "${concordanceCheckCallsVcf}"
	
else
	echo "The ${intermediateDir}/${externalSampleID}.merged.g.vcf.gz does not exist"
fi

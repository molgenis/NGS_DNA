set -o pipefail
#Parameter mapping
#string tmpName
#string bcfToolsVersion
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
#string dedupBam

#Function to check if array contains value

makeTmpDir "${concordanceCheckCallsVcf}"
tmpConcordanceCheckCallsVcf="${MC_tmpFile}"

#Load bcfTools module
module purge
module load "${bcfToolsVersion}"
module list

if [[ -f "${dedupBam}" ]]
then

	bcftools mpileup \
	-Ou -f "${indexFile}" \
	"${dedupBam}" \
	-R "${concordanceCheckSnps}" \
	| bcftools call \
	-m -Ob -o "${tmpConcordanceCheckCallsVcf}"

	mv -v "${tmpConcordanceCheckCallsVcf}" "${concordanceCheckCallsVcf}"
else
	echo "The ${dedupBam} does not exist"
fi

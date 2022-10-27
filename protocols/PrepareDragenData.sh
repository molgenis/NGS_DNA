#Parameter mapping
#string logsDir
#string tmpDirectory
#string seqType
#string intermediateDir
#string project
#string groupname
#string tmpName
#string externalSampleID
#string projectPrefix
#string sampleProcessStepID
#string gsBatch
#string projectResultsDir
#string bcfToolsVersion
#string htsLibVersion
#string chainHg19to1000GFile
#list batchID

module load "${bcfToolsVersion}"
module load "${htsLibVersion}"

## copy gVCF files first
combinedIdentifier=$(ls -d "${tmpDirectory}/${gsBatch}/Analysis/"*"-${sampleProcessStepID}")
combinedIdentifier=$(basename "${combinedIdentifier}")
echo  "${combinedIdentifier}" > "${intermediateDir}/${sampleProcessStepID}.txt"

rsync -av "${tmpDirectory}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.hard-filtered.gvcf.gz"* "${intermediateDir}"

## rename gVCF files
rename "${combinedIdentifier}" "${externalSampleID}" "${intermediateDir}/${combinedIdentifier}.hard-filtered.gvcf.gz"*

## add additional code to only replace chr names (column 1)
zcat ${intermediateDir}/${externalSampleID}.hard-filtered.gvcf.gz | perl -p -e 's|chr||' > "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf"


bcftools annotate -x 'FORMAT/AF,FORMAT/F1R2,FORMAT/F2R1,FORMAT/GP' "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf" > "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.tmp"
bgzip -c -f "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.tmp" > "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"

echo "start indexing ${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"
tabix -p vcf "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"
rsync -av "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"* "${projectResultsDir}/variants/gVCF/"



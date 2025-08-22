set -o pipefail
#Parameter mapping
#string logsDir
#string tmpDirectory
#string seqType
#string intermediateDir
#string project
#string groupname
#string tmpName
#string tmpDataDir
#string externalSampleID
#string projectPrefix
#string sampleProcessStepID
#string gsBatch
#string projectResultsDir
#string bedToolsVersion
#string bcfToolsVersion
#string htsLibVersion
#string captured

module load "${bcfToolsVersion}"
module load "${bedToolsVersion}"
module load "${htsLibVersion}"

## first copy the the stats.csv file
if [[ -f "${tmpDataDir}/${gsBatch}/Analysis/stats.tsv" ]]
then
	rsync -v "${tmpDataDir}/${gsBatch}/Analysis/stats.tsv" "${projectResultsDir}/qc/"
fi

## copy (g)VCF files first
combinedIdentifier=$(ls -d "${tmpDataDir}/${gsBatch}/Analysis/"*"-${sampleProcessStepID}")
combinedIdentifier=$(basename "${combinedIdentifier}")
echo  "${combinedIdentifier}" > "${intermediateDir}/${externalSampleID}.txt"
rsync -av "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.hard-filtered"*"vcf.gz"* "${intermediateDir}"


## rename (g)VCF files
rename "${combinedIdentifier}" "${externalSampleID}" "${intermediateDir}/${combinedIdentifier}.hard-filtered."*"vcf.gz"*

bedtools intersect -u -header -a "${intermediateDir}/${externalSampleID}.hard-filtered.vcf.gz" -b "${captured}.merged.bed" > "${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf"
bcftools annotate -x 'FORMAT/AF,FORMAT/F1R2,FORMAT/F2R1,FORMAT/GP' "${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf" > "${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf.tmp"
bgzip -c -f "${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf.tmp" > "${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf.gz"
echo "start indexing ${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf.gz"
tabix -p vcf "${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf.gz"

rsync -av "${intermediateDir}/${externalSampleID}.variant.calls.genotyped.vcf.gz" "${projectResultsDir}/variants/"

rename 'gvcf.gz' 'g.vcf.gz' "${intermediateDir}/${externalSampleID}.hard-filtered.gvcf.gz"*
rsync -av "${intermediateDir}/${externalSampleID}.hard-filtered.g.vcf.gz"* "${projectResultsDir}/variants/gVCF/"

# moving files to results folder
if [[ -f "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.bam" || -f "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/${externalSampleID}.merged.dedup.bam" ]]
then
	rename "${combinedIdentifier}.bam" "${externalSampleID}.merged.dedup.bam" "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/"*".bam"*
	mv -v "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/${externalSampleID}.merged.dedup.bam"{,.md5,.bai} "${projectResultsDir}/alignment/"
	echo "bam files renamed and moved into ${projectResultsDir}/alignment/" 
else
	echo -e "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.bam not found.\nThis can have 2 reasons, the data is already moved before to ${projectResultsDir}/alignment/\n or the data does not exist at all"
fi
# moving qc files
if [[ -f "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.html" ]]
then
	mv -v "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/"*.{bed,json,html} "${projectResultsDir}/qc/"
	rename "${combinedIdentifier}" "${externalSampleID}" "${projectResultsDir}/qc/"*
	echo "qc files renamed in ${projectResultsDir}/qc/" 
else
	echo -e "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.html.\nThis can have 2 reasons:\n1)the data is already moved before to ${projectResultsDir}/qc/ or\n2) the data does not exist at all"
fi
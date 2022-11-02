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
#string bedToolsVersion
#string htsLibVersion
#list batchID
#string captured

module load "${bedToolsVersion}"
module load "${htsLibVersion}"

## copy (g)VCF files first
combinedIdentifier=$(ls -d "${tmpDirectory}/${gsBatch}/Analysis/"*"-${sampleProcessStepID}")
combinedIdentifier=$(basename "${combinedIdentifier}")
echo  "${combinedIdentifier}" > "${intermediateDir}/${externalSampleID}.txt"
rsync -av "${tmpDirectory}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.hard-filtered.vcf.gz"* "${intermediateDir}"
rsync -av "${tmpDirectory}/${gsBatch}/Analysis/${combinedIdentifier}/${combinedIdentifier}.hard-filtered.gvcf.gz"* "${intermediateDir}"

## rename (g)VCF files
rename "${combinedIdentifier}" "${externalSampleID}" "${intermediateDir}/${combinedIdentifier}.hard-filtered."*"vcf.gz"*
rename "${combinedIdentifier}" "${externalSampleID}" "${intermediateDir}/${combinedIdentifier}.hard-filtered."*"vcf.gz"*

for i in "${batchID[@]}"
do
	# splitting the data per chromosome, captured by the ${captured}.batch-${batchID}.bed"
	echo "splitting the data per chromosome, captured by the ${captured}.batch-${i}.bed"
	bedtools intersect -header -a "${intermediateDir}/${externalSampleID}.hard-filtered.vcf.gz" -b "${captured}.batch-${i}.bed" > "${intermediateDir}/${externalSampleID}.batch-${i}.variant.calls.genotyped.vcf"
done

bgzip -c -f "${intermediateDir}/${externalSampleID}.variant.calls.gvcf" > "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"
echo "start indexing ${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"
tabix -p vcf "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"
rsync -av "${intermediateDir}/${externalSampleID}.variant.calls.g.vcf.gz"* "${projectResultsDir}/variants/gVCF/"

# moving files to results folder
mv -v "${tmpDirectory}/${gsBatch}/Analysis/${combinedIdentifier}/"*".bam"* "${projectResultsDir}/alignment/"
rename "${combinedIdentifier}.bam" "${externalSampleID}.merged.dedup.bam" "${projectResultsDir}/alignment/"*".bam"*
echo "bam files renamed in ${projectResultsDir}/alignment/" 

# moving qc files
mv -v "${tmpDirectory}/${gsBatch}/Analysis/${combinedIdentifier}/"*.{bed,json,html} "${projectResultsDir}/qc/"
rename "${combinedIdentifier}" "${externalSampleID}" "${projectResultsDir}/qc/"*
echo "qc files renamed in ${projectResultsDir}/qc/" 
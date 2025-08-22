set -o pipefail
#Parameter mapping
#string logsDir
#string intermediateDir
#string project
#string groupname
#string tmpName
#string sampleProcessStepID
#string bcfToolsVersion
#string htsLibVersion
#string externalSampleID
#string gavinOutputFinalMergedRLV
#string projectResultsDir
#string capturingKit
#string dataDir
#string concordanceCheckCallsVcf

module load "${bcfToolsVersion}"
module load "${htsLibVersion}"

##new prefix will be externalSampleID + sampleProcessStepIDwith new sample identifier --> familyname+umcgnumber
newGVCFSampleIdentifier=$(echo "${externalSampleID}" | awk 'BEGIN {FS="_"}{print $1"_"$2}')

oldIdentifier=$(cat "${intermediateDir}/${externalSampleID}.txt")
echo -e "old:${oldIdentifier}, new:${newGVCFSampleIdentifier}"
echo -e "${oldIdentifier} ${newGVCFSampleIdentifier}" > "${intermediateDir}/${externalSampleID}.newVCFHeader.txt"
echo -e "${oldIdentifier} ${externalSampleID}" > "${intermediateDir}/${externalSampleID}.newConcordanceCheckHeader.txt"

echo "##intervals=[${dataDir}/${capturingKit}/human_g1k_v37/captured.merged.bed]" > "${intermediateDir}/bedfile.txt"
bcftools reheader -s "${intermediateDir}/${externalSampleID}.newVCFHeader.txt" "${gavinOutputFinalMergedRLV}.gz" -o "${gavinOutputFinalMergedRLV}.gz.tmp"
bcftools reheader -s "${intermediateDir}/${externalSampleID}.newConcordanceCheckHeader.txt" "${concordanceCheckCallsVcf}" -o "${concordanceCheckCallsVcf}.tmp"
mv "${concordanceCheckCallsVcf}.tmp" "${concordanceCheckCallsVcf}"
bcftools annotate -h "${intermediateDir}/bedfile.txt" -O v -o "${gavinOutputFinalMergedRLV}.tmp.vcf.gz" "${gavinOutputFinalMergedRLV}.gz.tmp"
mv -v "${gavinOutputFinalMergedRLV}.tmp.vcf.gz" "${gavinOutputFinalMergedRLV}.gz"
tabix -f -p vcf "${gavinOutputFinalMergedRLV}.gz"
rsync -av "${gavinOutputFinalMergedRLV}.gz" "${projectResultsDir}/variants/GAVIN/"

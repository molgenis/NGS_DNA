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

module load ${bcfToolsVersion}
module load ${htsLibVersion}


##new prefix will be externalSampleID + sampleProcessStepIDwith new sample identifier --> familyname+umcgnumber
newGVCFSampleIdentifier=$(echo "${externalSampleID}" | awk 'BEGIN {FS="_"}{print $1"_"$2}')
echo -e "${sampleProcessStepID} ${newGVCFSampleIdentifier}" > "${intermediateDir}/${externalSampleID}.newVCFHeader.txt"

bcftools reheader -s "${intermediateDir}/${externalSampleID}.newVCFHeader.txt" "${gavinOutputFinalMergedRLV}.gz" -o "${gavinOutputFinalMergedRLV}.gz.tmp"
mv "${gavinOutputFinalMergedRLV}.gz.tmp" "${gavinOutputFinalMergedRLV}.gz"
tabix -f -p vcf "${gavinOutputFinalMergedRLV}.gz"
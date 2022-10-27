#list externalSampleID
#string tmpName
#string gatkVersion
#string htsLibVersion
#string bcfToolsVersion
#string barcode
#string indexFile
#string logsDir 
#string groupname
#string projectVariantsSnpsOnlyFilteredVcf
#string projectVariantsIndelsOnlyFilteredVcf
#string projectFinalVcf
#string intermediateDir
#string indexFileDictionary
#string project

#Load GATK module
module purge
module load "${gatkVersion}"
module load "${htsLibVersion}"
module list

makeTmpDir "${projectFinalVcf}"
tmpProjectFinalVcf="${MC_tmpFile}"

gatk --java-options "-Xmx3g" MergeVcfs \
-I "${projectVariantsSnpsOnlyFilteredVcf}" \
-I "${projectVariantsIndelsOnlyFilteredVcf}" \
-D "${indexFileDictionary}" \
-O "${tmpProjectFinalVcf}"

echo "moving ${tmpProjectFinalVcf} to ${projectFinalVcf}"
mv "${tmpProjectFinalVcf}" "${projectFinalVcf}"

echo "compressing ${projectFinalVcf}"
bgzip -c "${projectFinalVcf}" > "${projectFinalVcf}.gz"
tabix -p vcf "${projectFinalVcf}.gz"


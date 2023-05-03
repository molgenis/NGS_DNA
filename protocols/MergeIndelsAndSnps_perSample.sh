set -o pipefail
#list externalSampleID
#string tmpName
#string gatkVersion
#string htsLibVersion
#string bcfToolsVersion
#string indexFile
#string barcode
#string logsDir 
#string groupname
#string intermediateDir
#string indexFileDictionary
#string project
#string sampleSnpsOnlyFilteredVcf
#string sampleIndelsOnlyFilteredVcf
#string sampleFinalVcf

#Load GATK module
module purge
module load "${gatkVersion}"
module load "${htsLibVersion}"
module load "${bcfToolsVersion}"
module list

makeTmpDir "${sampleFinalVcf}"
tmpSampleFinalVcf="${MC_tmpFile}"

gatk --java-options "-Xmx3g" MergeVcfs \
-I "${sampleSnpsOnlyFilteredVcf}" \
-I "${sampleIndelsOnlyFilteredVcf}" \
-D "${indexFileDictionary}" \
-O "${tmpSampleFinalVcf}"

echo "##FastQ_Barcode=${barcode}" > "${tmpSampleFinalVcf}.barcode.txt"

bcftools annotate -h "${tmpSampleFinalVcf}.barcode.txt" -O v -o "${tmpSampleFinalVcf}.tmp" "${tmpSampleFinalVcf}"

mv -v "${tmpSampleFinalVcf}.tmp" "${sampleFinalVcf}"

echo "compressing and indexing ${sampleFinalVcf} -> ${sampleFinalVcf}.gz"

bgzip -c "${sampleFinalVcf}" > "${sampleFinalVcf}.gz"
tabix -p vcf "${sampleFinalVcf}.gz"
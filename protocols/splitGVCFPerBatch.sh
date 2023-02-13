set -o pipefail
#string tmpName
#string gatkVersion
#string bcfToolsVersion
#string htsLibVersion
#string barcode
#string indexFile
#string logsDir 
#string groupname
#string externalSampleID
#string intermediateDir
#string project
#string indexFileDictionary

#Load GATK module
module load "${gatkVersion}"
module load "${bcfToolsVersion}"
module load "${htsLibVersion}"
module list

makeTmpDir "${sampleFinalVcf}"
tmpSampleFinalVcf="${MC_tmpFile}"

gatk --java-options "-Xmx3g" SelectVariants \
-R "${indexFile}" \
-V "${projectFinalVcf}" \
-sn "${externalSampleID}" \
-O "${tmpSampleFinalVcf}"

echo "##FastQ_Barcode=${barcode}" > "${tmpSampleFinalVcf}.barcode.txt"

bcftools annotate -h "${tmpSampleFinalVcf}.barcode.txt" -O v -o "${tmpSampleFinalVcf}.tmp" "${tmpSampleFinalVcf}"

mv -v "${tmpSampleFinalVcf}.tmp" "${sampleFinalVcf}"

echo "compressing ${sampleFinalVcf}"
bgzip -c "${sampleFinalVcf}" > "${sampleFinalVcf}.gz"
tabix -p vcf "${sampleFinalVcf}.gz"


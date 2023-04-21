set -o pipefail
#string tmpName
#string gatkVersion
#string bcfToolsVersion
#string htsLibVersion
#string indexFile
#string logsDir
#string barcode
#string groupname
#string projectFinalVcf
#string externalSampleID
#string sampleFinalVcf
#string intermediateDir
#string project
#string indexFileDictionary
#string sampleID

#Load GATK module
module purge
module load "${gatkVersion}"
module load "${bcfToolsVersion}"
module load "${htsLibVersion}"
module list

makeTmpDir "${sampleFinalVcf}"
tmpSampleFinalVcf="${MC_tmpFile}"

realSampleID="$(cat "${intermediateDir}/${sampleID}.txt")"
realSampleID=$(basename "${realSampleID}")

gatk --java-options "-Xmx3g" SelectVariants \
-R "${indexFile}" \
-V "${projectFinalVcf}" \
-sn "${realSampleID}" \
-O "${tmpSampleFinalVcf}"

echo "##FastQ_Barcode=${barcode}" > "${tmpSampleFinalVcf}.barcode.txt"

bcftools annotate -h "${tmpSampleFinalVcf}.barcode.txt" -O v -o "${tmpSampleFinalVcf}.tmp" "${tmpSampleFinalVcf}"

mv -v "${tmpSampleFinalVcf}.tmp" "${sampleFinalVcf}"

echo "compressing ${sampleFinalVcf}"
bgzip -c "${sampleFinalVcf}" > "${sampleFinalVcf}.gz"
tabix -p vcf "${sampleFinalVcf}.gz"


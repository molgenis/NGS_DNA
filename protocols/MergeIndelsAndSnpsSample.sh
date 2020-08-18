#list externalSampleID
#string tmpName
#string gatkVersion
#string gatkJar
#string bcfToolsVersion
#string barcode
#string indexFile
#string logsDir 
#string groupname
#string sampleVariantsMergedSnpsFilteredVcf
#string sampleVariantsMergedIndelsFilteredVcf
#string sampleFinalVcf
#string intermediateDir
#string" project

#Load GATK module
module load "${gatkVersion}"
module load "${bcfToolsVersion}"
module list

makeTmpDir "${sampleFinalVcf}"
tmpSampleFinalVcf="${MC_tmpFile}"

java -Xmx3g -jar "${EBROOTGATK}/${gatkJar}" \
-R "${indexFile}" \
-T CombineVariants \
--variant "${sampleVariantsMergedSnpsFilteredVcf}" \
--variant "${sampleVariantsMergedIndelsFilteredVcf}" \
--genotypemergeoption UNSORTED \
-o "${tmpSampleFinalVcf}"


echo "##FastQ_Barcode=${barcode}" > "${tmpSampleFinalVcf}.barcode.txt"

bcftools annotate -h "${tmpSampleFinalVcf}.barcode.txt" "${tmpSampleFinalVcf}" > "${tmpSampleFinalVcf}.tmp"

echo "moving ${tmpSampleFinalVcf}.tmp to ${sampleFinalVcf}"
mv "${tmpSampleFinalVcf}.tmp" "${sampleFinalVcf}"

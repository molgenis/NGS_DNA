#string tmpName
#string gatkVersion
#string gatkJar
#string bcfToolsVersion
#string barcode
#string indexFile
#string logsDir 
#string groupname

#string projectFinalVcf
#string externalSampleID
#string sampleFinalVcf

#string intermediateDir
#string	project
#string indexFileDictionary

#Load GATK module
module load "${gatkVersion}"
module load "${bcfToolsVersion}"
module list

makeTmpDir "${sampleFinalVcf}"
tmpSampleFinalVcf="${MC_tmpFile}"

gatk --java-options "-Xmx3g" SelectVariants \
-R "${indexFile}" \
-V "${projectFinalVcf}" \
-sn "${externalSampleID}" \
-O "${tmpSampleFinalVcf}"

echo "##FastQ_Barcode=${barcode}" > "${tmpSampleFinalVcf}.barcode.txt"

bcftools annotate -h "${tmpSampleFinalVcf}.barcode.txt" "${tmpSampleFinalVcf}" > "${tmpSampleFinalVcf}.tmp"

echo "moving ${tmpSampleFinalVcf}.tmp to ${sampleFinalVcf}"
mv "${tmpSampleFinalVcf}.tmp" "${sampleFinalVcf}"

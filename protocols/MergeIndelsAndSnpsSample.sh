#list externalSampleID
#string tmpName
#string gatkVersion
#string gatkJar
#string indexFile
#string logsDir 
#string groupname
#string sampleVariantsMergedSnpsFilteredVcf
#string sampleVariantsMergedIndelsFilteredVcf
#string sampleFinalVcf
#string intermediateDir
#string	project

#Load GATK module
module load "${gatkVersion}"
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


echo "moving ${tmpSampleFinalVcf} to ${sampleFinalVcf}"
mv "${tmpSampleFinalVcf}" "${sampleFinalVcf}"

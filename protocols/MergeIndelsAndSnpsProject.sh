#list externalSampleID
#string tmpName
#string gatkVersion
#string gatkJar
#string indexFile


#string projectPrefix
#string logsDir 
#string groupname
#string intermediateDir
#string	project
#string projectVariantsSnpsOnlyFilteredVcf
#string projectVariantsIndelsOnlyFilteredVcf
#string projectFinalVcf

#Load GATK module
module load "${gatkVersion}"
module list

gatk --java-options "-Xmx3g" MergeVcfs \
-I "${projectVariantsSnpsOnlyFilteredVcf}" \
-I "${projectVariantsIndelsOnlyFilteredVcf}" \
-D "${indexFileDictionary}" \
-O "${projectFinalVcf}.tmp"

echo "moving ${projectFinalVcf}.tmp to ${projectFinalVcf}"
mv "${projectFinalVcf}.tmp" "${projectFinalVcf}"

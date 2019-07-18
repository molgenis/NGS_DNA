#string groupname
#string tmpName
#string projectPrefix
#string logsDir 
#string intermediateDir

#string gatkVersion
#string gatkJar

#string	project
#string indexFile
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

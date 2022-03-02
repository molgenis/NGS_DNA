#string groupname
#string tmpName
#string projectPrefix
#string logsDir 
#string intermediateDir

#string gatkVersion

#string project
#string indexFileDictionary
#string projectVariantsSnpsOnlyFilteredVcf
#string projectVariantsIndelsOnlyFilteredVcf
#string projectFinalVcf

#Load GATK module
module load "${gatkVersion}"
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


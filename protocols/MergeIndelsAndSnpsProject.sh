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

#Load GATK module
module load "${gatkVersion}"
module list

gatk --java-options "-Xmx3g" MergeVcfs \
-I "${projectVariantsSnpsOnlyFilteredVcf}" \
-I "${projectVariantsIndelsOnlyFilteredVcf}" \
-D "${indexFileDictionary}" \
-O "${projectPrefix}.final.vcf.tmp"

echo "moving ${projectPrefix}.final.vcf.tmp to ${projectPrefix}.final.vcf"
mv "${projectPrefix}.final.vcf.tmp" "${projectPrefix}.final.vcf"

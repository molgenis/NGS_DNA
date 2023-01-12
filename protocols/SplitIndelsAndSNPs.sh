set -o pipefail
#Parameter mapping
#string tmpName
#string intermediateDir
#string project
#string logsDir
#string groupname
#string gatkVersion
#string indexFile
#string capturedIntervals
#string projectVariantsMergedSortedGz
#string projectVariantsSnpsOnlyVcf
#string projectVariantsIndelsOnlyVcf

module purge
module load "${gatkVersion}"

makeTmpDir "${projectVariantsSnpsOnlyVcf}"
tmpProjectVariantsSnpsOnlyVcf="${MC_tmpFile}"

makeTmpDir "${projectVariantsIndelsOnlyVcf}"
tmpProjectVariantsIndelsOnlyVcf="${MC_tmpFile}"

#select only Indels
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpProjectVariantsIndelsOnlyVcf}" \
--select-type-to-include INDEL

mv -v "${tmpProjectVariantsIndelsOnlyVcf}" "${projectVariantsIndelsOnlyVcf}"

#Select SNPs and MNPs
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpProjectVariantsSnpsOnlyVcf}" \
--select-type-to-exclude INDEL 

mv -v "${tmpProjectVariantsSnpsOnlyVcf}" "${projectVariantsSnpsOnlyVcf}"

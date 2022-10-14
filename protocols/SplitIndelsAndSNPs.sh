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
#string sampleVariantsMergedSnpsVcf
#string sampleVariantsMergedIndelsVcf
#string sampleID

module load "${gatkVersion}"

makeTmpDir "${sampleVariantsMergedIndelsVcf}"
tmpSampleVariantsMergedIndelsVcf="${MC_tmpFile}"

makeTmpDir "${sampleVariantsMergedSnpsVcf}"
tmpSampleVariantsMergedSnpsVcf="${MC_tmpFile}"
 
realSampleID="$(cat "${intermediateDir}/${sampleID}.txt")"
realSampleID=$(basename "${realSampleID}")

#select only Indels
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpProjectVariantsIndelsOnlyVcf}" \
--select-type-to-include INDEL \
-sn "${realSampleID}"

mv -v "${tmpSampleVariantsMergedIndelsVcf}" "${sampleVariantsMergedIndelsVcf}"

#Select SNPs and MNPs
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpProjectVariantsSnpsOnlyVcf}" \
--select-type-to-exclude INDEL \
-sn "${realSampleID}"

mv -v "${tmpSampleVariantsMergedSnpsVcf}" "${sampleVariantsMergedSnpsVcf}"

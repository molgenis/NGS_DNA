#Parameter mapping
#string tmpName


#string intermediateDir
#string project
#string logsDir
#string groupname
#string gatkVersion
#string gatkJar
#string indexFile
#string capturedIntervals
#string projectVariantsMergedSortedGz
#string sampleVariantsMergedSnpsVcf
#string sampleVariantsMergedIndelsVcf
#string externalSampleID


module load "${gatkVersion}"

makeTmpDir "${sampleVariantsMergedIndelsVcf}"
tmpSampleVariantsMergedIndelsVcf="${MC_tmpFile}"

makeTmpDir "${sampleVariantsMergedSnpsVcf}"
tmpSampleVariantsMergedSnpsVcf="${MC_tmpFile}"

# Select indels only.
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpSampleVariantsMergedIndelsVcf}" \
-sn "${externalSampleID}" \
--select-type-to-include INDEL

mv "${tmpSampleVariantsMergedIndelsVcf}" "${sampleVariantsMergedIndelsVcf}"
echo "moved ${tmpSampleVariantsMergedIndelsVcf} to ${sampleVariantsMergedIndelsVcf}"

# Select non-indels only.
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpSampleVariantsMergedSnpsVcf}" \
-sn "${externalSampleID}" \
--select-type-to-exclude INDEL

mv "${tmpSampleVariantsMergedSnpsVcf}" "${sampleVariantsMergedSnpsVcf}"
echo "moved ${tmpSampleVariantsMergedSnpsVcf} to ${sampleVariantsMergedSnpsVcf}"

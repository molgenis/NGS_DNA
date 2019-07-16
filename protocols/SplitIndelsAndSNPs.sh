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
#string externalSampleID
#string projectVariantsSnpsOnlyVcf
#string projectVariantsIndelsOnlyVcf

module load "${gatkVersion}"

makeTmpDir "${projectVariantsIndelsOnlyVcf}"
tmpProjectVariantsIndelsOnlyVcf="${MC_tmpFile}"

# Select indels only.
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpProjectVariantsIndelsOnlyVcf}" \
--select-type-to-include INDEL

mv "${tmpProjectVariantsIndelsOnlyVcf}" "${projectVariantsIndelsOnlyVcf}"
echo "moved ${tmpProjectVariantsIndelsOnlyVcf} to ${projectVariantsIndelsOnlyVcf}"



makeTmpDir "${projectVariantsSnpsOnlyVcf}"
tmpProjectVariantsSnpsOnlyVcf="${MC_tmpFile}"

# Select non-indels only.
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${projectVariantsMergedSortedGz}" \
-O "${tmpProjectVariantsSnpsOnlyVcf}" \
--select-type-to-exclude INDEL

mv "${tmpProjectVariantsSnpsOnlyVcf}" "${projectVariantsSnpsOnlyVcf}"
echo "moved ${tmpProjectVariantsSnpsOnlyVcf} to ${projectVariantsSnpsOnlyVcf}"

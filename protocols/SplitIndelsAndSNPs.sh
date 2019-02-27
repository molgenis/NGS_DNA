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
#string projectVariantsMergedSnpsVcf
#string projectVariantsMergedIndelsVcf
#string externalSampleID


module load "${gatkVersion}"

makeTmpDir "${projectVariantsMergedIndelsVcf}"
tmpProjectVariantsMergedIndelsVcf="${MC_tmpFile}"

makeTmpDir "${projectVariantsMergedSnpsVcf}"
tmpProjectVariantsMergedSnpsVcf="${MC_tmpFile}"

#select only Indels
java -XX:ParallelGCThreads=1 -Xmx5g -jar "${EBROOTGATK}/${gatkJar}" \
-R "${indexFile}" \
-T SelectVariants \
--variant "${projectVariantsMergedSortedGz}" \
-o "${tmpProjectVariantsMergedIndelsVcf}" \
--selectTypeToInclude INDEL \
-sn "${externalSampleID}"

mv "${tmpProjectVariantsMergedIndelsVcf}" "${projectVariantsMergedIndelsVcf}"
echo "moved ${tmpProjectVariantsMergedIndelsVcf} to ${projectVariantsMergedIndelsVcf}"

#Select SNPs and MNPs
java -XX:ParallelGCThreads=1 -Xmx5g -jar "${EBROOTGATK}/${gatkJar}" \
-R "${indexFile}" \
-T SelectVariants \
--variant "${projectVariantsMergedSortedGz}" \
-o "${tmpProjectVariantsMergedSnpsVcf}" \
--selectTypeToExclude INDEL \
-sn "${externalSampleID}"

mv "${tmpProjectVariantsMergedSnpsVcf}" "${projectVariantsMergedSnpsVcf}"
echo "moved ${tmpProjectVariantsMergedSnpsVcf} to ${projectVariantsMergedSnpsVcf}"

#MOLGENIS walltime=05:59:00 mem=6gb ppn=2

#Parameter mapping
#string tmpName
#string stage
#string checkStage
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


${stage} "${gatkVersion}"

makeTmpDir "${projectVariantsMergedIndelsVcf}"
tmpProjectVariantsMergedIndelsVcf="${MC_tmpFile}"

makeTmpDir "${projectVariantsMergedSnpsVcf}"
tmpProjectVariantsMergedSnpsVcf="${MC_tmpFile}"

#select only Indels
java -XX:ParallelGCThreads=2 -Xmx4g -jar "${EBROOTGATK}/${gatkJar}" \
-R "${indexFile}" \
-T SelectVariants \
--variant "${projectVariantsMergedSortedGz}" \
-o "${tmpProjectVariantsMergedIndelsVcf}" \
--selectTypeToInclude INDEL \
-sn "${externalSampleID}"

mv "${tmpProjectVariantsMergedIndelsVcf}" "${projectVariantsMergedIndelsVcf}"
echo "moved ${tmpProjectVariantsMergedIndelsVcf} to ${projectVariantsMergedIndelsVcf}"

#Select SNPs and MNPs
java -XX:ParallelGCThreads=2 -Xmx4g -jar "${EBROOTGATK}/${gatkJar}" \
-R "${indexFile}" \
-T SelectVariants \
--variant "${projectVariantsMergedSortedGz}" \
-o "${tmpProjectVariantsMergedSnpsVcf}" \
--selectTypeToExclude INDEL \
-sn "${externalSampleID}"

mv "${tmpProjectVariantsMergedSnpsVcf}" "${projectVariantsMergedSnpsVcf}"
echo "moved ${tmpProjectVariantsMergedSnpsVcf} to ${projectVariantsMergedSnpsVcf}"

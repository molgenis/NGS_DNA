#Parameter mapping
#string tmpName


#string gcBiasMetricsJar
#string dedupBam
#string dedupBamIdx
#string indexFile
#string collectBamMetricsPrefix
#string tempDir
#string rVersion
#string ngsUtilsVersion
#string capturingKit
#string seqType
#string insertSizeMetrics
#string gcBiasMetrics
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string gatkVersion

#Load GATK module.
module load "${gatkVersion}"
module load "${ngsUtilsVersion}"
module load "${rVersion}"
module list

makeTmpDir "${gcBiasMetrics}" "${intermediateDir}"
tmpGcBiasMetrics="${MC_tmpFile}"

#Run GcBiasMetrics
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx3g" CollectGcBiasMetrics \
--REFERENCE_SEQUENCE "${indexFile}" \
-I "${dedupBam}" \
-O "${tmpGcBiasMetrics}" \
-S "${tmpGcBiasMetrics}.summary_metrics.txt" \
-CHART "${tmpGcBiasMetrics}.pdf" \
--VALIDATION_STRINGENCY STRICT \
--TMP_DIR "${tempDir}"

echo -e "\nGcBiasMetrics finished succesfull. Moving temp files to final.\n\n"
mv "${tmpGcBiasMetrics}" "${gcBiasMetrics}"
mv "${tmpGcBiasMetrics}.pdf" "${gcBiasMetrics}.pdf"

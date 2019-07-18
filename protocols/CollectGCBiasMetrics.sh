#Parameter mapping
#string tmpName


#string picardVersion
#string gcBiasMetricsJar
#string dedupBam
#string dedupBamIdx
#string indexFile
#string collectBamMetricsPrefix
#string tempDir
#string recreateInsertSizePdfR
#string rVersion
#string ngsUtilsVersion
#string capturingKit
#string seqType
#string picardJar
#string insertSizeMetrics
#string gcBiasMetrics
#string	project
#string logsDir 
#string groupname
#string intermediateDir
#string gatkVersion

#Load Picard module
module load "${gatkVersion}"
module load "${rVersion}"
module load "${ngsUtilsVersion}"
module list

makeTmpDir "${gcBiasMetrics}" "${intermediateDir}"
tmpGcBiasMetrics="${MC_tmpFile}"

#Run Picard GcBiasMetrics
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx3g" CollectGcBiasMetrics \
-R "${indexFile}" \
-I "${dedupBam}" \
-O "${tmpGcBiasMetrics}" \
-S "${tmpGcBiasMetrics}.summary_metrics.txt" \
-CHART "${tmpGcBiasMetrics}.pdf" \
--VALIDATION_STRINGENCY STRICT \
--TMP_DIR "${tempDir}"

echo -e "\nGcBiasMetrics finished succesfull. Moving temp files to final.\n\n"
mv "${tmpGcBiasMetrics}" "${gcBiasMetrics}"
mv "${tmpGcBiasMetrics}.pdf" "${gcBiasMetrics}.pdf"

"${recreateInsertSizePdfR}" \
--insertSizeMetrics "${insertSizeMetrics}" \
--pdf "${insertSizeMetrics}.pdf"

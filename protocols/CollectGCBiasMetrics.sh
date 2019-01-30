#Parameter mapping
#string tmpName
#string stage
#string checkStage
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

#Load Picard module
${stage} "${picardVersion}"
${stage} "${rVersion}"
${stage} "${ngsUtilsVersion}"
${checkStage}

makeTmpDir "${gcBiasMetrics}" "${intermediateDir}"
tmpGcBiasMetrics="${MC_tmpFile}"

#Run Picard GcBiasMetrics
java -XX:ParallelGCThreads=1 -jar -Xmx3g "${EBROOTPICARD}/${picardJar}" "${gcBiasMetricsJar}" \
R="${indexFile}" \
I="${dedupBam}" \
O="${tmpGcBiasMetrics}" \
S="${tmpGcBiasMetrics}.summary_metrics.txt" \
CHART="${tmpGcBiasMetrics}.pdf" \
VALIDATION_STRINGENCY=STRICT \
TMP_DIR="${tempDir}"

echo -e "\nGcBiasMetrics finished succesfull. Moving temp files to final.\n\n"
mv "${tmpGcBiasMetrics}" "${gcBiasMetrics}"
mv "${tmpGcBiasMetrics}.pdf" "${gcBiasMetrics}.pdf"

"${recreateInsertSizePdfR}" \
--insertSizeMetrics "${insertSizeMetrics}" \
--pdf "${insertSizeMetrics}.pdf"

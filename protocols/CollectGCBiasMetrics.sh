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
#string insertSizeMetrics
#string gcBiasMetrics
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load Picard module
module load "${picardVersion}"
module load "${rVersion}"
module load "${ngsUtilsVersion}"
module list

makeTmpDir "${gcBiasMetrics}" "${intermediateDir}"
tmpGcBiasMetrics="${MC_tmpFile}"

#Run Picard GcBiasMetrics
java -XX:ParallelGCThreads=1 -jar -Xmx3g "${EBROOTPICARD}/picard.jar" "${gcBiasMetricsJar}" \
R="${indexFile}" \
I="${dedupBam}" \
O="${tmpGcBiasMetrics}" \
S="${tmpGcBiasMetrics}.summary_metrics.txt" \
CHART="${tmpGcBiasMetrics}.pdf" \
VALIDATION_STRINGENCY=STRICT \
TMP_DIR="${tempDir}"

echo -e "\nGcBiasMetrics finished succesfull. Moving temp files to final.\n\n"
mv -v "${tmpGcBiasMetrics}" "${gcBiasMetrics}"
mv -v "${tmpGcBiasMetrics}.pdf" "${gcBiasMetrics}.pdf"


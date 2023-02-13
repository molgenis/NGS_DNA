set -o pipefail
#Parameter mapping
#string tmpName
#string gatkVersion
#string rVersion
#string indexFile
#string tempDir
#string gcBiasMetrics
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string dedupBam

#Load gatk module
module load "${gatkVersion}"
module load "${rVersion}"
module list

makeTmpDir "${gcBiasMetrics}" "${intermediateDir}"
tmpGcBiasMetrics="${MC_tmpFile}"

gatk --java-options "-XX:ParallelGCThreads=1 -Xmx3g" CollectGcBiasMetrics \
--REFERENCE_SEQUENCE "${indexFile}" \
-I "${dedupBam}" \
-O "${tmpGcBiasMetrics}" \
-S "${tmpGcBiasMetrics}.summary_metrics.txt" \
-CHART "${tmpGcBiasMetrics}.pdf" \
--VALIDATION_STRINGENCY STRICT \
--TMP_DIR "${tempDir}"

echo -e "\nGcBiasMetrics finished succesfull. Moving temp files to final.\n\n"
mv -v "${tmpGcBiasMetrics}" "${gcBiasMetrics}"
mv -v "${tmpGcBiasMetrics}.pdf" "${gcBiasMetrics}.pdf"


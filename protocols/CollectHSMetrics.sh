#Parameter mapping
#string tmpName
#string picardVersion
#string hsMetricsJar
#string hsMetrics
#string dedupBam
#string dedupBamIdx
#string tempDir
#string recreateInsertSizePdfR
#string capturedIntervals
#string capturedExomeIntervals
#string capturingKit
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load Picard module

module load "${picardVersion}"

makeTmpDir "${hsMetrics}" "${intermediateDir}"
tmpHsMetrics="${MC_tmpFile}"

#Run Picard HsMetrics if capturingKit was used
if [ "${capturingKit}" == "UMCG/wgs" ] || [ "${capturingKit}" == "None" ]
then
	java -jar -Xmx3g -XX:ParallelGCThreads=1 "${EBROOTPICARD}/picard.jar" "${hsMetricsJar}" \
	INPUT="${dedupBam}" \
	OUTPUT="${tmpHsMetrics}" \
	BAIT_INTERVALS="${capturedExomeIntervals}" \
	TARGET_INTERVALS="${capturedExomeIntervals}" \
	VALIDATION_STRINGENCY=LENIENT \
	TMP_DIR="${tempDir}"
else
	java -jar -Xmx3g -XX:ParallelGCThreads=1 "${EBROOTPICARD}/picard.jar" "${hsMetricsJar}" \
	INPUT="${dedupBam}" \
	OUTPUT="${tmpHsMetrics}" \
	BAIT_INTERVALS="${capturedIntervals}" \
	TARGET_INTERVALS="${capturedIntervals}" \
	VALIDATION_STRINGENCY=LENIENT \
	TMP_DIR="${tempDir}"
fi

mv -v "${tmpHsMetrics}" "${hsMetrics}"


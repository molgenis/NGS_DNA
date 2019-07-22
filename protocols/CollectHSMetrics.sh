#Parameter mapping
#string tmpName

#string hsMetrics
#string dedupBam
#string dedupBamIdx
#string tempDir
#string recreateInsertSizePdfR
#string capturedIntervals
#string capturedExomeIntervals
#string capturingKit
#string	project
#string logsDir 
#string groupname
#string intermediateDir
#string gatkVersion

#Load GATK module
module load "${gatkVersion}"

makeTmpDir "${hsMetrics}" "${intermediateDir}"
tmpHsMetrics="${MC_tmpFile}"

#Run Picard HsMetrics if capturingKit was used
if [ "${capturingKit}" == "UMCG/wgs" ] || [ "${capturingKit}" == "None" ]
then
	gatk --java-options="-Xmx3g -XX:ParallelGCThreads=1" CollectHsMetrics \
	--INPUT="${dedupBam}" \
	--OUTPUT="${tmpHsMetrics}" \
	--BAIT_INTERVALS="${capturedExomeIntervals}" \
	--TARGET_INTERVALS="${capturedExomeIntervals}" \
	--VALIDATION_STRINGENCY=LENIENT \
	--CLIP_OVERLAPPING_READS=false \
	--MINIMUM_MAPPING_QUALITY=1 \
	--MINIMUM_BASE_QUALITY=0 \
	--TMP_DIR="${tempDir}"
else
	gatk --java-options="-Xmx3g -XX:ParallelGCThreads=1" CollectHsMetrics \
	--INPUT="${dedupBam}" \
	--OUTPUT="${tmpHsMetrics}" \
	--BAIT_INTERVALS="${capturedIntervals}" \
	--TARGET_INTERVALS="${capturedIntervals}" \
	--VALIDATION_STRINGENCY=LENIENT \
	--CLIP_OVERLAPPING_READS=false \
	--MINIMUM_MAPPING_QUALITY=1 \
	--MINIMUM_BASE_QUALITY=0 \
	--TMP_DIR="${tempDir}"
fi

mv "${tmpHsMetrics}" "${hsMetrics}"
echo "moved ${tmpHsMetrics} to ${hsMetrics}"


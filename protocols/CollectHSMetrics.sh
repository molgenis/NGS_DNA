set -o pipefail
#Parameter mapping
#string tmpName
#string gatkVersion
#string hsMetrics
#string dedupBam
#string tempDir
#string capturedIntervals
#string capturedExomeIntervals
#string capturingKit
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load gatk module
module load "${gatkVersion}"
module list

makeTmpDir "${hsMetrics}" "${intermediateDir}"
tmpHsMetrics="${MC_tmpFile}"

#Run gatk HsMetrics if capturingKit was used
if [ "${capturingKit}" == "UMCG/wgs" ] || [ "${capturingKit}" == "None" ]
then
	gatk --java-options "-Xmx3g -XX:ParallelGCThreads=1" CollectHsMetrics \
	-I "${dedupBam}" \
	-O "${tmpHsMetrics}" \
	-BI "${capturedExomeIntervals}" \
	-TI "${capturedExomeIntervals}" \
	--VALIDATION_STRINGENCY LENIENT \
	--CLIP_OVERLAPPING_READS false \
	--MINIMUM_MAPPING_QUALITY 1 \
	--MINIMUM_BASE_QUALITY 0 \
	--TMP_DIR "${tempDir}"
else
	gatk --java-options "-Xmx3g -XX:ParallelGCThreads=1" CollectHsMetrics \
	-I "${dedupBam}" \
	-O "${tmpHsMetrics}" \
	-BI "${capturedIntervals}" \
	-TI "${capturedIntervals}" \
	--VALIDATION_STRINGENCY LENIENT \
	--CLIP_OVERLAPPING_READS false \
	--MINIMUM_MAPPING_QUALITY 1 \
	--MINIMUM_BASE_QUALITY 0 \
	--TMP_DIR "${tempDir}"
fi

mv -v "${tmpHsMetrics}" "${hsMetrics}"


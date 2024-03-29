set -o pipefail
#string gatkVersion
#string tmpName
#string dedupBam
#string capturedIntervals
#string capturedIntervals_nonAutoChrX
#string indexFileDictionary
#string intermediateDir
#string whichSex
#string tempDir
#string checkSexMeanCoverage
#string dedupBamMetrics
#string hsMetricsNonAutosomalRegionChrX
#string project
#string logsDir 
#string groupname

module load "${gatkVersion}"

if [[ "${capturedIntervals}" == *"ONCO_v"* || "${capturedIntervals}" == *"wgs"* || "${capturedIntervals}" == *"Targeted_v"* ]]
then
	touch "${dedupBamMetrics}.noChrX"
else

	makeTmpDir "${hsMetricsNonAutosomalRegionChrX}"
	tmpHsMetricsNonAutosomalRegionChrX="${MC_tmpFile}"

	cat "${indexFileDictionary}" > "${capturedIntervals_nonAutoChrX}"
	lengthCap1=$(wc -l "${capturedIntervals_nonAutoChrX}" | awk '{print $1}')
	awk '{if ($0 ~ /^X/){print $0}}' "${capturedIntervals}" >> "${capturedIntervals_nonAutoChrX}"
	lengthCap2=$(wc -l "${capturedIntervals_nonAutoChrX}" | awk '{print $1}')

	if [[ "${lengthCap1}" -ne "${lengthCap2}" ]]
	then
		#Calculate coverage chromosome X
		gatk --java-options "-XX:ParallelGCThreads=2 -Xmx2g" CollectHsMetrics \
		INPUT="${dedupBam}" \
		TARGET_INTERVALS="${capturedIntervals_nonAutoChrX}" \
		BAIT_INTERVALS="${capturedIntervals_nonAutoChrX}" \
		TMP_DIR="${tempDir}" \
		OUTPUT="${tmpHsMetricsNonAutosomalRegionChrX}"

		mv -v "${tmpHsMetricsNonAutosomalRegionChrX}" "${hsMetricsNonAutosomalRegionChrX}"
	else
		touch "${dedupBamMetrics}.noChrX"
	fi
fi

#string tmpName
#string dedupBam
#string capturedIntervals
#string capturedIntervals_nonAutoChrX
#string indexFileDictionary
#string sampleNameID
#string intermediateDir
#string whichSex
#string tempDir
#string checkSexMeanCoverage
#string picardJar
#string picardVersion
#string dedupBamMetrics
#string hsMetricsNonAutosomalRegionChrX
#string project
#string logsDir 
#string groupname

module load "${picardVersion}"

if [[ "${capturedIntervals}" == *"ONCO_v"* || "${capturedIntervals}" == *"wgs"*  || "${capturedIntervals}" == *"Targeted_v"* ]]
then
	touch "${dedupBamMetrics}.noChrX"
else

	makeTmpDir "${hsMetricsNonAutosomalRegionChrX}"
	tmpHsMetricsNonAutosomalRegionChrX="${MC_tmpFile}"

	cat "${indexFileDictionary}" > "${capturedIntervals_nonAutoChrX}"
	lengthCap1=$(cat "${capturedIntervals_nonAutoChrX}" | wc -l)
	awk '{if ($0 ~ /^X/){print $0}}' "${capturedIntervals}" >> "${capturedIntervals_nonAutoChrX}"
	lengthCap2=$(cat "${capturedIntervals_nonAutoChrX}" | wc -l)

	if [ "${lengthCap1}" -ne "${lengthCap2}" ]
	then
		#Calculate coverage chromosome X
		java -jar -XX:ParallelGCThreads=2 -Xmx2g "${EBROOTPICARD}/${picardJar}" CalculateHsMetrics \
		INPUT="${dedupBam}" \
		TARGET_INTERVALS="${capturedIntervals_nonAutoChrX}" \
		BAIT_INTERVALS="${capturedIntervals_nonAutoChrX}" \
		TMP_DIR="${tempDir}" \
		OUTPUT="${tmpHsMetricsNonAutosomalRegionChrX}"

		mv "${tmpHsMetricsNonAutosomalRegionChrX}" "${hsMetricsNonAutosomalRegionChrX}"
		echo "mv ${tmpHsMetricsNonAutosomalRegionChrX} ${hsMetricsNonAutosomalRegionChrX}"
	else
		touch "${dedupBamMetrics}.noChrX"
	fi
fi

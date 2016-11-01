#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string gatkVersion
#string indexFile
#string capturedBed
#string capturingKit
#string dedupBam
#string intermediateDir
#string DepthOfCoveragePerSample
#string gatkVersion
#string xhmmMergedSample
#string xhmmDataDir
#string xhmmDir
#string xhmmDepthOfCoverage
#string xhmmVersion
#string xhmmFilterSample
#string xhmmPCAfile
#string xhmmPCANormalizedfile
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmSameFiltered
#string xhmmXcnv
#string xhmmAUXcnv
#string xhmmPosterior
#string xhmmHighSenseParams

.  ./Controls.env

module load ${gatkVersion}

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}


if [ ! -f XHMM_combined.s1.finished ]
then
	#
	## Step1
        #
	makeTmpDir ${xhmmDir}
	tmpXhmmDir=${MC_tmpFile}

	for bamFile in "${dedupBam[@]}"
	do
	        array_contains INPUTS "$bamFile" || INPUTS+=("$bamFile")    # If bamFile does not exist in array add it
	        array_contains INPUTBAMS "$bamFile" || INPUTBAMS+=("$bamFile")    # If bamFile does not exist in array add it
	done

	## Creating bams directory
	mkdir -p ${xhmmDepthOfCoverage}

	rm -f ${xhmmDir}/${CAPT}.READS.bam.list

	for i in ${INPUTS[@]}
	do
	        echo "$i" >> ${xhmmDir}/${CAPT}.READS.bam.list
	done

	sID=$(basename $dedupBam)
	sampleID=${sID%%.*}

	java -Xmx3072m -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
	-T DepthOfCoverage \
	-I ${xhmmDir}/${CAPT}.READS.bam.list \
	-L ${capturedBed} \
	-R ${indexFile} \
	-dt BY_SAMPLE -dcov 5000 -l INFO --omitDepthOutputAtEachBase --omitLocusTable \
	--minBaseQuality 0 --minMappingQuality 20 --start 1 --stop 5000 --nBins 200 \
	--includeRefNSites \
	--countType COUNT_FRAGMENTS \
	-o ${DepthOfCoveragePerSample}.${CAPT}

	echo "s1 finished"
	touch XHMM_combined.s1.finished
fi
if [ ! -f XHMM_combined.s2.finished ]
then
	#
	## Step2
	#
	module load ${xhmmVersion}

	makeTmpDir ${xhmmMergedSample}
	tmpXhmmMergedSample=${MC_tmpFile}

	$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
	-o ${tmpXhmmMergedSample} \
	--GATKdepths ${DepthOfCoveragePerSample}.${CAPT}.sample_interval_summary \
	--GATKdepthsList ${xhmmControlsDir}/Controls.sample_interval_summary

	printf "moving ${tmpXhmmMergedSample} to ${xhmmMergedSample} .. "
	mv ${tmpXhmmMergedSample} ${xhmmMergedSample}
	printf " .. done!"

	touch XHMM_combined.s2.finished
	echo "s2 finished"

fi

if [ ! -f XHMM_combined.s5.finished ]
then
	#
	## Step 5
	#
	xhmmExtremeGcContent=${xhmmDataDir}/step3.extreme_gc_targets.txt

	$EBROOTXHMM/bin/xhmm --matrix \
	-r ${xhmmMergedSample} \
	--centerData \
	--centerType target \
	-o ${xhmmFilterSample} \
	--outputExcludedTargets ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_targets.txt \
	--outputExcludedSamples ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_samples.txt \
	--excludeTargets ${xhmmExtremeGcContent} \
	--minTargetSize 10 \
	--maxTargetSize 10000 \
	--minMeanTargetRD 10 \
	--maxMeanTargetRD 1500 \
	--minMeanSampleRD 25 \
	--maxMeanSampleRD 1000 \
	--maxSdSampleRD 150

	echo "s5 finished"
	touch XHMM_combined.s5.finished
fi

#--excludeTargets ${xhmmDir}/${CAPT}.step4.low_complexity_targets.txt \
#maxMeanTarget changed from 500 (as in tutorial) to 1500 to keep al targets in the calculation
#maxMeanSampleRD changed from 200 (as in tutorial) to 1000 to keep al targets in the calculation

if [ ! -f XHMM_combined.s6.finished ]
then
	#
	## Step 6
	#
	$EBROOTXHMM/bin/xhmm --PCA \
	-r ${xhmmFilterSample} \
	--PCAfiles ${xhmmPCAfile}

	touch XHMM_combined.s6.finished
	echo "s6 finished"
fi

if [ ! -f XHMM_combined.s7.finished ]
then
	#
	## Step 7
	#
	$EBROOTXHMM/bin/xhmm --normalize \
	-r ${xhmmFilterSample} \
	--PCAfiles ${xhmmPCAfile} \
	--normalizeOutput ${xhmmPCANormalizedfile} \
	--PCnormalizeMethod PVE_mean \
	--PVE_mean_factor 0.7

	echo "s7 finished"
	touch XHMM_combined.s7.finished
fi

if [ ! -f XHMM_combined.s8.finished ]
then
	#
	## Step 8
	#
	$EBROOTXHMM/bin/xhmm --matrix \
	-r ${xhmmPCANormalizedfile} \
	--centerData \
	--centerType sample \
	--zScoreData \
	-o ${xhmmPCANormalizedfileFilteredZscores} \
	--outputExcludedTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
	--outputExcludedSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
	--maxSdTargetRD 30

	echo "s8 finished"
	touch XHMM_combined.s8.finished
fi

if [ ! -f XHMM_combined.s9.finished ]
then
	#
	## Step 9
	#
	$EBROOTXHMM/bin/xhmm --matrix \
	-r ${xhmmMergedSample} \
	--excludeTargets ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_targets.txt \
	--excludeTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
	--excludeSamples ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_samples.txt \
	--excludeSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
	-o ${xhmmSameFiltered}

	echo "s9 finished"
	touch XHMM_combined.s9.finished
fi

if [ ! -f XHMM_combined.s10.finished ]
then
	#
	## Step 10
	#
	$EBROOTXHMM/bin/xhmm --discover \
	--discoverSomeQualThresh 0 \
	-p ${xhmmHighSenseParams} \
	-r ${xhmmPCANormalizedfileFilteredZscores} \
	-R ${xhmmSameFiltered} \
	-c ${xhmmXcnv} \
	-a ${xhmmAUXcnv} \
	-s ${xhmmPosterior}
	touch XHMM_combined.s10.finished
	echo "s10 finished"
fi

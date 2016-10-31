#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmVersion
#string xhmmDir
#string xhmmMergedSample
#string xhmmFilterSample
#string intermediateDir
#string	capturingKit

.  ./Controls.env

module load ${xhmmVersion}

xhmmExtremeGcContent=${xhmmDir}/${CAPT}_step3.extreme_gc_targets.txt

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

#--excludeTargets ${xhmmDir}/${CAPT}.step4.low_complexity_targets.txt \
#maxMeanTarget changed from 500 (as in tutorial) to 1500 to keep al targets in the calculation
#maxMeanSampleRD changed from 200 (as in tutorial) to 1000 to keep al targets in the calculation

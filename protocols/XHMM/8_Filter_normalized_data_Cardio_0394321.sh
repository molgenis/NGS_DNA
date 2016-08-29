#string xhmmVersion
#string xhmmPCANormalizedfile
#string xhmmFilterSample
#string xhmmPCANormalizedfileFilteredZscores

module load ${xhmmVersion}

$EBROOTXHMM/bin/xhmm --matrix \
-r ${xhmmPCANormalizedfile} \
--centerData \
--centerType sample \
--zScoreData \
-o ${xhmmPCANormalizedfileFilteredZscores} \
--outputExcludedTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
--outputExcludedSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
--maxSdTargetRD 30

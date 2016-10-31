#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmVersion
#string xhmmPCANormalizedfile
#string xhmmFilterSample
#string xhmmPCANormalizedfileFilteredZscores

.  ./Controls.env

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

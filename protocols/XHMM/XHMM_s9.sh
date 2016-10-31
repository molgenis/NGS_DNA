#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmVersion
#string xhmmPCANormalizedfile
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmMergedSample
#string xhmmSameFiltered

.  ./Controls.env

module load ${xhmmVersion}

$EBROOTXHMM/bin/xhmm --matrix \
-r ${xhmmMergedSample} \
--excludeTargets ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_targets.txt \
--excludeTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
--excludeSamples ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_samples.txt \
--excludeSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
-o ${xhmmSameFiltered}

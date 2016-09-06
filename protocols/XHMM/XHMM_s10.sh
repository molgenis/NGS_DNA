#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmVersion
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmSameFiltered
#string xhmmXcnv
#string xhmmAUXcnv
#string xhmmPosterior
#string xhmmHighSenseParams

module load ${xhmmVersion}

$EBROOTXHMM/bin/xhmm --discover \
--discoverSomeQualThresh 0 \
-p ${xhmmHighSenseParams} \
-r ${xhmmPCANormalizedfileFilteredZscores} \
-R ${xhmmSameFiltered} \
-c ${xhmmXcnv} \
-a ${xhmmAUXcnv} \
-s ${xhmmPosterior}

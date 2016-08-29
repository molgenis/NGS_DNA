
#string xhmmVersion
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmSameFiltered
#string xhmmXcnv
#string xhmmAUXcnv
#string xhmmPosterior
#string highSenseParams

module load ${xhmmVersion}

$EBROOTXHMM/bin/xhmm --discover \
--discoverSomeQualThresh 0 \
-p ${highSenseParams} \
-r ${xhmmPCANormalizedfileFilteredZscores} \
-R ${xhmmSameFiltered} \
-c ${xhmmXcnv} \
-a ${xhmmAUXcnv} \
-s ${xhmmPosterior}

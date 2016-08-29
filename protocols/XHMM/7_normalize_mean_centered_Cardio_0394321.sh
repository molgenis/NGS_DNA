#string xhmmVersion
#string xhmmPCAfile
#string xhmmPCANormalizedfile
#string xhmmFilterSample

module load ${xhmmVersion}

$EBROOTXHMM/bin/xhmm --normalize \
-r ${xhmmFilterSample} \
--PCAfiles ${xhmmPCAfile} \
--normalizeOutput ${xhmmPCANormalizedfile} \
--PCnormalizeMethod PVE_mean \
--PVE_mean_factor 0.7

#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
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

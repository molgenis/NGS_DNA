#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmVersion
#string xhmmDir
#string xhmmFilterSample
#string xhmmPCAfile

.  ./Controls.env

module load ${xhmmVersion}

$EBROOTXHMM/bin/xhmm --PCA \
-r ${xhmmFilterSample} \
--PCAfiles ${xhmmPCAfile}


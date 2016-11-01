#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmVersion
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmSameFiltered
#string xhmmXcnv
#string xhmmGenotypedCNV
#string xhmmPosterior
#string xhmmHighSenseParams
#string indexFile

.  ./Controls.env

module load ${xhmmVersion}


$EBROOTXHMM/bin/xhmm --genotype \
-p ${xhmmHighSenseParams} \
-r ${xhmmPCANormalizedfileFilteredZscores} \
-R ${xhmmSameFiltered} \
-g ${xhmmXcnv} \
-F ${indexFile} \
-v ${xhmmGenotypedCNV}

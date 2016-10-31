#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string DepthOfCoveragePerSample
#string xhmmMergedSample
#string intermediateDir
#string xhmmVersion
#string capturingKit

.  ./Controls.env

module load ${xhmmVersion}

makeTmpDir ${xhmmMergedSample}
tmpXhmmMergedSample=${MC_tmpFile}

$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
-o ${tmpXhmmMergedSample} \
--GATKdepths ${DepthOfCoveragePerSample}.${CAPT}.sample_interval_summary \
--GATKdepthsList ${xhmmControlsDir}/Controls.sample_interval_summary

printf "moving ${tmpXhmmMergedSample} to ${xhmmMergedSample} .. "
mv ${tmpXhmmMergedSample} ${xhmmMergedSample}
printf " .. done!"


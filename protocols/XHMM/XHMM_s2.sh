#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmControlsDir
#string DepthOfCoveragePerSample
#string xhmmMergedSample
#string intermediateDir
#string xhmmVersion
#string capturingKit

module load ${xhmmVersion}

makeTmpDir ${xhmmMergedSample}
tmpXhmmMergedSample=${MC_tmpFile}

## write capturingkit to file to make it easier to split
echo $capturingKit > ${intermediateDir}/capt.txt
CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)

$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
-o ${tmpXhmmMergedSample} \
--GATKdepths ${DepthOfCoveragePerSample}.${CAPT}.sample_interval_summary \
--GATKdepths ${xhmmControlsDir}/${CAPT}/Controls.sample_interval_summary

printf "moving ${tmpXhmmMergedSample} to ${xhmmMergedSample} .. "
mv ${tmpXhmmMergedSample} ${xhmmMergedSample}
printf " .. done!"


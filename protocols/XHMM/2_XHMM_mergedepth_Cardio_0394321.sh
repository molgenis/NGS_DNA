#string inputControls
#string inputPerSample
#string xhmm_Controls_SampleIntervals
#string DepthOfCoveragePerSample
#string xhmmMergedSample

module load ${xhmmVersion}

makeTmpDir ${xhmmMergedSample}
tmpXhmmMergedSample=${MC_tmpFile}

$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
-o ${tmpXhmmMergedSample} \
--GATKdepths ${DepthOfCoveragePerSample} \
--GATKdepths ${xhmm_Controls_SampleIntervals}

printf "moving ${tmpXhmmMergedSample} to ${xhmmMergedSample} .. "
mv ${tmpXhmmMergedSample} ${xhmmMergedSample}
printf " .. done!"


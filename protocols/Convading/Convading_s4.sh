#MOLGENIS walltime=05:59:00 mem=4gb ppn=1

#string convadingVersion
#string convadingControlsDir
#string convadingGenerateTargetQcList

module load convadingVersion

makeTmpDir ${convadingGenerateTargetQcList}
tmpConvadingGenerateTargetQcList=${MC_tmpFile}

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode GenerateTargetQcList \
-inputDir ${convadingControlsDir} \
-outputDir ${tmpConvadingGenerateTargetQcList} \
-controlsDir ${convadingControlsDir} 

printf "moving ${tmpConvadingGenerateTargetQcList} to ${convadingGenerateTargetQcList} .. "
mv ${tmpGenerateTargetQcList} ${convadingGenerateTargetQcList}
printf " .. done\n"

#MOLGENIS walltime=80:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingControlsDir
#string convadingGenerateTargetQcList
#string intermediateDir
#string capturingKit

module load ${convadingVersion}

makeTmpDir ${convadingGenerateTargetQcList}
tmpConvadingGenerateTargetQcList=${MC_tmpFile}

## write capturingkit to file to make it easier to split
echo $capturingKit > ${intermediateDir}/capt.txt
CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode GenerateTargetQcList \
-inputDir ${convadingControlsDir} \
-outputDir ${tmpConvadingGenerateTargetQcList} \
-controlsDir ${convadingControlsDir}/${CAPT}/ 

printf "moving ${tmpConvadingGenerateTargetQcList} to ${convadingGenerateTargetQcList} .. "
mv ${tmpConvadingGenerateTargetQcList}/* ${convadingGenerateTargetQcList}
printf " .. done\n"

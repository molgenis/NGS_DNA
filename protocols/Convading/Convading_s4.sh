#MOLGENIS walltime=80:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingGenerateTargetQcList
#string intermediateDir
#string capturingKit

. ./Controls.env

module load ${convadingVersion}

makeTmpDir ${convadingGenerateTargetQcList}
tmpConvadingGenerateTargetQcList=${MC_tmpFile}

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode GenerateTargetQcList \
-inputDir ${convadingControlsDir} \
-outputDir ${tmpConvadingGenerateTargetQcList} \
-controlsDir ${convadingControlsDir} 

printf "moving ${tmpConvadingGenerateTargetQcList} to ${convadingGenerateTargetQcList} .. "
mv ${tmpConvadingGenerateTargetQcList}/* ${convadingGenerateTargetQcList}
printf " .. done\n"

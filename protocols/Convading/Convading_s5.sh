#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingCreateFinalList
#string convadingStartWithBestScore
#string capturingKit
#string intermediateDir

. ./Controls.env

module load ${convadingVersion}

makeTmpDir ${convadingCreateFinalList}
tmpConvadingCreateFinalList=${MC_tmpFile}

## Creating directory
mkdir -p ${convadingCreateFinalList}

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode CreateFinalList \
-inputDir ${convadingStartWithBestScore} \
-outputDir ${tmpConvadingCreateFinalList} \
-targetQcList ${convadingControlsDir}/targetQcList.txt

printf "moving ${tmpConvadingCreateFinalList} to ${convadingCreateFinalList} .. "
mv ${tmpConvadingCreateFinalList}/* ${convadingCreateFinalList}
printf " .. done\n"

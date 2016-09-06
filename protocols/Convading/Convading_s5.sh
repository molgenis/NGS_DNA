#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingCreateFinalList
#string convadingStartWithBestScore
#string convadingControlsDir
#string capturingKit
#string intermediateDir

module load ${convadingVersion}

makeTmpDir ${convadingCreateFinalList}
tmpConvadingCreateFinalList=${MC_tmpFile}

## write capturingkit to file to make it easier to split
echo $capturingKit > ${intermediateDir}/capt.txt
CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)


## Creating directory
mkdir -p ${convadingCreateFinalList}

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode CreateFinalList \
-inputDir ${convadingStartWithBestScore} \
-outputDir ${tmpConvadingCreateFinalList} \
-targetQcList ${convadingControlsDir}/${CAPT}/targetQcList.txt

printf "moving ${tmpConvadingCreateFinalList} to ${convadingCreateFinalList} .. "
mv ${tmpConvadingCreateFinalList}/* ${convadingCreateFinalList}
printf " .. done\n"

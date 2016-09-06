#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingControlsDir
#string convadingStartWithMatchScore
#string convadingStartWithBestScore
#string intermediateDir
#string capturingKit

module load ${convadingVersion}

makeTmpDir ${convadingStartWithBestScore}
tmpConvadingStartWithBestScore=${MC_tmpFile}

## Creating directory
mkdir -p ${convadingStartWithBestScore}

## write capturingkit to file to make it easier to split
echo $capturingKit > ${intermediateDir}/capt.txt
CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode StartWithBestScore \
-inputDir ${convadingStartWithMatchScore} \
-outputDir ${tmpConvadingStartWithBestScore} \
-controlsDir ${convadingControlsDir}/${CAPT}/  

printf "moving ${tmpConvadingStartWithBestScore} to ${convadingStartWithBestScore} .. "
mv ${tmpConvadingStartWithBestScore}/* ${convadingStartWithBestScore}
printf " .. done\n"

#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingControlsDir
#string convadingStartWithMatchScore
#string convadingStartWithBam
#string intermediateDir
#string capturingKit

module load ${convadingVersion}

makeTmpDir ${convadingStartWithMatchScore}
tmpConvadingStartWithMatchScore=${MC_tmpFile}

## Creating directory
mkdir -p ${convadingStartWithMatchScore}

## write capturingkit to file to make it easier to split
echo $capturingKit > ${intermediateDir}/capt.txt
CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode StartWithMatchScore \
-inputDir ${convadingStartWithBam} \
-outputDir ${tmpConvadingStartWithMatchScore} \
-controlsDir ${convadingControlsDir}/${CAPT}/ 

printf "moving ${tmpConvadingStartWithMatchScore} to ${convadingStartWithMatchScore} .. "
mv ${tmpConvadingStartWithMatchScore}/* ${convadingStartWithMatchScore}
printf " .. done\n"


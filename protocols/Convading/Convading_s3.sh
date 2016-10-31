#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingStartWithMatchScore
#string convadingStartWithBestScore
#string intermediateDir
#string capturingKit

. ./Controls.env

module load ${convadingVersion}

makeTmpDir ${convadingStartWithBestScore}
tmpConvadingStartWithBestScore=${MC_tmpFile}

## Creating directory
mkdir -p ${convadingStartWithBestScore}

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode StartWithBestScore \
-inputDir ${convadingStartWithMatchScore} \
-outputDir ${tmpConvadingStartWithBestScore} \
-controlsDir ${convadingControlsDir}

printf "moving ${tmpConvadingStartWithBestScore} to ${convadingStartWithBestScore} .. "
mv ${tmpConvadingStartWithBestScore}/* ${convadingStartWithBestScore}
printf " .. done\n"

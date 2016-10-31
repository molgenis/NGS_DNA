#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string convadingStartWithMatchScore
#string convadingStartWithBam
#string intermediateDir
#string capturingKit

. ./Controls.env

module load ${convadingVersion}

makeTmpDir ${convadingStartWithMatchScore}
tmpConvadingStartWithMatchScore=${MC_tmpFile}

## Creating directory
mkdir -p ${convadingStartWithMatchScore}

perl ${EBROOTCONVADING}/CoNVaDING.pl \
-mode StartWithMatchScore \
-inputDir ${convadingStartWithBam} \
-outputDir ${tmpConvadingStartWithMatchScore} \
-controlsDir ${convadingControlsDir} 

printf "moving ${tmpConvadingStartWithMatchScore} to ${convadingStartWithMatchScore} .. "
mv ${tmpConvadingStartWithMatchScore}/* ${convadingStartWithMatchScore}
printf " .. done\n"


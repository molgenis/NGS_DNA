#!/bin/bash

module load NGS_DNA/3.4.1
module list 
HOST=$(hostname -s)
thisDir=$(pwd)

ENVIRONMENT_PARAMETERS="parameters_${HOST}.csv"
TMPDIRECTORY=$(basename $(cd ../../ && pwd ))
GROUP=$(basename $(cd ../../../ && pwd ))

PROJECT=projectXX
WORKDIR="/groups/${GROUP}/${TMPDIRECTORY}"
RUNID=runXX
SPECIES="homo_sapiens"
BUILD="b37"

## Normal user, please leave BATCH at _chr
## For expert modus: small batchsize (6) fill in '_small'  or per chromosome fill in _chr
BATCH="_chr"

GENSCRIPTS="${WORKDIR}/generatedscripts/${PROJECT}"

samplesheet=${GENSCRIPTS}/${PROJECT}.csv
mac2unix $samplesheet

python ${EBROOTNGS_DNA}/scripts/samplesize.py ${samplesheet} $thisDir
SAMPLESIZE=$(cat externalSampleIDs.txt | uniq | wc -l)

python ${EBROOTNGS_DNA}/scripts/gender.py $samplesheet
var=$(cat ${samplesheet}.tmp | wc -l)


if [ $var != 0 ]
then
    	mv ${samplesheet}.tmp ${samplesheet}
        echo "samplesheet updated with Gender column"
fi
echo "Samplesize is $SAMPLESIZE"

if [ $SAMPLESIZE -gt 199 ]
then
    	WORKFLOW=${EBROOTNGS_DNA}/workflow_samplesize_bigger_than_200.csv
else
        WORKFLOW=${EBROOTNGS_DNA}/workflow.csv
fi

if [ -f .compute.properties ];
then
     rm .compute.properties
fi

if [ -f ${GENSCRIPTS}/out.csv  ];
then
    	rm -rf ${GENSCRIPTS}/out.csv
fi

echo "tmpName,${TMPDIRECTORY}" > ${GENSCRIPTS}/tmpdir_parameters.csv 

perl ${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl ${GENSCRIPTS}/tmpdir_parameters.csv > \
${GENSCRIPTS}/tmpdir_parameters_converted.csv

perl ${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl ${EBROOTNGS_DNA}/parameters.csv > \
${GENSCRIPTS}/out.csv

perl ${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl ${EBROOTNGS_DNA}/parameters_${GROUP}.csv > \
${GENSCRIPTS}/group_parameters.csv

perl ${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl ${EBROOTNGS_DNA}/${ENVIRONMENT_PARAMETERS} > \
${GENSCRIPTS}/environment_parameters.csv


sh $EBROOTMOLGENISMINCOMPUTE/molgenis_compute.sh \
-p ${GENSCRIPTS}/out.csv \
-p ${GENSCRIPTS}/group_parameters.csv \
-p ${GENSCRIPTS}/environment_parameters.csv \
-p ${GENSCRIPTS}/tmpdir_parameters_converted.csv \
-p ${EBROOTNGS_DNA}/batchIDList${BATCH}.csv \
-p ${GENSCRIPTS}/${PROJECT}.csv \
-w ${EBROOTNGS_DNA}/create_in-house_ngs_projects_workflow.csv \
-rundir ${GENSCRIPTS}/scripts \
--runid ${RUNID} \
-o "workflowpath=${WORKFLOW};\
outputdir=scripts/jobs;mainParameters=${GENSCRIPTS}/out.csv;\
group_parameters=${GENSCRIPTS}/group_parameters.csv;\
groupname=${GROUP};\
ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)');\
environment_parameters=${GENSCRIPTS}/environment_parameters.csv;\
tmpdir_parameters=${GENSCRIPTS}/tmpdir_parameters_converted.csv;\
batchIDList=${EBROOTNGS_DNA}/batchIDList${BATCH}.csv;\
worksheet=${GENSCRIPTS}/${PROJECT}.csv" \
-weave \
--generate


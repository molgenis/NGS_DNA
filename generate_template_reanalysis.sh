#!/bin/bash

if [ -e $1 ]
then
    	echo "this script needs 1 argument with the name of the run that needs to be reanalyzed (e.g. run01) and one optional parameter which can contain the groupname of the previous run on prm"
        exit 0
fi

module load NGS_DNA/3.2.5
module list 
HOST=$(hostname)
THISDIR=$(pwd)

previousRun=$1

ENVIRONMENT_PARAMETERS="parameters_${HOST%%.*}.csv"
TMPDIRECTORY=$(basename $(cd ../../ && pwd ))
GROUP=$(basename $(cd ../../../ && pwd ))

groupPreviousRun=$GROUP
if [ ! -e $2 ]
then
	groupPreviousRun=$2				
fi

PROJECT=projectXX
WORKDIR="/groups/${GROUP}/${TMPDIRECTORY}"
RUNID=runXX_reanalysis

## Normal user, please leave BATCH at _chr
## For expert modus: small batchsize (6) fill in '_small'  or per chromosome fill in _chr
BATCH="_chr"

SAMPLESIZE=$(( $(sh ${EBROOTNGS_DNA}/samplesize.sh ${WORKDIR}/generatedscripts/${PROJECT}/${PROJECT}.csv $THISDIR) -1 ))
echo "Samplesize is $SAMPLESIZE"
if [ $SAMPLESIZE -gt 199 ]
then
    	WORKFLOW=${EBROOTNGS_DNA}/workflow_samplesize_bigger_than_200.csv
else
        WORKFLOW=${EBROOTNGS_DNA}/workflow_reanalysis.csv
fi

if [ -f .compute.properties ];
then
     rm .compute.properties
fi

if [ -f ${WORKDIR}/generatedscripts/${PROJECT}/out.csv  ];
then
    	rm -rf ${WORKDIR}/generatedscripts/${PROJECT}/out.csv
fi

echo "tmpName,${TMPDIRECTORY}" > ${WORKDIR}/generatedscripts/${PROJECT}/tmpdir_parameters.csv 

perl ${EBROOTNGS_DNA}/convertParametersGitToMolgenis.pl ${WORKDIR}/generatedscripts/${PROJECT}/tmpdir_parameters.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/tmpdir_parameters_converted.csv

perl ${EBROOTNGS_DNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_DNA}/parameters.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/out.csv

perl ${EBROOTNGS_DNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_DNA}/parameters_${GROUP}.csv > \
${WORKDIR}/generatedscripts/${PROJECT}/group_parameters.csv

perl ${EBROOTNGS_DNA}/convertParametersGitToMolgenis.pl ${EBROOTNGS_DNA}/${ENVIRONMENT_PARAMETERS} > \
${WORKDIR}/generatedscripts/${PROJECT}/environment_parameters.csv

sh $EBROOTMOLGENISMINCOMPUTE/molgenis_compute.sh \
-p ${WORKDIR}/generatedscripts/${PROJECT}/out.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/group_parameters.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/environment_parameters.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/tmpdir_parameters_converted.csv \
-p ${EBROOTNGS_DNA}/batchIDList${BATCH}.csv \
-p ${WORKDIR}/generatedscripts/${PROJECT}/${PROJECT}.csv \
-w ${EBROOTNGS_DNA}/create_reanalysis_workflow.csv \
-rundir ${WORKDIR}/generatedscripts/${PROJECT}/scripts \
--runid ${RUNID} \
-o "workflowpath=${WORKFLOW};\
outputdir=scripts/jobs;mainParameters=${WORKDIR}/generatedscripts/${PROJECT}/out.csv;\
group_parameters=${WORKDIR}/generatedscripts/${PROJECT}/group_parameters.csv;\
groupname=${GROUP};\
previousRun=${previousRun};\
ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)');\
environment_parameters=${WORKDIR}/generatedscripts/${PROJECT}/environment_parameters.csv;\
tmpdir_parameters=${WORKDIR}/generatedscripts/${PROJECT}/tmpdir_parameters_converted.csv;\
batchIDList=${EBROOTNGS_DNA}/batchIDList${BATCH}.csv;\
worksheet=${WORKDIR}/generatedscripts/${PROJECT}/${PROJECT}.csv" \
-weave \
--generate


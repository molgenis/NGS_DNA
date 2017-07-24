#!/bin/bash

module load NGS_DNA/3.4.1
module list
host=$(hostname -s)
environmentParameters="parameters_${host}.csv"

function showHelp() {
	#
	# Display commandline help on STDOUT.
	#
	cat <<EOH
===============================================================================================================
Script to copy (sync) data from a succesfully finished analysis project from tmp to prm storage.
Usage:
	$(basename $0) OPTIONS
Options:
	-h   Show this help.
	-a   sampleType (DNA or RNA) (default=DNA)
	-b   build (default=b37)
	-c   batch (_chr or _small) (default=_chr)
	-g   group (default=basename of ../../../ )
	-p   project (default=basename of this directory)
	-r   runid (default=run01)
	-s   species (default=homo_sapiens)
	-t   tmpdirectory (default=basename of ../../ )
	-w   workdir (default=/groups/\${group}/\${tmpDirectory})

===============================================================================================================
EOH
	trap - EXIT
	exit 0
}


while getopts "t:g:w:p:r:s:b:c:h" opt; 
do
	case $opt in h)showHelp;; t)tmpDirectory="${OPTARG}";; g)group="${OPTARG}";; w)workDir="${OPTARG}";; p)project="${OPTARG}";; r)runID="${OPTARG}";; s)species="${OPTARG}";; b)build="${OPTARG}";; c)batch="${OPTARG}";; 
	esac 
done

if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory=$(basename $(cd ../../ && pwd )) ; fi ; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group=$(basename $(cd ../../../ && pwd )) ; fi ; echo "group=${group}"
if [[ -z "${workDir:-}" ]]; then workDir="/groups/${group}/${tmpDirectory}" ; fi ; echo "workDir=${workDir}"
if [[ -z "${project:-}" ]]; then project=$(basename $(pwd )) ; fi ; echo "project=${project}"
if [[ -z "${runID:-}" ]]; then runID="run01" ; fi ; echo "runid=$runid"
if [[ -z "${species:-}" ]]; then species="homo_sapiens" ; fi ; echo "species=${species}"
if [[ -z "${build:-}" ]]; then build="b37" ; fi ;echo "build=${build}"
if [[ -z "${batch:-}" ]]; then batch=_chr; fi ; echo "batch=${batch}"


## Normal user, please leave BATCH at _chr
## For expert modus: small batchsize (6) fill in '_small'  or per chromosome fill in _chr

genScripts="${workDir}/generatedscripts/${project}"
samplesheet="${genScripts}/${project}.csv" ; mac2unix "${samplesheet}"

python "${EBROOTNGS_DNA}/scripts/samplesize.py" "${samplesheet}" $(pwd)
sampleSize=$(cat externalSampleIDs.txt | uniq | wc -l)
echo "Samplesize is ${sampleSize}"

python "${EBROOTNGS_DNA}/scripts/gender.py" "${samplesheet}"
var=$(cat "${samplesheet}.tmp" | wc -l)


if [ "${var}" != 0 ]
then
	mv "${samplesheet}.tmp" "${samplesheet}"
        echo "samplesheet updated with Gender column"
fi

if [ $sampleSize -gt 199 ]
then
	workflow="${EBROOTNGS_DNA}/workflow_samplesize_bigger_than_200.csv"
else
        workflow="${EBROOTNGS_DNA}/workflow.csv"
fi

if [ -f "${genScripts}/out.csv"  ];then rm -rf "${genScripts}/out.csv" ; fi

echo "tmpName,${tmpDirectory}" > ${genScripts}/tmpdir_parameters.csv 
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${genScripts}/tmpdir_parameters.csv" > "${genScripts}/tmpdir_parameters_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters.csv" > "${genScripts}/out.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters_${GROUP}.csv" > "${genScripts}/group_parameters.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/${environmentParameters}" > "${genScripts}/environment_parameters.csv"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
-p "${genScripts}/out.csv" \
-p "${genScripts}/group_parameters.csv" \
-p "${genScripts}/environment_parameters.csv" \
-p "${genScripts}/tmpdir_parameters_converted.csv" \
-p "${EBROOTNGS_DNA}/batchIDList${batch}.csv" \
-p "${genScripts}/${project}.csv" \
-w "${EBROOTNGS_DNA}/create_in-house_ngs_projects_workflow.csv" \
-rundir "${genScripts}/scripts" \
--runid "${runID}" \
-o "workflowpath="${workflow}";\
outputdir=scripts/jobs;mainParameters="${genScripts}/out.csv";\
group_parameters="${genScripts}/group_parameters.csv";\
groupname="${group}";\
ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)');\
environment_parameters="${genScripts}/environment_parameters.csv";\
tmpdir_parameters="${genScripts}/tmpdir_parameters_converted.csv";\
batchIDList="${EBROOTNGS_DNA}/batchIDList${batch}.csv";\
worksheet="${genScripts}/${project}.csv" \
-weave \
--generate


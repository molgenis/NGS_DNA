#!/bin/bash

if module list | grep -o -P 'NGS_DNA(.+)' 
then
	echo "DNA pipeline loaded, proceding"
else
	echo "No DNA Pipeline loaded, exiting"
        exit 1
fi

module list

host=$(hostname -s)
environmentParameters="parameters_${host}"

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
	-p   projectname
	-a   sampleType (DNA or RNA) (default=DNA)
	-g   group (default=basename of ../../../ )
	-f   filePrefix (default=basename of this directory)
	-r   runID (default=run01)
	-t   tmpDirectory (default=basename of ../../ )
	-w   workDir (default=/groups/\${group}/\${tmpDirectory})

===============================================================================================================
EOH
	trap - EXIT
	exit 0
}


while getopts "t:g:w:f:r:p:h" opt;
do
	case $opt in h)showHelp;; t)tmpDirectory="${OPTARG}";; g)group="${OPTARG}";; w)workDir="${OPTARG}";; f)filePrefix="${OPTARG}";; p)project="${OPTARG}";; r)runID="${OPTARG}";;
	esac
done

if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory=$(basename $(cd ../../ && pwd )) ; fi ; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group=$(basename $(cd ../../../ && pwd )) ; fi ; echo "group=${group}"
if [[ -z "${workDir:-}" ]]; then workDir="/groups/${group}/${tmpDirectory}" ; fi ; echo "workDir=${workDir}"
if [[ -z "${filePrefix:-}" ]]; then filePrefix=$(basename $(pwd )) ; fi ; echo "filePrefix=${filePrefix}"
if [[ -z "${runID:-}" ]]; then runID="run01" ; fi ; echo "runID=${runID}"
if [[ -z "${project:-}" ]]; then project="${filePrefix}" ; fi ; echo "project=${project}"

genScripts="${workDir}/generatedscripts/${filePrefix}/"
samplesheet="${genScripts}/${filePrefix}.csv" ; mac2unix "${samplesheet}"

#
## Checking for columns: externalSampleID, species, build, project and sampleType and creating {COLUMNNAME}.txt.tmp files
## Checking for genderColumn
#
# load PythonPlus/2x version
python2Version=$(module list | grep -o -P 'PythonPlus/2.(.+)')
ml "${python2Version}"

python "${EBROOTNGS_DNA}/scripts/sampleSheetChecker.py" "${samplesheet}"
if [ -f "${samplesheet}.temp" ]
then
	mv "${samplesheet}.temp" "${samplesheet}"
fi
## adding columns if they are not present in the samplesheet
for i in "Gender" "MotherSampleId" "FatherSampleId" "MotherAffected" "FatherAffected" "FirstPriority"
do
	python "${EBROOTNGS_DNA}/scripts/updatingColumns.py" "${samplesheet}" "${i}" ; mv "${samplesheet}.tmp" "${samplesheet}"
done

## get only uniq lines and removing txt.tmp file
for i in $(ls *.txt.tmp); do cat "${i}" | sort -u > ${i%.*} ; rm "${i}" ;done

build="b37"
species="homo_sapiens"

if [ -s build.txt ]; then build=$(cat build.txt);fi
if [ -s species.txt ];then species=$(cat species.txt); fi

sampleSize=$(cat externalSampleIDs.txt |  wc -l) ; echo "Samplesize is ${sampleSize}"

if [ $sampleSize -gt 199 ];then	workflow=${EBROOTNGS_DNA}/workflow_samplesize_bigger_than_200.csv ; else workflow=${EBROOTNGS_DNA}/workflow.csv ;fi

### Converting parameters to compute parameters
echo "tmpName,${tmpDirectory}" > ${genScripts}/tmpdir_parameters.csv
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${genScripts}/tmpdir_parameters.csv" > "${genScripts}/parameters_tmpdir_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters.csv" > "${genScripts}/parameters_converted.csv"
#perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters_${group}.csv" > "${genScripts}/parameters_group_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/${environmentParameters}.csv" > "${genScripts}/parameters_environment_converted.csv"

## has to be set, otherwise it will crash due to parameters which are not set, this variable will be updated in the next step
batching="_small"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
-p "${genScripts}/parameters_converted.csv" \
-p "${genScripts}/parameters_tmpdir_converted.csv" \
-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" \
-p "${genScripts}/parameters_environment_converted.csv" \
-p "${genScripts}/${filePrefix}.csv" \
-w "${EBROOTNGS_DNA}/create_in-house_ngs_projects_workflow.csv" \
-rundir "${genScripts}/scripts" \
--runid "${runID}" \
-o workflowpath="${workflow};\
outputdir=scripts/jobs;mainParameters=${genScripts}/parameters_converted.csv;\
groupname=${group};\
workDir=${workDir};\
ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)');\
environment_parameters=${genScripts}/parameters_environment_converted.csv;\
tmpdir_parameters=${genScripts}/parameters_tmpdir_converted.csv;\
sampleSize=${sampleSize};\
worksheet=${genScripts}/${filePrefix}.csv;\
runid=${runID}" \
-weave \
--generate

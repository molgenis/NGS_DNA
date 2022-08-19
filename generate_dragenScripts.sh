#!/bin/bash
if module -t list NGS_DNA | grep NGS_DNA
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
	-a   sampleType (DNA or RNA) (default=DNA)
	-g   group (default=basename of ../../../ )
	-f   filePrefix (default=basename of this directory)
	-r   runID (default=run01)
	-t   tmpDirectory (default=basename of ../../ )
	-w   groupDir (default=/groups/\${group}/)

===============================================================================================================
EOH
	trap - EXIT
	exit 0
}


while getopts "t:g:w:f:r:h" opt;
do
	case $opt in h)showHelp;; t)tmpDirectory="${OPTARG}";; g)group="${OPTARG}";; w)groupDir="${OPTARG}";; f)filePrefix="${OPTARG}";; r)runID="${OPTARG}";;
	esac
done

if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory=$(basename $(cd ../../ && pwd )) ; fi ; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group=$(basename $(cd ../../../ && pwd )) ; fi ; echo "group=${group}"
if [[ -z "${groupDir:-}" ]]; then groupDir="/groups/${group}/" ; fi ; echo "groupDir=${groupDir}"
if [[ -z "${filePrefix:-}" ]]; then filePrefix=$(basename $(pwd )) ; fi ; echo "filePrefix=${filePrefix}"
if [[ -z "${runID:-}" ]]; then runID="run01" ; fi ; echo "runID=${runID}"

genScripts="${groupDir}/${tmpDirectory}/generatedscripts/${filePrefix}/"
samplesheet="${genScripts}/${filePrefix}.csv" ; mac2unix "${samplesheet}"

#
## Checking for columns: externalSampleID, species, build, project and sampleType and creating {COLUMNNAME}.txt.tmp files
## Checking for genderColumn
#
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

workflow=${EBROOTNGS_DNA}/workflow.csv

### Converting parameters to compute parameters
echo "tmpName,${tmpDirectory}" > ${genScripts}/tmpdir_parameters.csv
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${genScripts}/tmpdir_parameters.csv" > "${genScripts}/parameters_tmpdir_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters.csv" > "${genScripts}/parameters_converted.csv"
#perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters_${group}.csv" > "${genScripts}/parameters_group_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/${environmentParameters}.csv" > "${genScripts}/parameters_environment_converted.csv"

## has to be set, otherwise it will crash due to parameters which are not set, this variable will be updated in the next step
batching="_small"

ngsversion=$(module -t list NGS_DNA)
projectJobsDir="${workDir}/projects/${filePrefix}/${runID}/jobs/"
projectResultsDir="${workDir}/projects/${filePrefix}/${runID}/results/"
intermediateDir="${workDir}/tmp/${filePrefix}/${runID}/"
projectLogsDir="${workDir}/logs/${filePrefix}/"


mkdir -p "${projectJobsDir}"
mkdir -p "${projectLogsDir}"
mkdir -p "${intermediateDir}"
mkdir -p "${projectResultsDir}"

cp "${samplesheet}" ${projectJobsDir}/${filePrefix}.csv
cp "${vcfFile}" "${intermediateDir}"


${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh \
-p "parameters_converted.csv" \
-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" -p "${projectJobsDir}/${filePrefix}.csv" -p "parameters_environment_converted.csv" -p "parameters_group_converted.csv" -p "parameters_tmpdir_converted.csv" \
-rundir "${projectJobsDir}" \
--header "${EBROOTNGS_DNA}/templates/slurm/header.ftl" \
--footer "${EBROOTNGS_DNA}/templates/slurm/footer.ftl" \
--submit "${EBROOTNGS_DNA}/templates/slurm/submit.ftl" \
-w "${EBROOTNGS_DNA}/workflow_DRAGEN.csv" \
-b slurm \
-g \
-weave \
-runid "${runID}" \
-o "ngsversion=${ngsversion};groupname=${group};inputVcf=${intermediateDir}/${vcfFile}"

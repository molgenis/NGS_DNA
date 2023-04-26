#!/bin/bash
set -eu
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
        -t   tmpDirectory (default=basename of ../../../ )
        -g   group (default=basename of ../../../../ && pwd )
        -w   groupDir (default=basename of ../../../../ && pwd )
        -f   filePrefix (default=basename of this directory)
        -r   runID (default=run01)

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

if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory=$(basename $(cd ../../../ && pwd )) ; fi ; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group=$(basename $(cd ../../../../ && pwd )) ; fi ; echo "group=${group}"
if [[ -z "${groupDir:-}" ]]; then groupDir="/groups/${group}/" ; fi ; echo "groupDir=${groupDir}"
if [[ -z "${filePrefix:-}" ]]; then filePrefix=$(basename $(pwd )) ; fi ; echo "filePrefix=${filePrefix}"
if [[ -z "${runID:-}" ]]; then runID="run01" ; fi ; echo "runID=${runID}"

genScripts="${groupDir}/${tmpDirectory}/generatedscripts/NGS_DNA/${filePrefix}/"
samplesheet="${genScripts}/${filePrefix}.csv"
workDir="/groups/${group}/${tmpDirectory}/"
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

resourcesParameters="${EBROOTNGS_DNA}/parameters_resources_exome.csv"
batching="_small"

if [ -s capturingKit.txt ];then capturingKit=$(cat capturingKit.txt); fi
if [[ ${capturingKit,,} == *"wgs"* ]]
then
	batching="_chr"
	resourcesParameters="${EBROOTNGS_DNA}/parameters_resources_wgs.csv"
elif [[ ${capturingKit,,} == *"exoom"* ]]
then
	batching="_chr"
fi
	
sampleSize=$(cat externalSampleIDs.txt |  wc -l) ; echo "Samplesize is ${sampleSize}"

### Converting parameters to compute parameters
echo "tmpName,${tmpDirectory}" > ${genScripts}/tmpdir_parameters.csv
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${genScripts}/tmpdir_parameters.csv" > "${genScripts}/parameters_tmpdir_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters.csv" > "${genScripts}/parameters_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/${environmentParameters}.csv" > "${genScripts}/parameters_environment_converted.csv"

perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${resourcesParameters}" > "resources_parameters.converted.csv"

## has to be set, otherwise it will crash due to parameters which are not set, this variable will be updated in the next step
batching="_chr"

ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)')
projectJobsDir="${workDir}/projects/NGS_DNA/${filePrefix}/${runID}/jobs/"
projectResultsDir="${workDir}/projects/NGS_DNA/${filePrefix}/${runID}/results/"
intermediateDir="${workDir}/tmp/NGS_DNA/${filePrefix}/${runID}/"
projectLogsDir="${workDir}/logs/${filePrefix}/"

mkdir -p "${intermediateDir}"
mkdir -p "${projectJobsDir}"
mkdir -p "${projectLogsDir}"
mkdir -p "${projectResultsDir}/"{alignment,general}
mkdir -p "${projectResultsDir}/coverage/CoveragePer"{Base,Target}"/"{male,female,unknown}
mkdir -p "${projectResultsDir}/qc/statistics/"
mkdir -p "${projectResultsDir}/variants/"{cnv,gVCF,GAVIN}/
mkdir -p -m 2770 "${projectLogsDir}"

cp "${samplesheet}" "${projectJobsDir}/${filePrefix}.csv"

${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh \
-p "parameters_converted.csv" \
-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" \
-p "${projectJobsDir}/${filePrefix}.csv" \
-p "${genScripts}/parameters_environment_converted.csv" \
-p "${genScripts}/parameters_tmpdir_converted.csv" \
-p "resources_parameters.converted.csv" \
-rundir "${projectJobsDir}" \
--header "${EBROOTNGS_DNA}/templates/slurm/header.ftl" \
--footer "${EBROOTNGS_DNA}/templates/slurm/footer.ftl" \
--submit "${EBROOTNGS_DNA}/templates/slurm/submit.ftl" \
-w "${EBROOTNGS_DNA}/workflow_DRAGEN.csv" \
-b slurm \
-runid "${runID}" \
-o "ngsversion=${ngsversion};\
groupname=${group};\
worksheet=${genScripts}/${filePrefix}.csv;\
batchIDList=${EBROOTNGS_DNA}/batchIDList${batching}.csv;\
sampleSize=${sampleSize};\
groupDir=${groupDir};\
workDir=${workDir};\
runid=${runID}" \
-g \
-weave 

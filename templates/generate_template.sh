#!/bin/bash

module load NGS_DNA/3.4.2
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
	-w   workdir (default=/groups/\${group}/\${tmpDirectory})

===============================================================================================================
EOH
	trap - EXIT
	exit 0
}


while getopts "t:g:w:f:r:h" opt; 
do
	case $opt in h)showHelp;; t)tmpDirectory="${OPTARG}";; g)group="${OPTARG}";; w)workDir="${OPTARG}";; f)filePrefix="${OPTARG}";; r)runID="${OPTARG}";; 
	esac 
done

if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory=$(basename $(cd ../../ && pwd )) ; fi ; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group=$(basename $(cd ../../../ && pwd )) ; fi ; echo "group=${group}"
if [[ -z "${workDir:-}" ]]; then workDir="/groups/${group}/${tmpDirectory}" ; fi ; echo "workDir=${workDir}"
if [[ -z "${filePrefix:-}" ]]; then filePrefix=$(basename $(pwd )) ; fi ; echo "filePrefix=${filePrefix}"
if [[ -z "${runID:-}" ]]; then runID="run01" ; fi ; echo "runID=${runID}"

genScripts="${workDir}/generatedscripts/${filePrefix}/"
samplesheet="${genScripts}/${filePrefix}.csv" ; mac2unix "${samplesheet}"

#
## Checking for columns: externalSampleID, species, build, project and sampleType and creating {COLUMNNAME}.txt.tmp files
## Checking for genderColumn
#
python "${EBROOTNGS_DNA}/scripts/sampleSheetChecker.py" "${samplesheet}"
if [ -f "${samplesheet}.tmpie" ]
then
    	mv "${samplesheet}.tmpie" "${samplesheet}"
fi
python "${EBROOTNGS_DNA}/scripts/gender.py" "${samplesheet}"

## get only uniq lines and removing txt.tmp file
for i in $(ls *.txt.tmp); do cat "${i}" | sort -u > ${i%.*} ; rm "${i}" ;done

build="b37"
species="homo_sapiens"

if [ -s build.txt ]; then build=$(cat build.txt);fi
if [ -s species.txt ];then species=$(cat species.txt); fi

sampleSize=$(cat externalSampleIDs.txt |  wc -l) ; echo "Samplesize is ${sampleSize}"
genderColumn=$(cat "${samplesheet}.tmp" | wc -l)

if [ "${genderColumn}" != 0 ];then mv "${samplesheet}.tmp" "${samplesheet}"; echo "samplesheet updated with Gender column" ;fi
## Check which batching to use
while read line ;do 
	if [[ "${line}" == *"Exoom"* || "${line}" == *"All_Exon"* || "${line}" == *"WGS"* || "${line}" == *"wgs"* ]]
	then
		if [ "${batching}" == "_small" ]; then echo "There are 2 different types of capturingKits in the samplesheet, _small and _chr, EXIT"; exit 1; fi
		batching="_chr"
	else
		if [ "${batching}" == "_chr" ]; then  echo "There are 2 different types of capturingKits in the samplesheet, _small and _chr, EXIT" ; exit 1; fi
		batching="_small"
	fi
done<capturingKit.txt

if [ $sampleSize -gt 199 ];then	workflow=${EBROOTNGS_DNA}/workflow_samplesize_bigger_than_200.csv ; else workflow=${EBROOTNGS_DNA}/workflow.csv ;fi

echo "tmpName,${tmpDirectory}" > ${genScripts}/tmpdir_parameters.csv 
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${genScripts}/tmpdir_parameters.csv" > "${genScripts}/parameters_tmpdir_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters.csv" > "${genScripts}/parameters_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters_${group}.csv" > "${genScripts}/parameters_group_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/${environmentParameters}.csv" > "${genScripts}/parameters_environment_converted.csv"

echo "BATCHIDLIST=${EBROOTNGS_DNA}/batchIDList${batching}.csv"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
-p "${genScripts}/parameters_converted.csv" \
-p "${genScripts}/parameters_tmpdir_converted.csv" \
-p "${genScripts}/parameters_group_converted.csv" \
-p "${genScripts}/parameters_environment_converted.csv" \
-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" \
-p "${genScripts}/${filePrefix}.csv" \
-w "${EBROOTNGS_DNA}/create_in-house_ngs_projects_workflow.csv" \
-rundir "${genScripts}/scripts" \
--runid "${runID}" \
-o workflowpath="${workflow};\
outputdir=scripts/jobs;mainParameters=${genScripts}/parameters_converted.csv;\
group_parameters=${genScripts}/parameters_group_converted.csv;\
groupname=${group};\
ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)');\
environment_parameters=${genScripts}/parameters_environment_converted.csv;\
tmpdir_parameters=${genScripts}/parameters_tmpdir_converted.csv;\
batchIDList=${EBROOTNGS_DNA}/batchIDList${batching}.csv;\
worksheet=${genScripts}/${filePrefix}.csv" \
-weave \
--generate

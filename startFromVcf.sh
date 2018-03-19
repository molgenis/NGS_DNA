#!/bin/bash


set -e
set -u
module load NGS_DNA/3.4.3
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
	-c   capturingKit
	-v   inputfile (vcf or vcf.gz)

===============================================================================================================
EOH
	trap - EXIT
	exit 0
}


while getopts "t:g:w:f:r:c:v:h" opt; 
do
	case $opt in h)showHelp;; t)tmpDirectory="${OPTARG}";; g)group="${OPTARG}";; w)workDir="${OPTARG}";; f)filePrefix="${OPTARG}";; c)capturingKit="${OPTARG}";; v)vcfFile="${OPTARG}";; r)runID="${OPTARG}";; 
	esac 
done
if [[ -z "${capturingKit:-}" ]]; then echo -e '\nERROR: Must specify an capturingKit\n' ;showHelp ; exit 1 ; fi
if [[ -z "${vcfFile:-}" ]]; then echo -e '\nERROR: Must specify an inputFile (vcf)\n' ;showHelp ; exit 1 ; fi

if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory=$(basename $(cd ../../ && pwd )) ; fi ; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group=$(basename $(cd ../../../ && pwd )) ; fi ; echo "group=${group}"
if [[ -z "${workDir:-}" ]]; then workDir="/groups/${group}/${tmpDirectory}" ; fi ; echo "workDir=${workDir}"
if [[ -z "${filePrefix:-}" ]]; then filePrefix=$(basename $(pwd )) ;fi ; echo "filePrefix=${filePrefix}"
if [[ -z "${runID:-}" ]]; then runID="run01" ; fi ; echo "runID=${runID}"

vcfExtension=${vcfFile##*.}

if [[ "${vcfExtension}" == "vcf" || "${vcfExtension}" == "gz" ]]
then
	if [ "${vcfExtension}" == "gz" ]
	then
		inputVcf=${vcfFile%.*}
		gzip -c -d "${vcfFile}" > "${inputVcf}"
	else
		inputVcf=${vcfFile}
	fi

	header=$(head -1 "${inputVcf}")
	if [[ "${header}" == *fileformat=VCF* ]]
	then
		echo "valid vcf Format"
	else
		echo "ERROR:the header of the file does not contain vcf header, is the format correct?"
		exit 0
	fi
else
	echo "ERROR:the extension of the file is not vcf, please select only vcf files"
	exit 0
fi


## make samplesheet
sh ${EBROOTNGS_DNA}/scripts/convertVcfToSamplesheet.sh -i "${inputVcf}" -p "${filePrefix}" -c "${capturingKit}" 
genScripts="${workDir}/generatedscripts/${filePrefix}/"
samplesheet="${genScripts}/${filePrefix}.csv"

build="b37"
species="homo_sapiens"

if [ -s build.txt ]; then build=$(cat build.txt);fi
if [ -s species.txt ];then species=$(cat species.txt); fi
sampleSize=$(cat "${genScripts}/${filePrefix}.csv" |  wc -l) ; echo "Samplesize is ${sampleSize}"
batching="_chr"

echo "tmpName,${tmpDirectory}" > ${genScripts}/tmpdir_parameters.csv 
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${genScripts}/tmpdir_parameters.csv" > "${genScripts}/parameters_tmpdir_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters.csv" > "${genScripts}/parameters_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/parameters_${group}.csv" > "${genScripts}/parameters_group_converted.csv"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${EBROOTNGS_DNA}/${environmentParameters}.csv" > "${genScripts}/parameters_environment_converted.csv"

echo "BATCHIDLIST=${EBROOTNGS_DNA}/batchIDList${batching}.csv"

ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)')
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
-w "${EBROOTNGS_DNA}/workflow_startFromVcf.csv" \
-b slurm \
-g \
-weave \
-runid "${runID}" \
-o "ngsversion=${ngsversion};groupname=${group};inputVcf=${intermediateDir}/${vcfFile}"

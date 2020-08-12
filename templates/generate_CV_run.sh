#!/bin/bash

set -e
set -u

function showHelp() {
	cat <<- EOH
		===============================================================================================================
		Script to start the Continuous Validation fork of the NGS_DNA pipeline.
		Usage:
		    $(basename $0) OPTIONS
		Options:
		    -h   Show this help.
		    -g   group (default=basename of ../../../ )
		    -f   filePrefix (default=basename of this directory)
		    -r   runID (default=runCV)
		    -t   tmpDirectory (default=basename of ../../ )
		    -w   workdir (default=/groups/\${group}/\${tmpDirectory})
		    -c   capturingKit
		    -p   previous run (default=run01)

		===============================================================================================================
	EOH
	trap - EXIT
	exit 0
}


while getopts "t:g:w:f:r:c:v:p:h" opt;
do
	case $opt in
		h) showHelp;;
		t) tmpDirectory="${OPTARG}";;
		g) group="${OPTARG}";;
		w) workDir="${OPTARG}";;
		f) filePrefix="${OPTARG}";;
		# c) capturingKit="${OPTARG}";;
		r) runID="${OPTARG}";; 
		p) prevrunID="${OPTARG}";;
	esac 
done


# if [[ -z "${capturingKit:-}" ]]; then echo -e '\nERROR: Must specify an capturingKit\n'; showHelp; exit 1; fi
if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory="$(basename "$(cd ../../ && pwd)")"; fi; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group="$(basename "$(cd ../../../ && pwd)")"; fi; echo "group=${group}"
if [[ -z "${workDir:-}" ]]; then workDir="/groups/${group}/${tmpDirectory}"; fi; echo "workDir=${workDir}"
if [[ -z "${filePrefix:-}" ]]; then filePrefix="$(basename "$(pwd)")"; fi; echo "filePrefix=${filePrefix}"
if [[ -z "${runID:-}" ]]; then runID="runCV"; fi; echo "runID=${runID}"
if [[ -z "${prevrunID:-}" ]]; then prevrunID="run01"; fi; echo "prevrunID=${prevrunID}"


# Setup directory variables.
genScripts="${workDir}/generatedscripts/${filePrefix}/"
projectJobsDir="${workDir}/projects/${filePrefix}/${runID}/jobs/"
projectResultsDir="${workDir}/projects/${filePrefix}/${runID}/results/"
intermediateDir="${workDir}/tmp/${filePrefix}/${runID}/"


# Make project subdirectories.
mkdir -p "${projectJobsDir}"
mkdir -p "${projectResultsDir}"
mkdir -p "${intermediateDir}"
# mkdir -p "${projectResultsDir}/qc/statistics/"
mkdir -p "${projectResultsDir}/variants/cnv/"
mkdir -p "${projectResultsDir}/variants/gVCF/"
mkdir -p "${projectResultsDir}/variants/GAVIN/"
mkdir -p "${projectResultsDir}/general"
# mkdir -p "${projectQcDir}"
mkdir -p "${intermediateDir}/GeneNetwork/"
# mkdir -p -m 2770 "${logsDir}/${project}/


# Create a new sample sheet with the hybrid sample added.
prometheus_yaml="prometheus.sample_info.yaml"
samplesheet="${genScripts}/${filePrefix}.csv"
altmap_yaml="alt_ss_field_mappings.yaml"
samplesheet_cv="${genScripts}/${filePrefix}_CV.csv"

python add_prometheus.py "${prometheus_yaml}" "${samplesheet}" "${altmap_yaml}" "${samplesheet_cv}"
cp "${samplesheet_cv}" "${projectJobsDir}/${filePrefix}.csv"


# Make symbolic links.
previous_gvcf_dir="${projectResultsDir/$runID/$prevrunID}/variants/gVCF/"
gvcf_dir="${projectResultsDir}/variants/gVCF/"
prometheus_gvcf_folder="/groups/umcg-atd/tmp03/projects/ContinuousValidation/runVVV_Prometheus_3.2_Tiger/results/variants/gVCF/"

for gvcf in "${previous_gvcf_dir}/"*g.vcf*; do
	ln -s "${gvcf}" "${gvcf_dir}"
done

for gvcf in "${prometheus_gvcf_folder}/"*g.vcf*; do
	ln -s "${gvcf}" "${gvcf_dir}"
done


# Setup other parameters.
module load NGS_DNA/3.5.5
batching="_chr"
ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)')


bash "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
	-p "parameters_converted.csv" \
	-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" \
	-p "${projectJobsDir}/${filePrefix}.csv" \
	-p "parameters_environment_converted.csv" \
	-p "parameters_group_converted.csv" \
	-p "parameters_tmpdir_converted.csv" \
	-rundir "${projectJobsDir}" \
	--header "${EBROOTNGS_DNA}/templates/slurm/header.ftl" \
	--footer "${EBROOTNGS_DNA}/templates/slurm/footer.ftl" \
	--submit "${EBROOTNGS_DNA}/templates/slurm/submit.ftl" \
	-w "${EBROOTNGS_DNA}/workflow_cv.csv" \
	-b slurm \
	-g \
	-weave \
	-runid "${runID}" \
	-o "ngsversion=${ngsversion};groupname=${group}"

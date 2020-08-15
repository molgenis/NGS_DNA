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
		    -n   NGS_DNA software dir (default=/apps/software/NGS_DNA/3.5.5/)

		===============================================================================================================
	EOH
	trap - EXIT
	exit 0
}


while getopts "t:g:w:f:r:c:v:p:n:h" opt;
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
		n) ngs_dna_dir="${OPTARG}";;
	esac
done

# Check if NGS_DNA is loaded.
if ! module list | grep -oP "NGS_DNA.+"; then
	echo "No NGS_DNA module loaded. Exiting."
	exit 1
fi


# Load python3 and add custom packages.
# TODO: Need to do something about both Python3 and custom pacakges. Currently that's only PyYaml.
# NOTE: Pysam is loaded here because the default Python module doesn't set the variable PYTHONPATH
# for some reason. Could do a work around with an if [[ -z ]], but that feels messy.
module load Pysam
for x in $(ls -d /groups/umcg-atd/tmp03/umcg-tmedina/repos/PyPackages/*); do
	new_PYTHONPATH="${PYTHONPATH}:${x}"
done


# Assign command line variables or defaults.
if [[ -z "${tmpDirectory:-}" ]]; then tmpDirectory="$(basename "$(cd ../../ && pwd)")"; fi; echo "tmpDirectory=${tmpDirectory}"
if [[ -z "${group:-}" ]]; then group="$(basename "$(cd ../../../ && pwd)")"; fi; echo "group=${group}"
if [[ -z "${workDir:-}" ]]; then workDir="/groups/${group}/${tmpDirectory}"; fi; echo "workDir=${workDir}"
if [[ -z "${filePrefix:-}" ]]; then filePrefix="$(basename "$(pwd)")"; fi; echo "filePrefix=${filePrefix}"
if [[ -z "${runID:-}" ]]; then runID="runCV"; fi; echo "runID=${runID}"
if [[ -z "${prevrunID:-}" ]]; then prevrunID="run01"; fi; echo "prevrunID=${prevrunID}"
if [[ -z "${ngs_dna_dir:-}" ]]; then ngs_dna_dir="${EBROOTNGS_DNA}"; fi; echo "ngs_dna_dir=${ngs_dna_dir}"


# Setup directory variables.
genScripts="${workDir}/generatedscripts/${filePrefix}/"
projectJobsDir="${workDir}/projects/${filePrefix}/${runID}/jobs/"
projectResultsDir="${workDir}/projects/${filePrefix}/${runID}/results/"
prev_ResultsDir="${projectResultsDir/$runID/$prevrunID}"
intermediateDir="${workDir}/tmp/${filePrefix}/${runID}/"


# Make project subdirectories.
echo "Making project run directories."
mkdir -p "${projectJobsDir}"
mkdir -p "${projectResultsDir}"
mkdir -p "${intermediateDir}"
mkdir -p "${projectResultsDir}/variants/cnv/"
mkdir -p "${projectResultsDir}/variants/gVCF/"
mkdir -p "${projectResultsDir}/variants/GAVIN/"
mkdir -p "${projectResultsDir}/general"
mkdir -p "${intermediateDir}/GeneNetwork/"


# Create a new sample sheet with the hybrid sample added.
echo "Adding hybrid sample to samplesheet."
hybrid_yaml="${ngs_dna_dir}/resources/hybrid_sample_info.yaml"
altmap_yaml="${ngs_dna_dir}/resources/alt_ss_field_mappings.yaml"
samplesheet="${genScripts}/${filePrefix}.csv"
samplesheet_cv="${genScripts}/${filePrefix}_CV.csv"

PYTHONPATH=${new_PYTHONPATH}; python "${ngs_dna_dir}/scripts/add_hybrid.py" "${hybrid_yaml}" "${samplesheet}" "${altmap_yaml}" "${samplesheet_cv}"
cp "${samplesheet_cv}" "${projectJobsDir}/${filePrefix}.csv"


# Make symbolic links.
echo "Making symbolic links."
ln -s "${prev_ResultsDir}/qc/" "${projectResultsDir}/"
gvcf_dir="${projectResultsDir}/variants/gVCF/"
# TODO: This needs to be updated to point to somewhere more permanent.
hybrid_gvcf_folder="/groups/umcg-atd/tmp03/projects/ContinuousValidation/runVVV_Prometheus_3.2_Tiger/results/variants/gVCF/"

for gvcf in "${prev_ResultsDir}/variants/gVCF/"*.g.vcf*; do
	ln -s "${gvcf}" "${gvcf_dir}"
done

for gvcf in "${hybrid_gvcf_folder}/"*g.vcf*; do
	ln -s "${gvcf}" "${gvcf_dir}"
done


# Setup other parameters.
batching="_chr"
ngsversion=$(module list | grep -o -P 'NGS_DNA(.+)')
sampleSize=$(( $(wc -l < externalSampleIDs.txt) + 1 ))


# Load Molgenis Computer.
# This can probably be removed if a normal NGS_DNA module is used that preloads it.
echo "Loading Compute."
ml Molgenis-Compute/v19.01.1-Java-11.0.2


# Run Molgenis Compute.
echo "Running Compute."
sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
	-p "parameters_converted.csv" \
	-p "${ngs_dna_dir}/batchIDList${batching}.csv" \
	-p "${projectJobsDir}/${filePrefix}.csv" \
	-p "parameters_environment_converted.csv" \
	-p "parameters_group_converted.csv" \
	-p "parameters_tmpdir_converted.csv" \
	-rundir "${projectJobsDir}" \
	--header "${ngs_dna_dir}/templates/slurm/header.ftl" \
	--footer "${ngs_dna_dir}/templates/slurm/footer.ftl" \
	--submit "${ngs_dna_dir}/templates/slurm/submit.ftl" \
	-w "${ngs_dna_dir}/workflow_cv.csv" \
	-b slurm \
	-g \
	-weave \
	-runid "${runID}" \
	-o "groupname="${group}";sampleSize="${sampleSize}";ngsversion="${ngsversion}""

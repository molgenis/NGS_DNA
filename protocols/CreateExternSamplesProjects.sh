set -o pipefail
#string tmpName
#list seqType
#string projectRawArrayTmpDataDir
#string projectRawTmpDataDir
#string projectJobsDir
#string projectLogsDir
#string intermediateDir
#string projectResultsDir
#string projectQcDir
#string tmpdir_parameters
#string computeVersion

#list sequencingStartDate
#list sequencer
#list run
#list flowcell
#list externalFastQ_1
#list externalFastQ_2
#string groupDir
#string environment_parameters
#string groupname

#string mainParameters
#string worksheet
#string outputdir
#string workflowpath

#list externalSampleID
#string project
#string logsDir
#string ngsversion
#list barcode
#list lane
#string ngsUtilsVersion

#string dataDir
#string coveragePerBaseDir
#string coveragePerTargetDir

set -e 
set -u

umask 0007
module load "${ngsUtilsVersion}"
module load "${ngsversion}"

module list
#
# Create project dirs.
#
mkdir -p "${projectRawArrayTmpDataDir}"
mkdir -p "${projectRawTmpDataDir}"
mkdir -p "${projectJobsDir}"
mkdir -p "${projectLogsDir}"
mkdir -p "${intermediateDir}"
mkdir -p "${projectResultsDir}/"{alignment,general}
mkdir -p "${projectResultsDir}/coverage/CoveragePer"{Base,Target}"/"{male,female}
mkdir -p "${projectResultsDir}/qc/statistics/"
mkdir -p "${projectResultsDir}/variants/"{cnv,gVCF,GAVIN}/
mkdir -p "${projectQcDir}"
#shellcheck disable=SC2174
mkdir -p -m 2770 "${logsDir}/${project}/"

rocketPoint=$(pwd)

cd "${projectRawTmpDataDir}"

#
# Create symlinks to the raw data required to analyse this project
#
# For each sequence file (could be multiple per sample):
#

max_index=${#externalSampleID[@]}-1
for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do
	if [[ "${seqType[samplenumber]}" == "SR" ]]
	then
		if [[ "${barcode[samplenumber]}" == "None" ]]
		then
			ln -sf "${externalFastQ_1[samplenumber]}" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz"
			ln -sf "${externalFastQ_1[samplenumber]}.md5" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5"
		else
			ln -sf "${externalFastQ_1[samplenumber]}" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz"
			ln -sf "${externalFastQ_1[samplenumber]}.md5" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5"
		fi
	elif [[ "${seqType[samplenumber]}" == "PE" ]]
	then
		if [[ "${barcode[samplenumber]}" == "None" ]]
		then
			ln -sf "${externalFastQ_1[samplenumber]}" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz"
			ln -sf "${externalFastQ_2[samplenumber]}" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz"
			ln -sf "${externalFastQ_1[samplenumber]}.md5" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5"
			ln -sf "${externalFastQ_2[samplenumber]}.md5" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5"
		else
			ln -sf "${externalFastQ_1[samplenumber]}" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz"
			ln -sf "${externalFastQ_2[samplenumber]}" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz"
			ln -sf "${externalFastQ_1[samplenumber]}.md5" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5"
			ln -sf "${externalFastQ_2[samplenumber]}.md5" "${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5"
		fi
	fi
done

cd "${rocketPoint}"

echo "before splitting"
pwd

#
# Create subset of samples for this project.
#

cp "${worksheet}" "${projectJobsDir}/${project}.csv"
sampleSheetCsv="${projectJobsDir}/${project}.csv"

#
# Execute MOLGENIS/compute to create job scripts to analyse this project.
#

batching="_small"

capturingKitProject=$(python "${EBROOTNGS_DNA}/scripts/getCapturingKit.py" "${sampleSheetCsv}" | sed 's|\\||' )


if [[ ! -d "${dataDir}/${capturingKitProject}" ]]
then
	echo "Bedfile does not exist! Exiting"
	exit 1
fi
if [[ "${capturingKitProject,,}" == *"exoom"* || "${capturingKitProject,,}" == *"exome"* || "${capturingKitProject,,}" == *"all_exon_v1"* ]]
then
	batching="_chr"
	resourcesParameters="${EBROOTNGS_DNA}/parameters_resources_exome.csv"
elif [[ "${capturingKitProject,,}" == *"wgs"* ]]
then
	batching="_chr"
	resourcesParameters="${EBROOTNGS_DNA}/parameters_resources_wgs.csv"
else
	resourcesParameters="${EBROOTNGS_DNA}/parameters_resources_exome.csv"
fi

if [[ -f ".compute.properties" ]]
then
	rm "../.compute.properties"
fi

module load "${computeVersion}"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${resourcesParameters}" > "resources_parameters.converted.csv"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" -p "${mainParameters}" \
-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" \
-p "${sampleSheetCsv}" \
-p "${environment_parameters}" \
-p "resources_parameters.converted.csv" \
-p "${tmpdir_parameters}" \
-rundir "${projectJobsDir}" \
-w "${workflowpath}" \
--header "${EBROOTNGS_DNA}/templates/slurm/header_tnt.ftl" \
--footer "${EBROOTNGS_DNA}/templates/slurm/footer_tnt.ftl" \
--submit "${EBROOTNGS_DNA}/templates/slurm/submit.ftl" \
-b slurm \
-g -weave \
-runid "${runid}" \
-o "ngsversion=${ngsversion};\
batchIDList=${EBROOTNGS_DNA}/batchIDList${batching}.csv;\
groupDir=${groupDir};\
groupname=${groupname}"

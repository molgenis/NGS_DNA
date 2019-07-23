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
#string group_parameters
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
mkdir -p "${projectResultsDir}/alignment/"
mkdir -p "${projectResultsDir}/qc/statistics/"
mkdir -p "${projectResultsDir}/variants/cnv/"
mkdir -p "${projectResultsDir}/variants/gVCF/"
mkdir -p "${projectResultsDir}/variants/GAVIN/"
mkdir -p "${projectResultsDir}/general"
mkdir -p "${projectQcDir}"
mkdir -p "${intermediateDir}/GeneNetwork/"
mkdir -p -m 2770 "${logsDir}/${project}/"

rocketPoint=$(pwd)

cd "${projectRawTmpDataDir}"

#
# Create symlinks to the raw data required to analyse this project
#
# For each sequence file (could be multiple per sample):
#


n_elements=${externalSampleID[@]}
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
echo $(pwd)

#
# Create subset of samples for this project.
#

extract_samples_from_GAF_list.pl --i "${worksheet}" --o "${projectJobsDir}/${project}.csv" --c project --q "${project}"

#
# Execute MOLGENIS/compute to create job scripts to analyse this project.
#

batching="_small"

capturingKitProject=$(python "${EBROOTNGS_DNA}/scripts/getCapturingKit.py" "${projectJobsDir}/${project}.csv" | sed 's|\\||' )
captKit=$(echo "capturingKitProject" | awk 'BEGIN {FS="/"}{print $2}')

if [ ! -d "${dataDir}/${capturingKitProject}" ]
then
	echo "Bedfile does not exist! Exiting"
        exit 1
fi
if [[ "${capturingKitProject,,}" == *"exoom"* || "${capturingKitProject,,}" == *"exome"* || "${capturingKitProject,,}" == *"all_exon_v1"* || "${capturingKitProject,,}" == *"wgs"* ]]
then
	resourcesParameters="${EBROOTNGS_DNA}/parameters_resources_exome.csv"
	batching="_chr"
        if [ ! -e "${coveragePerTargetDir}/${captKit}/${captKit}" ]
        then
		echo "Bedfile in ${coveragePerTargetDir} does not exist! Exiting"
                exit 1
        fi
else
	resourcesParameters="${EBROOTNGS_DNA}/parameters_resources_exome.csv"
	if [ ! -e "${coveragePerBaseDir}/${captKit}/${captKit}" ]
        then
		echo "Bedfile in ${coveragePerBaseDir} does not exist! Exiting"
                exit 1
        fi
fi

if [ -f ".compute.properties" ];
then
     rm "../.compute.properties"
fi

module load "${computeVersion}"
perl "${EBROOTNGS_DNA}/scripts/convertParametersGitToMolgenis.pl" "${resourcesParameters}" > "resources_parameters.converted.csv"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" -p "${mainParameters}" \
-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" \
-p "${projectJobsDir}/${project}.csv" \
-p "${environment_parameters}" \
-p "${group_parameters}" \
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
groupname=${groupname}"

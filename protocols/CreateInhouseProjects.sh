#MOLGENIS walltime=02:00:00 mem=4gb

#string tmpName
#list seqType
#string project
#string projectRawArrayTmpDataDir
#string projectRawTmpDataDir
#string projectJobsDir
#string projectLogsDir
#string intermediateDir
#string projectResultsDir
#string projectQcDir
#string computeVersion
#string group_parameters
#string groupname

#list sequencingStartDate
#list sequencer
#list run
#list flowcell
#list barcode
#list lane
#list externalSampleID

#string mainParameters
#string worksheet
#string outputdir
#string workflowpath
#string tmpdir_parameters
#string environment_parameters
#string ngsversion
#string ngsUtilsVersion

#string dataDir

#string coveragePerBaseDir
#string coveragePerTargetDir

#string project
#string logsDir 

umask 0007
module load "${ngsUtilsVersion}"
module load "${ngsversion}"

#
# Create project dirs.
#
mkdir -p "${projectRawArrayTmpDataDir}"
mkdir -p "${projectRawTmpDataDir}"
mkdir -p "${projectJobsDir}"
mkdir -p "${projectLogsDir}"
mkdir -p "${intermediateDir}"
mkdir -p "${projectResultsDir}"
mkdir -p "${projectQcDir}"
mkdir -p "${intermediateDir}/GeneNetwork/"
mkdir -p -m 2770 "${logsDir}/${project}/"
#
# Create symlinks to the raw data required to analyse this project.
# Do this for each sequence file and it's accompanying MD5 checksum.
# (There may be multiple sequence files per sample)
#
rocketPoint=$(pwd)
cd "${projectRawTmpDataDir}"
max_index=${#externalSampleID[@]}-1

for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do
	if [[ "${seqType[samplenumber]}" == 'SR' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}.fq.gz" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}.fq.gz.md5" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5"
		else
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5"
		fi
	elif [[ "${seqType[samplenumber]}" == 'PE' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_1.fq.gz" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_2.fq.gz" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_1.fq.gz.md5" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_2.fq.gz.md5" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5"
		else
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5"
			ln -sf "../../../../../rawdata/ngs/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5" \
					"${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5"
		fi
	fi
done

#
# Create subset of samples for this project.
#
extract_samples_from_GAF_list.pl --i "${worksheet}" --o "${projectJobsDir}/${project}.csv" --c project --q "${project}"
perl -pi -e 's/\r(?!\n)//g' "${projectJobsDir}/${project}.csv"

#
# Execute MOLGENIS/compute to create job scripts to analyse this project.
#
cd "${rocketPoint}"

if [[ -f .compute.properties ]]
then
	rm .compute.properties
fi

batching="_small"

capturingKitProject=$(python ${EBROOTNGS_DNA}/scripts/getCapturingKit.py "${projectJobsDir}/${project}.csv" | sed 's|\\||')
captKit=$(echo "capturingKitProject" | awk 'BEGIN {FS="/"}{print $2}')

if [ ! -d "${dataDir}/${capturingKitProject}" ]
then
	echo "Bedfile does not exist! Exiting"
	exit 1
fi

if [[ "${capturingKitProject}" == *"Exoom"* || "${capturingKitProject}" == *"All_Exon_v1"* || "${capturingKitProject}" == *"wgs"* || "${capturingKitProject}" == *"WGS"* ]]
then
	batching="_chr"
	if [ ! -r "${coveragePerTargetDir}/${captKit}/${captKit}" ]
	then
		echo "Bedfile in ${coveragePerTargetDir} does not exist! Exiting"
		exit 1
	fi
else
	if [ ! -r "${coveragePerBaseDir}/${captKit}/${captKit}" ]
        then
                echo "Bedfile in ${coveragePerBaseDir} does not exist! Exiting"
                exit 1
        fi
fi


echo "BATCHIDLIST=${EBROOTNGS_DNA}/batchIDList${batching}.csv"

sh "${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh" \
-p "${mainParameters}" \
-p "${EBROOTNGS_DNA}/batchIDList${batching}.csv" \
-p "${projectJobsDir}/${project}.csv" \
-p "${environment_parameters}" \
-p "${group_parameters}" \
-p "${tmpdir_parameters}" \
-rundir "${projectJobsDir}" \
--header "${EBROOTNGS_DNA}/templates/slurm/header.ftl" \
--footer "${EBROOTNGS_DNA}/templates/slurm/footer.ftl" \
--submit "${EBROOTNGS_DNA}/templates/slurm/submit.ftl" \
-w "${workflowpath}" \
-b slurm \
-g \
-weave \
-runid "${runid}" \
-o "ngsversion=${ngsversion};\
batchIDList=${EBROOTNGS_DNA}/batchIDList${batching}.csv;\
groupname=${groupname}"

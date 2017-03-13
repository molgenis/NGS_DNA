#MOLGENIS walltime=02:00:00 mem=4gb
#string tmpName
#list seqType
#string projectRawArrayTmpDataDir
#string projectRawTmpDataDir
#string projectJobsDir
#string projectLogsDir
#string intermediateDir
#string projectResultsDir
#string batchIDList
#string projectQcDir
#string tmpdir_parameters

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

umask 0007
module load ${ngsUtilsVersion}
module load $ngsversion

module list
#
# Create project dirs.
#
mkdir -p ${projectRawArrayTmpDataDir}
mkdir -p ${projectRawTmpDataDir}
mkdir -p ${projectJobsDir}
mkdir -p ${projectLogsDir}
mkdir -p ${intermediateDir}
mkdir -p ${projectResultsDir}
mkdir -p ${projectQcDir}

ROCKETPOINT=$(pwd)

cd ${projectRawTmpDataDir}

#
# Create symlinks to the raw data required to analyse this project
#
# For each sequence file (could be multiple per sample):
#


n_elements=${externalSampleID[@]}
max_index=${#externalSampleID[@]}-1
for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do
	if [[ ${seqType[samplenumber]} == "SR" ]]
	then
  		if [[ ${barcode[samplenumber]} == "None" ]]
		then
			ln -sf ${externalFastQ_1[samplenumber]} ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz
			ln -sf ${externalFastQ_1[samplenumber]}.md5 ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5
  		else
      			ln -sf ${externalFastQ_1[samplenumber]} ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz
      			ln -sf ${externalFastQ_1[samplenumber]}.md5 ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5
		fi
	elif [[ ${seqType[samplenumber]} == "PE" ]]
	then
		if [[ ${barcode[samplenumber]} == "None" ]]
    		then
    			ln -sf ${externalFastQ_1[samplenumber]} ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz
			ln -sf ${externalFastQ_2[samplenumber]} ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz
			ln -sf ${externalFastQ_1[samplenumber]}.md5 ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5
        		ln -sf ${externalFastQ_2[samplenumber]}.md5 ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5
		else          
        		ln -sf ${externalFastQ_1[samplenumber]} ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz
        		ln -sf ${externalFastQ_2[samplenumber]} ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz
        		ln -sf ${externalFastQ_1[samplenumber]}.md5 ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5
        		ln -sf ${externalFastQ_2[samplenumber]}.md5 ${projectRawTmpDataDir}/${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5
    		fi
 	fi
done

cd $ROCKETPOINT

echo "before splitting"
echo $(pwd)

#
# TODO: array for each sample:
#

#
# Create subset of samples for this project.
#

extract_samples_from_GAF_list.pl --i ${worksheet} --o ${projectJobsDir}/${project}.csv --c project --q ${project}

#
# Execute MOLGENIS/compute to create job scripts to analyse this project.
#


if [ -f .compute.properties ];
then
     rm ../.compute.properties
fi

sh ${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh -p ${mainParameters} \
-p ${batchIDList} \
-p ${projectJobsDir}/${project}.csv \
-p ${environment_parameters} \
-p ${group_parameters} \
-p ${tmpdir_parameters} \
-rundir ${projectJobsDir} \
-w ${workflowpath} \
--header ${EBROOTNGS_DNA}/templates/slurm/header.ftl \
--footer ${EBROOTNGS_DNA}/templates/slurm/footer.ftl \
--submit ${EBROOTNGS_DNA}/templates/slurm/submit.ftl \
-b slurm \
-g -weave \
-runid ${runid} \
-o "ngsversion=${ngsversion};\
groupname=${groupname}"

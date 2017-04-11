#MOLGENIS walltime=02:00:00 mem=4gb
#string tmpName
#list seqType
#string project
#string projectJobsDir
#string projectLogsDir
#string intermediateDir
#string projectResultsDir
#string batchIDList
#string projectQcDir
#string computeVersion
#string group_parameters
#string previousRun
#string groupname
#string permanentDataDir

#list sequencingStartDate
#list sequencer
#list run
#list flowcell
#list barcode
#list lane
#list internalSampleID

#string mainParameters
#string worksheet 
#string outputdir
#string workflowpath
#string tmpdir_parameters
#string environment_parameters
#string ngsversion
#string ngsUtilsVersion

#string project
#string logsDir 

umask 0007

module list
module load Molgenis-Compute/${computeVersion}
module load $ngsversion
#
# Create project dirs.
#
mkdir -p ${projectJobsDir}
mkdir -p ${projectLogsDir}
mkdir -p ${intermediateDir}
mkdir -p ${projectResultsDir}
mkdir -p ${projectQcDir}

ROCKETPOINT=`pwd`

#
##
### Copying prm results data from the run that needs to be reanalyzed
##
#
permanentDataDirGD="/groups/umcg-gd/prm02/projects/"
for i in $(ls ${permanentDataDirGD}/5GPM_WGS/run01/results/alignment/gVCF/*.g.vcf.gz)
do

	printf "Copying $i to ${intermediateDir}/gVCF/ .."
	rsync -a ${i} ${intermediateDir}/gVCF/ 
	rsync -a ${i}.tbi ${intermediateDir}/gVCF/ 
	printf ".. done \n"
done

printf "Copying ${permanentDataDirGD}/${project}/${previousRun}/results/alignment/* to ${intermediateDir} .."
rsync -a ${permanentDataDirGD}/${project}/${previousRun}/results/alignment/* ${intermediateDir}

printf ".. finished\nCopying ${permanentDataDirGD}/${project}/${previousRun}/results/general/*chosenSex.txt to ${intermediateDir} .."
rsync -a ${permanentDataDirGD}/${project}/${previousRun}/results/general/*chosenSex.txt ${intermediateDir}

cd $ROCKETPOINT

echo "before splitting"
echo `pwd`
module load ${ngsUtilsVersion}
module load ${ngsversion}
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

echo "before run second rocket"
echo pwd

sh ${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh -p ${mainParameters} \
-p ${batchIDList} -p ${projectJobsDir}/${project}.csv -p ${environment_parameters} -p ${group_parameters} -p ${tmpdir_parameters} -rundir ${projectJobsDir} \
--header ${EBROOTNGS_DNA}/templates/slurm/header.ftl \
--footer ${EBROOTNGS_DNA}/templates/slurm/footer.ftl \
--submit ${EBROOTNGS_DNA}/templates/slurm/submit.ftl \
-w ${workflowpath} \
-b slurm \
-g -weave \
-runid ${runid} \
-o "ngsversion=${ngsversion};\
groupname=${groupname};\previousRun=${previousRun};\"


perl -pi -e 's|#SBATCH --mem 4gb|#SBATCH --mem 4gb\n#SBATCH --qos=ds|' ${projectJobsDir}/*CopyGvcfToPrm_0.sh

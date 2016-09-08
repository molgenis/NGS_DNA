#MOLGENIS walltime=05:59:00 nodes=1 cores=1 mem=4gb

#Parameter mapping
#string tmpName
#string project
#string projectResultsDir
#string logsDir 
#string groupname
#string projectPrefix
#string intermediateDir
#string projectJobsDir
#string previousRun
#list externalSampleID
#string automateVersion
# Change permissions

umask 0007

module load ${automateVersion}

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

# Make result directories
mkdir -p ${projectResultsDir}/alignment/gVCF
mkdir -p ${projectResultsDir}/qc/statistics/
mkdir -p ${projectResultsDir}/variants/cnv/
mkdir -p ${projectResultsDir}/general

UNIQUESAMPLES=()
for samples in "${externalSampleID[@]}"
do
  	array_contains UNIQUESAMPLES "$samples" || UNIQUESAMPLES+=("$samples")    # If bamFile does not exist in array add it
done

EXTERN=${#UNIQUESAMPLES[@]}

# Copy project csv file to project results directory
printf "Copied project csv file to project results directory.."
rsync -a ${projectJobsDir}/${project}.csv ${projectResultsDir}
printf ".. finished (1/3)\n"

count=1
echo "The bams used for this project can be found in the previous run:${previousRun}" > ${projectResultsDir}/alignment/README

echo "the gVCF for this project can be found in /groups/umcg-gd/prm02/projects/5GPM_WGS/run01/results/aligment/gVCF" > ${projectResultsDir}/alignment/gVCF/README

echo "the cnv calling was already done in the previous run: ${previousRun}" > ${projectResultsDir}/variants/cnv/README

echo "the metrics can be found in the previous run: ${previousRun}" > ${projectResultsDir}/qc/statistics/README

printf "Copying variants vcf and tables to results directory "
# Copy variants vcf and tables to results directory
rsync -a ${projectPrefix}.final.vcf ${projectResultsDir}/variants/
printf "."
rsync -a ${projectPrefix}.final.vcf.table ${projectResultsDir}/variants/
printf "."
printf " finished (2/3)\n"


#copy vcf file + coveragePerBase.txt + gender determination
printf "Copying vcf files, gender determination, coverage per base and per target files "
for sa in "${UNIQUESAMPLES[@]}"
do
	rsync -a ${intermediateDir}/${sa}.final.vcf ${projectResultsDir}/variants/
	printf "."
	rsync -a ${intermediateDir}/${sa}.final.vcf.table ${projectResultsDir}/variants/
	printf "."

	rsync -a ${intermediateDir}/${sa}.chosenSex.txt ${projectResultsDir}/general/
	printf "."
	
done
printf " finished (3/3)\n"


if [ ! -d ${logsDir}/${project}/ ]
then
	mkdir -p ${logsDir}/${project}/
fi

touch pipeline.finished

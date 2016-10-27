#MOLGENIS walltime=05:59:00 nodes=1 cores=1 mem=4gb

#Parameter mapping
#string tmpName
#string project
#string projectResultsDir
#string logsDir 
#string groupname
#string projectPrefix
#string intermediateDir
#string projectQcDir
#string projectLogsDir
#string projectRawTmpDataDir
#string projectQcDir
#string projectJobsDir
#list externalSampleID
#list batchID
#list seqType
#string gavinOutputFirstPass
#string gavinOutputFinal
# Change permissions


umask 0007

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
mkdir -p ${projectResultsDir}/coverage/CoveragePerBase
mkdir -p ${projectResultsDir}/coverage/CoveragePerTarget
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
printf ".. finished (2/11)\n"

# Copy fastQC output to results directory
printf "Copying fastQC output to results directory.."
rsync -a ${intermediateDir}/*_fastqc.zip ${projectResultsDir}/qc/
printf ".. finished (3/11)\n"

##Copy GAVIN results
if [ -f ${gavinOutputFirstPass} ]
then
	rsync -a ${gavinOutputFirstPass} ${projectResultsDir}/variants/GAVIN/
fi

if [ -f ${gavinOutputFinal} ]
then
	rsync -a ${gavinOutputFinal} ${projectResultsDir}/variants/GAVIN/
fi

count=1
#copy realigned bams
printf "Copying ${EXTERN} realigned bams "
for sample in "${UNIQUESAMPLES[@]}"
do
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam ${projectResultsDir}/alignment/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.bai ${projectResultsDir}/alignment/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.md5 ${projectResultsDir}/alignment/
	if [ -f ${intermediateDir}/${sample}.merged.dedup.bam.cram ] 
	then
		rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.cram ${projectResultsDir}/alignment/
		rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.cram.md5 ${projectResultsDir}/alignment/
	fi

	printf "."
done
printf " finished (4/11)\n"

#Copy g.vcf.gz + g.vcf.gz.tbi
printf "Copying gVCF files + index file"
for sample in "${UNIQUESAMPLES[@]}"
do
        rsync -a ${intermediateDir}/gVCF/${sample}.*.g.vcf.gz ${projectResultsDir}/alignment/gVCF/
        rsync -a ${intermediateDir}/gVCF/${sample}.*.g.vcf.gz.tbi ${projectResultsDir}/alignment/gVCF/

        printf "."
done
printf " finished (5/11)\n"

# Copy alignment stats (lane and sample) to results directory

count=1
printf "Copying alignment stats (lane and sample) to results directory "
for sample in "${UNIQUESAMPLES[@]}"
do
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.alignment_summary_metrics ${projectResultsDir}/qc/statistics/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.gc_bias_metrics ${projectResultsDir}/qc/statistics/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.quality_by_cycle_metrics ${projectResultsDir}/qc/statistics/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.quality_distribution_metrics ${projectResultsDir}/qc/statistics/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.hs_metrics ${projectResultsDir}/qc/statistics/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.bam_index_stats ${projectResultsDir}/qc/statistics/
	rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.flagstat ${projectResultsDir}/qc/statistics/
	rsync -a ${intermediateDir}/${sample}*.pdf ${projectResultsDir}/qc/statistics/
	if [ -f "${intermediateDir}/${sample}.merged.dedup.bam.insert_size_metrics" ]
	then
		rsync -a ${intermediateDir}/${sample}.merged.dedup.bam.insert_size_metrics ${projectResultsDir}/qc/statistics/
	else
		echo "no insertsize metrics are available, skipped"
	fi
	printf "."
done
	printf " finished (6/11)\n"

printf "Copying variants vcf and tables to results directory "
# Copy variants vcf and tables to results directory
rsync -a ${projectPrefix}.final.vcf.table ${projectResultsDir}/variants/
printf "."
rsync -a ${projectPrefix}.final.vcf.gz ${projectResultsDir}/variants/
printf "."
rsync -a ${projectPrefix}.final.vcf.gz.tbi ${projectResultsDir}/variants/
printf "."



for sa in "${UNIQUESAMPLES[@]}"
do
	if [ -f ${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz ]
	then
		rsync -a ${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz ${projectResultsDir}/variants/cnv/
		rsync -a ${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz ${projectResultsDir}/variants/cnv/
		rsync -a ${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz ${projectResultsDir}/variants/cnv/
		rsync -a ${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz.tbi ${projectResultsDir}/variants/cnv/
		rsync -a ${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz.tbi ${projectResultsDir}/variants/cnv/
		rsync -a ${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz.tbi ${projectResultsDir}/variants/cnv/
		printf "."
	fi
done
printf " finished (7/11)\n"

#copy vcf file + coveragePerBase.txt + gender determination
printf "Copying vcf files, gender determination, coverage per base and per target files "
for sa in "${UNIQUESAMPLES[@]}"
do
	rsync -a ${intermediateDir}/${sa}.final.vcf.table ${projectResultsDir}/variants/
	printf "."

	rsync -a ${intermediateDir}/${sa}.final.vcf.gz ${projectResultsDir}/variants/
	printf "."
	rsync -a ${intermediateDir}/${sa}.final.vcf.gz.tbi ${projectResultsDir}/variants/
	printf "."


	rsync -a ${intermediateDir}/${sa}.chosenSex.txt ${projectResultsDir}/general/
	printf "."

	if ls ${intermediateDir}/${sa}.*.coveragePerBase.txt 1> /dev/null 2>&1
	then
		for i in $(ls ${intermediateDir}/${sa}.*.coveragePerBase.txt )
		do
			rsync -a $i ${projectResultsDir}/coverage/CoveragePerBase/
			printf "."
		done
	
	else
		echo "coveragePerBase skipped for sample: ${sa}"
	fi
	
	if ls ${intermediateDir}/${sa}.*.coveragePerTarget.txt 1> /dev/null 2>&1
        then
		for i in $(ls ${intermediateDir}/${sa}.*.coveragePerTarget.txt )
		do
			rsync -a $i ${projectResultsDir}/coverage/CoveragePerTarget/
			printf "."
		done	
	else
		 echo "coveragePerTarget skipped for sample: ${sa}"
	fi
	
done
printf " finished (8/11)\n"


# print README.txt files
printf "Copying QC report to results directory "

# Copy QC report to results directory
rsync -a ${projectQcDir}/${project}_QCReport.pdf ${projectResultsDir}
printf "."
rsync -a ${projectQcDir}/${project}_QCReport.html ${projectResultsDir}
printf "."
rsync -ra ${projectQcDir}/images ${projectResultsDir}
printf " finished (9/11)\n"

echo "Creating zip file"
# Create zip file for all "small text" files
CURRENT_DIR=`pwd`
cd ${projectResultsDir}

zip -gr ${projectResultsDir}/${project}.zip variants
zip -gr ${projectResultsDir}/${project}.zip qc
zip -gr ${projectResultsDir}/${project}.zip images
zip -g ${projectResultsDir}/${project}.zip ${project}.csv
#zip -g ${projectResultsDir}/${project}.zip README.pdf
zip -g ${projectResultsDir}/${project}.zip ${project}_QCReport.pdf
zip -gr ${projectResultsDir}/${project}.zip coverage

echo "Zip file created: ${projectResultsDir}/${project}.zip (10/11)"

# Create md5sum for zip file

md5sum ${project}.zip > ${projectResultsDir}/${project}.zip.md5
echo "Made md5 file for ${projectResultsDir}/${project}.zip (11/11)"
# add u+rwx,g+r+w rights for GAF group

chmod -R u+rwX,g+rwX ${projectResultsDir}

cd ${CURRENT_DIR}

echo "pipeline is finished"
touch ${logsDir}/${project}.pipeline.finished
echo "${logsDir}/${project}.pipeline.finished is created"

if [ ! -d ${logsDir}/${project}/ ]
then
	mkdir -p ${logsDir}/${project}/
fi

touch pipeline.finished

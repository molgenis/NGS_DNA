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
#string capturingKit
#list externalSampleID
#list batchID
#list seqType
#string intervalListDir
#string coveragePerBaseDir
#string coveragePerTargetDir
#string tmpDataDir
# Change permissions


umask 0007

#Function to check if array contains value
array_contains () {
	local array="$1[@]"
	local seeking="${2}"
	local in=1
	for element in "${!array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
			in=0
			break
		fi
	done
	return "${in}"
}

# Make result directories
mkdir -p "${projectResultsDir}/coverage/CoveragePerBase"
mkdir -p "${projectResultsDir}/coverage/CoveragePerTarget"
mkdir -p "${projectResultsDir}/bedfile/"

UNIQUESAMPLES=()
for samples in "${externalSampleID[@]}"
do
	array_contains UNIQUESAMPLES "${samples}" || UNIQUESAMPLES+=("${samples}")    # If bamFile does not exist in array add it
done

# Copy project csv file and capturingKitFolder to project results directory
printf "Copied project csv file to project results directory.."
rsync -a "${projectJobsDir}/${project}.csv" "${projectResultsDir}"
rsync -a "${intervalListDir}" "${projectResultsDir}/bedfile/"

bedfileName=$(basename "${capturingKit}")
ls -1 "${coveragePerBaseDir}/${bedfileName}/" > "${projectResultsDir}/coverage/CoveragePerBase/CovPerBase.txt"
ls -1 "${coveragePerTargetDir}/${bedfileName}/" > "${projectResultsDir}/coverage/CoveragePerTarget/CovPerTarget.txt"

printf ".. finished \n"

##Copy GAVIN results
for sample in "${UNIQUESAMPLES[@]}"
do
	if [ -f "${intermediateDir}/${sample}.GAVIN.rlv.vcf" ]
	then
		rsync -a "${intermediateDir}/${sample}.GAVIN.rlv.vcf.gz" "${projectResultsDir}/variants/GAVIN/"
	fi
done

printf "Copying variants vcf to results directory "
# Copy variants vcf and tables to results directory
rsync -a "${projectPrefix}.final.vcf.gz" "${projectResultsDir}/variants/"
printf '.'
rsync -a "${projectPrefix}.final.vcf.gz.tbi" "${projectResultsDir}/variants/"
printf '.'


echo "copy cnv results of Convading and XHMM and Manta"

for sa in "${UNIQUESAMPLES[@]}"
do
	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_candidateSV.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSV.vcf.gz.tbi"
		printf '.'
	fi

	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_candidateSmallIndels.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSmallIndels.vcf.gz.tbi"
		printf '.'
	fi

	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_diploidSV.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_diploidSV.vcf.gz.tbi"
		printf '.'
	fi


	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz" "${projectResultsDir}/variants/cnv//${sa}_candidateSV_VEP.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSV_VEP.vcf.gz.tbi"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP_summary.html" "${projectResultsDir}/variants/cnv/${sa}_candidateSV_VEP_summary.html"
		printf '.'
	fi


	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz" "${projectResultsDir}/variants/cnv//${sa}_diploidSV_VEP.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_diploidSV_VEP.vcf.gz.tbi"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP_summary.html" "${projectResultsDir}/variants/cnv/${sa}_diploidSV_VEP_summary.html"
		printf '.'
	fi
done
printf '%s' " finished\n"

#copy vcf file + coveragePerBase.txt + gender determination
printf "Copying vcf files, gender determination, coverage per base and per target files "
for sa in "${UNIQUESAMPLES[@]}"
do

	rsync -a "${intermediateDir}/${sa}.final.vcf.gz" "${projectResultsDir}/variants/"
	printf '.'
	rsync -a "${intermediateDir}/${sa}.final.vcf.gz.tbi" "${projectResultsDir}/variants/"
	printf '.'
	mapfile -t coveragePerBaseFiles < <(find ${intermediateDir} -name "${sa}*.coveragePerBase.txt")
	if [[ "${#coveragePerBaseFiles[@]}" -eq '0' ]]
	then
		echo "there are no coveragePerBase files for sample: ${sa}"
		continue
	else
		for coveragePerBaseFile in "${coveragePerBaseFiles[@]}"
		do
			rsync -a "${coveragePerBaseFile}" "${projectResultsDir}/coverage/CoveragePerBase/"
			printf '.'
		done
	fi
	

	## copy the rejected samples (with less 90% of the targets with > 20x coverage)
	mapfile -t rejectedSamples < <(find ${intermediateDir} -name "${sa}*.rejected")
	if [[ "${#rejectedSamples[@]}" -eq '0' ]]
	then
		echo "there are no .rejected files for sample: ${sa}"
		continue
	else
		for rejectedSample in "${rejectedSamples[@]}"
		do
			basename "${rejectedSample}" >> "${projectResultsDir}/coverage/rejectedSamples.txt"
		done
		cat "${intermediateDir}/${sa}."*.rejected > "${projectResultsDir}/coverage/rejectedSamplesResult.txt"
	fi
	mapfile -t coveragePerTargetFiles < <(find ${intermediateDir} -name "${sa}*.coveragePerTarget.txt")
	if [[ "${#coveragePerTargetFiles[@]}" -eq '0' ]]
	then
		echo "there are no coveragePerTarget files for sample: ${sa}"
		continue
	else
		for coveragePerTargetFile in "${coveragePerTargetFiles[@]}"
		do
			rsync -a "${coveragePerTargetFile}" "${projectResultsDir}/coverage/CoveragePerTarget/"
			printf '.'
		done
	else
		echo "coveragePerTarget skipped for sample: ${sa}"
	fi

done
printf " finished\n"


# print README.txt files
printf "Copying QC report to results directory "

# Copy QC report to results directory
rsync -a "${intermediateDir}/${project}_multiqc_report.html" "${projectResultsDir}"
rsync -av "${intermediateDir}/multiqc_data" "${projectResultsDir}/"
printf '.'
printf " finished\n"

if [ ! -d "${logsDir}/${project}/" ]
then
	mkdir -p "${logsDir}/${project}/"
fi

## removing phiX.recoded files
rm -f "${projectResultsDir}/rawdata/ngs/"*".phiX.recoded.fq.gz"

echo "pipeline is finished"

runNumber=$(basename "$(dirname "${projectResultsDir}")")
if [ -f "${logsDir}/${project}/${runNumber}.pipeline.started" ]
then
	mv "${logsDir}/${project}/${runNumber}.pipeline".{started,finished}
else
	touch "${logsDir}/${project}/${runNumber}.pipeline.finished"
fi
echo "finished: $(date +%FT%T%z)" >> "${logsDir}/${project}/${runNumber}.pipeline.totalRuntime"
rm -f "${logsDir}/${project}/${runNumber}.pipeline.failed"
echo "${logsDir}/${project}/${runNumber}.pipeline.finished is created"


touch pipeline.finished

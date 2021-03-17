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
#string convadingVersion
#string capturingKit
#string cxControlsDir
#string ControlsVersioning
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
	array_contains UNIQUESAMPLES "$samples" || UNIQUESAMPLES+=("$samples")    # If bamFile does not exist in array add it
done

EXTERN=${#UNIQUESAMPLES[@]}
#
# Project CSV file and capturingKitFolder.
#
printf 'Copying project csv file to results directory .'
rsync -a "${projectJobsDir}/${project}.csv" "${projectResultsDir}"
printf '.'
rsync -a "${intervalListDir}" "${projectResultsDir}/bedfile/"
printf '.'
bedfileName=$(basename "${capturingKit}")
ls -1 ${coveragePerBaseDir}/${bedfileName}/ > ${projectResultsDir}/coverage/CoveragePerBase/CovPerBase.txt
ls -1 ${coveragePerTargetDir}/${bedfileName}/ > ${projectResultsDir}/coverage/CoveragePerTarget/CovPerTarget.txt
printf '%s\n' '.. finished.'
#
# GAVIN VCFs.
#
printf 'Copying GAVIN results to results directory .'
for sample in "${UNIQUESAMPLES[@]}"
do
	if [ -f "${intermediateDir}/${sample}.GAVIN.rlv.vcf" ]
	then
		rsync -a "${intermediateDir}/${sample}.GAVIN.rlv.vcf.gz" "${projectResultsDir}/variants/GAVIN/"
		printf '.'
	fi
done
printf '%s\n' ' finished.'
#
# Regular VCF and table for complete project.
#
printf 'Copying variants vcf and tables to results directory .'
rsync -a "${projectPrefix}.final.vcf.table" "${projectResultsDir}/variants/"
printf '.'
rsync -a "${projectPrefix}.final.vcf.gz" "${projectResultsDir}/variants/"
printf '.'
rsync -a "${projectPrefix}.final.vcf.gz.tbi" "${projectResultsDir}/variants/"
printf '.'
printf '%s\n' ' finished.'
#
# CoNVaDING, XHMM and Manta results.
#
printf 'Copying CoNVaDING, XHMM and Manta results to results directory .'
for sa in "${UNIQUESAMPLES[@]}"
do
	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_candidateSV.vcf.gz"
		printf '.'
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSV.vcf.gz.tbi"
		printf '.'
	fi
	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_candidateSmallIndels.vcf.gz"
		printf '.'
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSmallIndels.vcf.gz.tbi"
		printf '.'
	fi
	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_diploidSV.vcf.gz"
		printf '.'
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_diploidSV.vcf.gz.tbi"
		printf '.'
	fi
	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz" "${projectResultsDir}/variants/cnv//${sa}_candidateSV_VEP.vcf.gz"
		printf '.'
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSV_VEP.vcf.gz.tbi"
		printf '.'
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP_summary.html" "${projectResultsDir}/variants/cnv/${sa}_candidateSV_VEP_summary.html"
		printf '.'
	fi
	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz" "${projectResultsDir}/variants/cnv//${sa}_diploidSV_VEP.vcf.gz"
		printf '.'
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_diploidSV_VEP.vcf.gz.tbi"
		printf '.'
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP_summary.html" "${projectResultsDir}/variants/cnv/${sa}_diploidSV_VEP_summary.html"
		printf '.'
	fi
	if ls "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.log 1> /dev/null 2>&1
	then
		cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.totallist.txt "${projectResultsDir}/variants/cnv/"
		printf '.'
		cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.shortlist.txt "${projectResultsDir}/variants/cnv/"
		printf '.'
		cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.longlist.txt "${projectResultsDir}/variants/cnv/"
		printf '.'
		cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.log "${projectResultsDir}/variants/cnv/"
		printf '.'
		cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.log.sampleRatio "${projectResultsDir}/variants/cnv/${sa}.sampleRatio.txt"
		printf '.'
		cp "${intermediateDir}/Convading//CreateFinalList/${sa}/"*.shortlist.finallist.txt "${projectResultsDir}/variants/cnv/"
		printf '.'
	fi
	if [ -f "${intermediateDir}/${sa}_step10.xcnv.final" ]
	then
		cp "${intermediateDir}/${sa}_step10.xcnv.final" "${projectResultsDir}/variants/cnv/"
		printf '.'
	fi
	if [ -f "${intermediateDir}/${sa}.longlistplusplusFinal.txt" ]
	then
		rsync -a "${intermediateDir}/${sa}.longlistplusplusFinal.txt" "${projectResultsDir}/variants/cnv/"
		printf '.'
		capturedBedFile=$(grep "${capturingKit}" "${ControlsVersioning}" | awk '{FS=" "}{print $2}')
		cp "${cxControlsDir}/${capturedBedFile}/Convading/targetQcList.txt" "${projectResultsDir}/variants/cnv/"
		printf '.'
	fi
done
printf '%s\n' ' finished.'
#
# Regular VCFs and tables per sample.
#
printf 'Copying regular VCF and table files per sample .'
for sa in "${UNIQUESAMPLES[@]}"
do
	rsync -a "${intermediateDir}/${sa}.final.vcf.table" "${projectResultsDir}/variants/"
	printf '.'
	rsync -a "${intermediateDir}/${sa}.final.vcf.gz" "${projectResultsDir}/variants/"
	printf '.'
	rsync -a "${intermediateDir}/${sa}.final.vcf.gz.tbi" "${projectResultsDir}/variants/"
	printf '.'
done
printf '%s\n' ' finished.'
#
# QC report.
#
printf 'Copying QC report to results directory .'
rsync -a "${intermediateDir}/${project}_multiqc_report.html" "${projectResultsDir}"
printf '.'
rsync -a "${intermediateDir}/multiqc_data" "${projectResultsDir}/"
printf '.'
printf '%s\n' ' finished.'
#
# Create zip file for all "small" files.
#
printf '%s' "Creating zip file ${projectResultsDir}/${project}.zip ... "
CURRENT_DIR=$(pwd)
cd "${projectResultsDir}"
zip -gr "${projectResultsDir}/${project}.zip" variants/*.vcf*
zip -gr "${projectResultsDir}/${project}.zip" variants/cnv
zip -gr "${projectResultsDir}/${project}.zip" variants/GAVIN
zip -gr "${projectResultsDir}/${project}.zip" qc
zip -g "${projectResultsDir}/${project}.zip" "${project}.csv"
zip -g "${projectResultsDir}/${project}.zip" "${project}_multiqc_report.html"
md5sum "${project}.zip" > "${projectResultsDir}/${project}.zip.md5"
printf '%s\n' ' finished.'
#
# Removing phiX.recoded files.
#
#
rm -f "${projectResultsDir}/rawdata/ngs/"*".phiX.recoded.fq.gz"
#
# Define variables to log that we've reached the end.
# The logging the this workflow has finished happens at the end of the footer_tnt.ftl
# as something may still go wrong there, so creating a *.pipeline.finished file here would be premature.
#
cd "${CURRENT_DIR}"
if [ ! -d "${logsDir}/${project}/" ]
then
	mkdir -p "${logsDir}/${project}/"
fi
runNumber=$(basename $(dirname "${projectResultsDir}"))
lastStep='true'
workflowControlFileBase="${logsDir}/${project}/${runNumber}.pipeline"

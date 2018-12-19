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
mkdir -p "${projectResultsDir}/general"
mkdir -p "${projectResultsDir}/bedfile/"

UNIQUESAMPLES=()
for samples in "${externalSampleID[@]}"
do
	array_contains UNIQUESAMPLES "$samples" || UNIQUESAMPLES+=("$samples")    # If bamFile does not exist in array add it
done

EXTERN=${#UNIQUESAMPLES[@]}

# Copy project csv file and capturingKitFolder to project results directory
printf "Copied project csv file to project results directory.."
rsync -a "${projectJobsDir}/${project}.csv" "${projectResultsDir}"
rsync -a "${intervalListDir}" "${projectResultsDir}/bedfile/"

bedfileName=$(basename "${capturingKit}")
ls -1 ${coveragePerBaseDir}/${bedfileName}/ > ${projectResultsDir}/coverage/CoveragePerBase/CovPerBase.txt
ls -1 ${coveragePerTargetDir}/${bedfileName}/ > ${projectResultsDir}/coverage/CoveragePerTarget/CovPerTarget.txt

printf ".. finished \n"

##Copy GAVIN results
for sample in "${UNIQUESAMPLES[@]}"
do
	if [ -f "${intermediateDir}/${sample}.GAVIN.rlv.vcf" ]
	then
		rsync -a "${intermediateDir}/${sample}.GAVIN.rlv.vcf.gz" "${projectResultsDir}/variants/GAVIN/"
	fi
done

count=1

printf "Copying variants vcf and tables to results directory "
# Copy variants vcf and tables to results directory
rsync -a "${projectPrefix}.final.vcf.table" "${projectResultsDir}/variants/"
printf "."
rsync -a "${projectPrefix}.final.vcf.gz" "${projectResultsDir}/variants/"
printf "."
rsync -a "${projectPrefix}.final.vcf.gz.tbi" "${projectResultsDir}/variants/"
printf "."


echo "copy cnv results of Convading and XHMM and Manta"

for sa in "${UNIQUESAMPLES[@]}"
do
	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_candidateSV.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSV.vcf.gz.tbi"
		printf "."
	fi

	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz" ]
        then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_candidateSmallIndels.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSmallIndels.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSmallIndels.vcf.gz.tbi"
		printf "."
	fi

	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz" ]
        then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz" "${projectResultsDir}/variants/cnv/${sa}_diploidSV.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_diploidSV.vcf.gz.tbi"
		printf "."
	fi


	if [ -f "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz" ]
	then
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz" "${projectResultsDir}/variants/cnv//${sa}_candidateSV_VEP.vcf.gz"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_candidateSV_VEP.vcf.gz.tbi"
		rsync -a "${intermediateDir}/Manta/${sa}/results/variants/candidateSV_VEP_summary.html" "${projectResultsDir}/variants/cnv/${sa}_candidateSV_VEP_summary.html"
		printf "."
	fi


        if [ -f "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz" ]
        then
                rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz" "${projectResultsDir}/variants/cnv//${sa}_diploidSV_VEP.vcf.gz"
                rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP.vcf.gz.tbi" "${projectResultsDir}/variants/cnv/${sa}_diploidSV_VEP.vcf.gz.tbi"
                rsync -a "${intermediateDir}/Manta/${sa}/results/variants/diploidSV_VEP_summary.html" "${projectResultsDir}/variants/cnv/${sa}_diploidSV_VEP_summary.html"
                printf "."
        fi


	if ls "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.log 1> /dev/null 2>&1
        then
                echo "copying Convading data"
                cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.totallist.txt "${projectResultsDir}/variants/cnv/"
                cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.shortlist.txt "${projectResultsDir}/variants/cnv/"
                cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.longlist.txt "${projectResultsDir}/variants/cnv/"
                cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.log "${projectResultsDir}/variants/cnv/"
                cp "${intermediateDir}/Convading//StartWithBestScore/${sa}/"*.only.best.score.log.sampleRatio "${projectResultsDir}/variants/cnv/${sa}.sampleRatio.txt"
                cp "${intermediateDir}/Convading//CreateFinalList/${sa}/"*.shortlist.finallist.txt "${projectResultsDir}/variants/cnv/"
        fi
        if [ -f "${intermediateDir}/${sa}_step10.xcnv.final" ]
        then

                echo "copying XHMM results"
                cp "${intermediateDir}/${sa}_step10.xcnv.final" "${projectResultsDir}/variants/cnv/"
        fi

	if [ -f "${intermediateDir}/${sa}.longlistplusplusFinal.txt" ]
	then
		echo "copying output decision tree to results/variants/cnv/"
		rsync -a "${intermediateDir}/${sa}.longlistplusplusFinal.txt" "${projectResultsDir}/variants/cnv/"
		capturedBedFile=$(grep "${capturingKit}" "${ControlsVersioning}" | awk '{FS=" "}{print $2}')
                cp "${cxControlsDir}/${capturedBedFile}/Convading/targetQcList.txt" "${projectResultsDir}/variants/cnv/"

	fi


done
printf " finished\n"

#copy vcf file + coveragePerBase.txt + gender determination
printf "Copying vcf files, gender determination, coverage per base and per target files "
for sa in "${UNIQUESAMPLES[@]}"
do
	rsync -a "${intermediateDir}/${sa}.final.vcf.table" "${projectResultsDir}/variants/"
	printf "."

	rsync -a "${intermediateDir}/${sa}.final.vcf.gz" "${projectResultsDir}/variants/"
	printf "."
	rsync -a "${intermediateDir}/${sa}.final.vcf.gz.tbi" "${projectResultsDir}/variants/"
	printf "."


	rsync -a "${intermediateDir}/${sa}.chosenSex.txt" "${projectResultsDir}/general/"
	printf "."

	if ls "${intermediateDir}/${sa}."*.coveragePerBase.txt 1> /dev/null 2>&1
	then
		for i in $(ls "${intermediateDir}/${sa}."*.coveragePerBase.txt )
		do
			rsync -a "${i}" "${projectResultsDir}/coverage/CoveragePerBase/"
			printf "."
		done

	else
		echo "coveragePerBase skipped for sample: ${sa}"
	fi

	## copy the rejected samples (with less 90% of the targets with > 20x coverage)
	if ls "${intermediateDir}/${sa}."*.rejected 1> /dev/null 2>&1
	then
		for i in $(ls "${intermediateDir}/${sa}."*.rejected) 
		do
			basename $i >> "${projectResultsDir}/coverage/rejectedSamples.txt"
		done
		cat "${intermediateDir}/${sa}."*.rejected > "${projectResultsDir}/coverage/rejectedSamplesResult.txt"
	fi
	if ls "${intermediateDir}/${sa}."*.coveragePerTarget.txt 1> /dev/null 2>&1
        then
		for i in $(ls "${intermediateDir}/${sa}."*.coveragePerTarget.txt )
		do
			rsync -a "${i}" "${projectResultsDir}/coverage/CoveragePerTarget/"
			printf "."
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
printf "."
printf " finished\n"

echo "Creating zip file"
# Create zip file for all "small text" files
CURRENT_DIR=$(pwd)
cd "${projectResultsDir}"

zip -gr "${projectResultsDir}/${project}.zip" variants
zip -gr "${projectResultsDir}/${project}.zip" qc
zip -g "${projectResultsDir}/${project}.zip" "${project}.csv"
zip -g "${projectResultsDir}/${project}.zip" "${project}_multiqc_report.html"
zip -gr "${projectResultsDir}/${project}.zip" coverage

echo "Zip file created: ${projectResultsDir}/${project}.zip "

# Create md5sum for zip file

md5sum "${project}.zip" > "${projectResultsDir}/${project}.zip.md5"
echo "Made md5 file for ${projectResultsDir}/${project}.zip "

cd "${CURRENT_DIR}"

echo "pipeline is finished"
#touch ${logsDir}/${project}/${project}.pipeline.finished
runNumber=$(basename $( dirname "${projectResultsDir}"))
if [ -f "${logsDir}/${project}/${runNumber}.pipeline.started" ]
then
	mv "${logsDir}/${project}/${runNumber}.pipeline".{started,finished}
else
	touch "${logsDir}/${project}/${runNumber}.pipeline.finished"
fi
rm -f "${logsDir}/${project}/${runNumber}.pipeline.failed"
echo "${logsDir}/${project}/${runNumber}.pipeline.finished is created"

if [ ! -d "${logsDir}/${project}/" ]
then
	mkdir -p "${logsDir}/${project}/"
fi

whichHost=$(hostname)
diagnosticsCluster="true"

if [ "${whichHost}" == "zinc-finger.gcc.rug.nl" ]
then
	tmpHost="localhost"
	concordanceDir="${tmpDataDir}/Concordance/ngs/"

elif [[ "${whichHost}" == "leucine-zipper" ]]
then
	ssh -q zinc-finger.gcc.rug.nl exit
	if [ $? -eq 0 ]
	then
		tmpHost="zinc-finger.gcc.rug.nl"
		concordanceDir="/groups/umcg-gd/tmp05/Concordance/ngs/"
	else
		echo "zinc-finger is down, writing data to leucine-zipper instead"
		tmpHost="localhost"
		concordanceDir="${tmpDataDir}/Concordance/ngs/"
	fi
else
	diagnosticsCluster="false"
fi

if [[ "${diagnosticsCluster}" == "true" ]]
then
	for sample in "${UNIQUESAMPLES[@]}"
	do
		zcat ${projectResultsDir}/variants/${sample}.final.vcf.gz > ${projectResultsDir}/variants/${sample}.final.vcf
		rsync -av ${projectResultsDir}/variants/${sample}.final.vcf "${tmpHost}:${concordanceDir}"
		rm  ${projectResultsDir}/variants/${sample}.final.vcf
	done
fi
## removing phiX.recoded files
rm -f "${projectResultsDir}/rawdata/ngs/"*".phiX.recoded.fq.gz"

touch pipeline.finished

#Parameter mapping
#string tmpName
#string intermediateDir
#string dedupBam
#string project
#string logsDir 
#string groupname
#string externalSampleID
#string indexFile
#string capturedIntervalsPerBase
#string capturedBed
#string sampleNameID
#string capturingKit
#string coveragePerBaseDir
#string coveragePerTargetDir
#string ngsUtilsVersion
#string gatkVersion
#string pythonVersion
#string projectResultsDir
#string gVCF2BEDVersion
#string htsLibVersion
#string externalSampleID
#list batchID

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
module purge
module load "${gatkVersion}"
module load "${ngsUtilsVersion}"
module load "${htsLibVersion}"
module load "${gVCF2BEDVersion}"

### Per base bed files
bedfileRaw=$(basename "${capturingKit}")
if [[ "${bedfileRaw}" =~ "QXT" ]]
then
	bedfile=$(echo "${bedfileRaw}" | awk '{print substr($0,4)}')
elif [[ "${bedfileRaw}" =~ "XT" ]]
then
	bedfile=$(echo "${bedfileRaw}" | awk '{print substr($0,3)}')
else
	bedfile="${bedfileRaw}"
fi
ml ngs-utils

INPUTS=()
for batch in "${batchID[@]}"
do
	gVCF="${projectResultsDir}/variants/gVCF/${externalSampleID}.batch-${batch}.variant.calls.g.vcf.gz"
	if [[ -f "${gVCF}" ]]
	then
		array_contains INPUTS "-I ${gVCF}" || INPUTS+=("-I ${gVCF}")
	fi
done

if [[ "${#INPUTS[@]:-0}" -eq '0' ]]
then
	echo "There are no gVCF files"
else
	if [[ ! -f "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz" ]]
	then
		gatk GatherVcfs \
		${INPUTS[*]} \
		--OUTPUT "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz"
	fi

	if [[ ! -f "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz.tbi" ]]
	then
		tabix -p vcf "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz"
	fi
fi

echo "starting to do the calculations"
echo "MYBEDFILE is: ${bedfile} it was ${bedfileRaw}"
if [ -d "${coveragePerBaseDir}/${bedfile}/" ]
then
	mapfile -t bedfiles < <(find "${coveragePerBaseDir}/${bedfile}/"* )
	if [[ "${#bedfiles[@]}" -eq '0' ]]
	then
		echo "There are no CoveragePerBase calculations for this bedfile"
	else
		for i in "${bedfiles[@]}"
		do
			perBase=$(basename "${i}")
			perBaseDir="$(dirname "${i}")/${perBase}/human_g1k_v37/"
			echo "perBaseDir: ${perBaseDir}"

			outputFile="${intermediateDir}/${externalSampleID}.${perBase}.CoverageOutput.csv"

			gvcf2bed2.py \
				-I "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz" \
				-O "${outputFile}" \
				-b "${perBaseDir}/${perBase}.uniq.per_base.bed"

			awk '{sumDP+=$11;sumTargetSize+=$12;sumCoverageInDpLow+=$13;sumZeroCoverage+=14}END{print "avgCov: "(sumDP/sumTargetSize)"\t%coverageBelow20: "((sumCoverageInDpLow/sumTargetSize)*100)"\t%ZeroCoverage: "((sumZeroCoverage/sumTargetSize)*100)}' "${outputFile}" > "${outputFile%.*}.incl_TotalAvgCoverage_TotalPercentagebelow20x.txt"

			awk 'BEGIN{OFS="\t"}{if (NR>1){print (NR-1),$1,$2,$3,$8,$4,$12,"CDS","1"}else{print "Index\tChr\tChr Position Start\tChr Position End\tAverage Counts\tDescription\tReference Length\tCDS\tContig"}}' "${outputFile}" > "${intermediateDir}/${externalSampleID}.${perBase}.coveragePerBase.txt"

			echo "Raw output file is here: ${outputFile}"
			echo "final statistics can be found here: ${outputFile%.*}.incl_TotalAvgCoverage_TotalPercentagebelow20x.txt"
			echo "coveragePerTarget file can be found here: ${intermediateDir}/${externalSampleID}.${perBase}.coveragePerBase.txt"

		done
	fi
else
	echo "There are no CoveragePerBase calculations for this bedfile: ${bedfile}"

fi
## Per target bed files
if [ -d "${coveragePerTargetDir}/${bedfile}/" ]
then
	mapfile -t bedfiles < <(find "${coveragePerTargetDir}/${bedfile}/"* )
	if [[ "${#bedfiles[@]}" -eq '0' ]]
	then
		echo "There are no CoveragePerTarget calculations for this bedfile"
	else
		for i in "${bedfiles[@]}"
		do
			perTarget=$(basename "${i}")
			perTargetDir="$(dirname "${i}")/${perTarget}/human_g1k_v37/"
			echo "perTargetDir: ${perTargetDir}"

			outputFile="${intermediateDir}/${externalSampleID}.${perTarget}.CoverageOutput.csv"

			gvcf2bed2.py \
				-I "${intermediateDir}/${externalSampleID}.merged.g.vcf.gz" \
				-O "${outputFile}" \
				-b "${perTargetDir}/${perTarget}.bed"

			awk '{sumDP+=$11;sumTargetSize+=$12;sumCoverageInDpLow+=$13;sumZeroCoverage+=14}END{print "avgCov: "(sumDP/sumTargetSize)"\t%coverageBelow20: "((sumCoverageInDpLow/sumTargetSize)*100)"\t%ZeroCoverage: "((sumZeroCoverage/sumTargetSize)*100)}' "${outputFile}" > "${outputFile%.*}.incl_TotalAvgCoverage_TotalPercentagebelow20x.txt"

			awk 'BEGIN{OFS="\t"}{if (NR>1){print (NR-1),$1,$2,$3,$8,$4,$12,"CDS","1"}else{print "Index\tChr\tChr Position Start\tChr Position End\tAverage Counts\tDescription\tReference Length\tCDS\tContig"}}' "${outputFile}" > "${intermediateDir}/${externalSampleID}.${perTarget}.coveragePerTarget.txt"

			echo "Raw output file is here: ${outputFile}"
			echo "final statistics can be found here: ${outputFile%.*}.incl_TotalAvgCoverage_TotalPercentagebelow20x.txt"
			echo "coveragePerTarget file can be found here: ${intermediateDir}/${externalSampleID}.${perTarget}.coveragePerTarget.txt"

			if [[ "${perTarget}" ==  "${bedfile}" ]]
			then
				sizePerTarget=$(wc -l "${intermediateDir}/${externalSampleID}.${perTarget}.coveragePerTarget.txt" | awk '{print $1}')
				totalcount=$((${sizePerTarget}-1))
				count=0
				count=$(awk 'BEGIN{sum=0}{if($5 < 20){sum++}} END {print sum}' "${intermediateDir}/${externalSampleID}.${perTarget}.coveragePerTarget.txt")

				if [[ "${count}" -eq '0' ]]
				then
					percentage=0
				else
					percentage=$((count*100/totalcount))
					if [ "${percentage%%.*}" -gt 10 ]
					then
						echo "${sampleNameID}: percentage ${percentage} (${count}/${totalcount}) is more than 10 procent, skipped"
						echo "${sampleNameID}: percentage ${percentage} (${count}/${totalcount}) is more than 10 procent, skipped" > "${intermediateDir}/${externalSampleID}.rejected"
					fi
				fi
			fi
		done
	fi
else
	echo "There are no CoveragePerTarget calculations for this bedfile: ${bedfile}"
fi

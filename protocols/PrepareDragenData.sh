#Parameter mapping
#string logsDir
#string seqType
#string intermediateDir
#string project
#string groupname
#string tmpName
#string externalSampleID
#string projectPrefix
#list batchID
#string inputVcf
#string sampleProcessStepID

## VCF
## rename vcf files
fileName=$(find ${INPUTFOLDERVCF} -name '*${sampleProcessStepID}*.vcf')
fileName="$(basename "${fileName}")"
fileNameNoExt=${fileName%%.*}
rename "${fileNameNoExt}" "${externalSampleID}" ${INPUTFOLDERVCF}/*${sampleProcessStepID}*.vcf*

##reheader vcf file with new sample identifier --> familyname+umcgnumber
newSampleIdentifier=$(echoe ${externalSampleID} | awk '{FS="_"}{print $1"_"$2}'

## BAM
#rename bam/cram files
rename "${fileNameNoExt}" "${externalSampleID}" ${INPUTFOLDERBAM}/*${sampleProcessStepID}*.bam*

## GVCF
#rename gVCF files
rename "${fileNameNoExt}" "${externalSampleID}" ${INPUTFOLDERGVCF}/*${sampleProcessStepID}*.gvcf*


grep '^#' "${externalSampleID}.vcf" > "${intermediateDir}/header.vcf"
grep -v '^#' "${externalSampleID}.vcf" | awk -v var="${intermediateDir}" '{if ($1 !~ /\|/){print $0 >> var"/captured.batch-"$1".vcf"}}'



for i in "${batchID[@]}"
do
	if [[ -f "${intermediateDir}//captured.batch-${i}.vcf" ]]
	then
		cat "${intermediateDir}/header.vcf" "${intermediateDir}//captured.batch-${i}.vcf" > "${intermediateDir}/${externalSampleID}.batch-${i}.variant.calls.genotyped.vcf"
		echo "cat ${intermediateDir}/header.vcf ${intermediateDir}//captured.batch-${i}.vcf > ${intermediateDir}/${externalSampleID}.batch-${i}.variant.calls.genotyped.vcf"
	fi
done


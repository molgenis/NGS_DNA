set -o pipefail
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

grep '^#' "${inputVcf}" > "${intermediateDir}/header.vcf"
grep -v '^#' "${inputVcf}" | awk -v var="${intermediateDir}" '{if ($1 !~ /\|/){print $0 >> var"/captured.batch-"$1".vcf"}}'

echo "${externalSampleID}" > "${intermediateDir}/${externalSampleID}.txt"

for i in "${batchID[@]}"
do
	if [[ -f "${intermediateDir}//captured.batch-${i}.vcf" ]]
	then
		cat "${intermediateDir}/header.vcf" "${intermediateDir}//captured.batch-${i}.vcf" > "${intermediateDir}/${project}.batch-${i}.variant.calls.genotyped.annotated.vcf"
		echo "cat ${intermediateDir}/header.vcf ${intermediateDir}//captured.batch-${i}.vcf > ${intermediateDir}/${project}.batch-${i}.variant.calls.genotyped.annotated.vcf"
	fi
done

#Parameter mapping
#string logsDir
#string seqType
#string intermediateDir
#string project
#string groupname
#string tmpName
#list externalSampleID
#string projectPrefix
#list batchID
#string inputVcf

grep '^#' "${inputVcf}" > "${intermediateDir}/header.vcf"
grep -v '^#' "${inputVcf}" | awk -v var="${intermediateDir}" '{if ($1 !~ /\|/){if ($1 == "X"){print $0 >> var"/captured.batch-Xnp.vcf"}else{print $0 >> var"/captured.batch-"$1".vcf"}}}'


for i in ${batchID[@]}
do
	if [ -f "$intermediateDir//captured.batch-${i}.vcf" ]
	then
		cat "${intermediateDir}/header.vcf" "$intermediateDir//captured.batch-${i}.vcf" > "${intermediateDir}/${project}.batch-${i}.variant.calls.genotyped.vcf"
		echo "cat ${intermediateDir}/header.vcf $intermediateDir//captured.batch-${i}.vcf > ${intermediateDir}/${project}.batch-${i}.variant.calls.genotyped.vcf"
	fi
done

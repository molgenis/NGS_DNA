#MOLGENIS ppn=4 mem=8gb walltime=07:00:00 

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
#string inputVCF

awk '{if ($1 ~ /#/){print $0}}' ${inputVCF} > ${intermediateDir}/header.vcf

awk -v var="${intermediateDir}" '{if ($1 !~ /#/){print $0 >> var"/captured.batch-"$1".vcf"}}' ${inputVCF}

for i in ${batchID[@]}
do
	if [ -f "$intermediateDir//captured.batch-${i}.vcf" ]
	then
		cat "${intermediateDir}/header.vcf" "$intermediateDir//captured.batch-${i}.vcf" > "${intermediateDir}/${project}.batch-${i}.variant.calls.genotyped.vcf"
		echo "cat ${intermediateDir}/header.vcf $intermediateDir//captured.batch-${i}.vcf > ${intermediateDir}/${project}.batch-${i}.variant.calls.genotyped.vcf"
	fi
done

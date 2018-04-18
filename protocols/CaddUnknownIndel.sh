#MOLGENIS walltime=23:59:00 mem=6gb ppn=8

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string projectBatchGenotypedVariantCalls
#string projectBatchGenotypedVariantCallsIndels
#string project
#string logsDir
#string groupname
#string tmpDataDir
#string caddVersion
#string htsLibVersion
#string unknownIndelsVcf
#string caddUnknownIndelAnnotation
#string caddSlicedIndelAnnotation

makeTmpDir "${projectBatchGenotypedVariantCallsIndels}"
tmpProjectBatchGenotypedVariantCallsIndels="${MC_tmpFile}"

${stage} "${caddVersion}"
${stage} "${htsLibVersion}"
${checkStage}

awk '{if (length($4)>1 || length($5)>1){print $1"-"$2"-"$4"-"$5}}' "${projectBatchGenotypedVariantCalls}" | grep -v "#" |\
awk 'BEGIN {FS="-"}{if ($4 ~ /,/){split ($4,a,",");for (i in a) print $1"-"$2"-"$3"-"a[i]}else if ($3 ~ /,/){split ($3,a,",");for (i in a) print $1"-"$2"-"a[i]"-"$4} else print $0}' > ${tmpProjectBatchGenotypedVariantCallsIndels}

echo "moving ${tmpProjectBatchGenotypedVariantCallsIndels} ${projectBatchGenotypedVariantCallsIndels}"
mv "${tmpProjectBatchGenotypedVariantCallsIndels}" "${projectBatchGenotypedVariantCallsIndels}"

rm -f "${unknownIndelsVcf}"

while read line
do
	if grep -q "^$line$" "${caddSlicedIndelAnnotation}"
        then
		echo "found"
        else
		echo "${line}" | awk 'BEGIN {FS="-"}{print $1"\t"$2"\t.\t"$3"\t"$4}'>> "${unknownIndelsVcf}"
        fi
done<"${projectBatchGenotypedVariantCallsIndels}"

if [ ! -f "${unknownIndelsVcf}" ]
then
	echo "there are no unknown indels in the file, skipped"
        echo -e "1\t0\t.\tA\tT" > ${unknownIndelsVcf}.tmp

        bgzip -c "${unknownIndelsVcf}.tmp" > "${caddUnknownIndelAnnotation}"
        tabix -p vcf "${caddUnknownIndelAnnotation}"
else

	echo "bgzip + tabix ${caddUnknownIndelAnnotation}"

        ##removing phiX reads, can't be annotated with CADD"
        awk '{if ($1 != "NC_001422.1"){print $0}}' "${unknownIndelsVcf}" > "${unknownIndelsVcf}.tmp"
        bgzip -c "${unknownIndelsVcf}.tmp" > "${unknownIndelsVcf}.gz"
        tabix -p vcf "${unknownIndelsVcf}.gz"

        ## calculating unknown Indels with score.sh
        score.sh "${unknownIndelsVcf}.gz" "${caddUnknownIndelAnnotation}"
fi

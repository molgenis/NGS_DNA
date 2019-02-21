#Parameter mapping
#string project
#string logsDir
#string groupname
#string tmpName
#string stage
#string checkStage

#string ngsversion
#string ngsUtilsVersion
#string bcfToolsVersion
#string bedToolsVersion
#string intermediateDir
#string vcf2Table
#string inhouseIntervalsDir
#string externalSampleID
#string gatkVersion
#string indexFile
#string projectPrefix

module load "${ngsUtilsVersion}"
module load "${bcfToolsVersion}"
module load "${ngsversion}"
module load "${bedToolsVersion}"
module load "${gatkVersion}"

name="${intermediateDir}/${externalSampleID}"

outputStep9_1ToSpecTree="${name}.step9_filteredOnTargets.proceedToSpecTree.vcf"
outputStep9="${name}.step9.vcf"

### show only variants in certain bed file
bedtools intersect -header -a "${outputStep9}" -b "${inhouseIntervalsDir}/Diagnostics/5GPM_NX158_target_v1.bed" > "${outputStep9_1ToSpecTree}.tmp.vcf"

## filter out the random forest variants
grep -v 'RF_Filter' "${outputStep9_1ToSpecTree}.tmp.vcf" > "${outputStep9_1ToSpecTree}"

grep -v '^#' "${outputStep9_1ToSpecTree}.tmp.vcf" | grep 'RF_Filter' | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"RF_FILTER",$8,$10}' >> "${name}.tagsAndFilters.tsv"
sort -V "${name}.tagsAndFilters.tsv" | uniq > "${name}.tagsAndFilters.sorted.tsv"

## count number of variants
count_9_true=$(cat "${outputStep9_1ToSpecTree}" | grep -v '^#' | wc -l | cat)

echo "Step 9(Merging all the prev steps + 5GPM_NX158 bedfile to select only regions of interest); TRUE: ${count_9_true}"
echo "This is the final output: ${outputStep9_1ToSpecTree}"

python "${EBROOTNGS_DNA}/scripts/CartegeniaFilterTag.py" "${name}.tagsAndFilters.sorted.tsv" | awk 'BEGIN {OFS="\t"}{FS="^"}{print $1,$2,$3,$4,$7,$5,$6}' | sort -V > "${name}.SearchFortagsAndFilters.tsv"

echo "this is the final output in table format: ${outputStep9_1ToSpecTree}.table"
echo "this is the tag/filter file: ${name}.SearchFortagsAndFilters.tsv"

## in case of trio we want to know the variants of the parents too
####### TURNED OFF THE TRIO OPTION
if [ -f "${name}.hasFamily.TURNEDOFF" ]
then

	child=$(head -1 "${name}.hasFamily" | awk '{print $1}' )
	mother=$(head -2 "${name}.hasFamily" | tail -1 | awk '{print $1}')
	father=$(tail -1 "${name}.hasFamily" | awk '{print $1}')

	childGender="${child}.chosenSex.txt"
	sort -V "${name}.hasFamily" > "${name}.hasFamily.sorted"
	childPos=$(awk '{if ($2 == "Child"){print (NR+9)}}' ${name}.hasFamily.sorted)
	motherPos=$(awk '{if ($2 == "Mother"){print (NR+9)}}' ${name}.hasFamily.sorted)
	fatherPos=$(awk '{if ($2 == "Father"){print (NR+9)}}' ${name}.hasFamily.sorted)
	## make bedfile for only getting the variants of interest out of the big vcf
	grep -v '^#'  "${outputStep9_1ToSpecTree}" | awk 'BEGIN {OFS="\t"}{print $1,($2-1),$2,"GENE"}' > "${name}.allVariants.bed"

	java -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
	-T SelectVariants \
	-R "${indexFile}" \
	-V "${projectPrefix}.final.vcf" \
	-o "${name}.InclAllelesParents.vcf" \
	-sn "${child}" \
	-sn "${father}" \
	-sn "${mother}" \
	-L "${name}.allVariants.bed"

	## removing unnecessary information => keep only GT field
	bcftools annotate -x ^FORMAT/GT "${name}.InclAllelesParents.vcf" | awk -v ch=${childPos} -v fa=${fatherPos} -v mo=${motherPos} 'BEGIN {OFS="\t"}{if ($0 !~ /^#/){split($ch,a,"/");split($fa,b,"/");split($mo,c,"/"); print $1,$2,$3,$4,$5,$6,$7,a[1],a[2],b[1],b[2],c[1],c[2],$8}}' | sort -V > "${name}.splittedAlleles.txt"
	grep -v '^#' "${outputStep9_1ToSpecTree}" | sort -V > "${outputStep9_1ToSpecTree}.withoutHeader"
	join -t $'\t' -o '1.1,1.2,1.3,2.4,2.5,1.6,1.7,1.8,1.9,2.8,2.9,2.10,2.11,2.12,2.13' -1 2 -2 2 "${outputStep9_1ToSpecTree}.withoutHeader" "${name}.splittedAlleles.txt" > "${name}.CartegeniaTreeCombinedWithAllelesParents.txt"

	## sort before using join
	sort -k1 <(awk '{print $1"_"$2"\t"$0}' ${name}.CartegeniaTreeCombinedWithAllelesParents.txt) > "${name}.CartegeniaTreeCombinedWithAllelesParents.sorted.txt"
	grep -v '^#' "${name}.SearchFortagsAndFilters.tsv" | awk '{print $1"_"$2"\t"$0}' | sort -k1,1  > "${name}.SearchFortagsAndFilters.sorted.tsv"
	##combine tags&filter file with variant file
	echo -e "chr\tposition\tsnp\tref\talt\ttag/filter\tChildA1\tChildA2\tMotherA1\tMotherA2\tFatherA1\tFatherA2" > "${name}.finalProduct.tsv"

	join  -t $'\t' -o '1.2,1.3,1.4,1.5,1.6,2.6,1.11,1.12,1.13,1.14,1.15,1.16' -1 1 -2 1 "${name}.CartegeniaTreeCombinedWithAllelesParents.sorted.txt" "${name}.SearchFortagsAndFilters.sorted.tsv" | sort -V >> "${name}.finalProduct.tsv"
else
	## sort before using join
	bcftools annotate -x ^FORMAT/GT "${outputStep9_1ToSpecTree}" | awk 'BEGIN {OFS="\t"}{if ($0 !~ /^#/){split($10,a,"/"); print $1,$2,$3,$4,$5,$6,$7,a[1],a[2],$8}}' | sort -V > "${name}.splittedAlleles.txt"
	sort -k1 <(awk '{print $1"_"$2"_"$4"_"$5"\t"$0}' "${name}.splittedAlleles.txt") > "${outputStep9_1ToSpecTree}.sorted.txt"
	grep -v '^#' "${name}.SearchFortagsAndFilters.tsv" | awk '{print $1"_"$2"_"$3"_"$4"\t"$0}' | sort -k1,1  > "${name}.SearchFortagsAndFilters.sorted.tsv"
	##combine tags&filter file with variant file
	echo -e "chr\tposition\tsnp\tref\talt\ttag/filter\tChildA1\tChildA2" > "${name}.finalProduct.tsv"
	join  -t $'\t' -o '1.2,1.3,1.5,1.6,2.6,1.9,1.10' -1 1 -2 1 "${outputStep9_1ToSpecTree}.sorted.txt" "${name}.SearchFortagsAndFilters.sorted.tsv" | sort -V  >> "${name}.finalProduct.tsv"
fi

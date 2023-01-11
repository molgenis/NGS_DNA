#string tmpName
#string simulatedPhiXVariants
#string inSilicoConcordanceFile
#string project
#string logsDir 
#string groupname
#string project
#string projectVariantsMerged
#string projectVariantsMergedSortedGz
#string intermediateDir

tail -4 "${simulatedPhiXVariants}" > "${intermediateDir}/InSilico.txt"
zcat "${projectVariantsMergedSortedGz}" > "${projectVariantsMergedSortedGz}.vcf"

awk '
BEGIN{}
FNR==NR{
	k=$1"\t"$2
	a[k]=$4"\t"$5
	b[k]=$0
	c[k]=$4
	d[k]=$5
	next
}

{ k=$1"\t"$2
	lc=c[k]
	ld=d[k]
	# file1 file2
	if ((k in a) && (lc==$4) && (ld==$5)){
		print k,lc,ld
	}
}' "${intermediateDir}/InSilico.txt" "${projectVariantsMergedSortedGz}.vcf" > "${intermediateDir}/InSilicoConcordanceCheck.txt"

count=$(wc -l "${intermediateDir}/InSilicoConcordanceCheck.txt")

if [[ "${count}" -ne 4 ]]
then
	echo "Spiked phiX SNPs are NOT found back, exiting"
	echo "EXPECTED:"
	cat "${intermediateDir}/InSilico.txt"

	echo -e "\n\n"
	echo "FOUND BACK:"
	awk  '$1 == "NC_001422.1"' "${projectVariantsMergedSortedGz}.vcf"
	exit 1
else
	echo "Spiked phiX SNPs are found back"
fi

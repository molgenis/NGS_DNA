#MOLGENIS walltime=05:59:00 mem=2gb ppn=1

#!/bin/bash
#string hpoTerms
#string intermediateDir
#string geneNetworkSource
#string geneNetwork

#string geneNetworkPrefixSample
#string geneNetworkPrefixSampleResult
#string geneNetworkLiftOveredBed
#string htsLibVersion
#string geneNetworkVcf

makeTmpDir ${geneNetworkVcf}
tmpGeneNetworkVcf=${MC_tmpFile}

module load "${htsLibVersion}"

IFS=';' read -r -a allTerms <<< "$hpoTerms"

count=1
arraytje=()

## get the column numbers of the hpoterms
for i in $(head -1 resources/GeneNetwork.txt)
do
	for terms in ${allTerms[@]}
        do
		if [ "${i}" == "$terms" ]
                then
                        termPositions+=("${count}")
                fi

        done
	count=$((count +1))

done

list=$(echo "${termPositions[@]}")
## get the values per row of the hpoterms
awk -v var="${list}" '{if (NR!=0){split(var, a, " ")} {printf "%s ", $1}{for (j in a) printf "%s ", $(a[j]); printf "\n"}}' "${geneNetworkSource}" > "${geneNetworkPrefixSample}CountsPerHPO.txt"

#remove header if existing
if [[ "${geneNetworkPrefixSample}CountsPerHPO.txt" == *"Gene"* ]]
then
	sed -i '1d' "${geneNetworkPrefixSample}CountsPerHPO.txt"
fi
#sum all values and divide it by the square root n
awk '{for(i=2;i<=NF;i++) sum+=$i; print $1,sum/sqrt(NF-1); sum=0 }' "${geneNetworkPrefixSample}CountsPerHPO.txt" > "${geneNetworkPrefixSample}CountsPerHPOTotal.txt"

##sorting
sort -k4 "${geneNetworkLiftOveredBed}" > "${geneNetworkPrefixSample}mart_export.b38.sorted.cleaned.liftovered.b37.sortColumnEnsID.bed"
sort -k1 "${geneNetworkPrefixSample}CountsPerHPOTotal.txt"  > "${geneNetworkPrefixSample}CountsPerHPOTotal.sortColumnEnsID.txt"

join -1 1 "${geneNetworkPrefixSample}CountsPerHPOTotal.sortColumnEnsID.txt" -2 4 "${geneNetworkPrefixSample}mart_export.b38.sorted.cleaned.liftovered.b37.sortColumnEnsID.bed"  | awk 'BEGIN {OFS="\t"}{print $3,$4,$5,$2}' | sort -V > "${geneNetworkPrefixSample}_scores.bed"

sort -n -r -k4 "${geneNetworkPrefixSample}_scores.bed" | awk 'BEGIN {OFS="\t"}{print $1,$2,$3,NR}' | sort -V > "${geneNetworkPrefixSample}_positionsAfterSorting.bed"

## bgzip and index files (is needed for VEP)
bgzip -c "${geneNetworkPrefixSample}_positionsAfterSorting.bed" > "${geneNetworkPrefixSample}_positionsAfterSorting.bed.gz"
tabix -p bed "${geneNetworkPrefixSample}_positionsAfterSorting.bed.gz"

bgzip -c "${geneNetworkPrefixSample}_scores.bed" > "${geneNetworkPrefixSample}_scores.bed.gz"
tabix -p bed "${geneNetworkPrefixSample}_scores.bed.gz"

echo "copy tmp-tmp results to intermediatedir"
echo  "copy ${geneNetworkPrefixSample}_positionsAfterSorting.bed.gz ${geneNetworkPrefixSampleResult}_positionsAfterSorting.bed"
echo "copy ${geneNetworkPrefixSample}_positionsAfterSorting.bed.gz ${geneNetworkPrefixSampleResult}_positionsAfterSorting.bed"

cp "${geneNetworkPrefixSample}_positionsAfterSorting.bed.gz" "${geneNetworkPrefixSampleResult}_positionsAfterSorting.bed"
cp "${geneNetworkPrefixSample}_scores.bed.gz" "${geneNetworkPrefixSampleResult}_scores.bed.gz"

#module VEP/90
#$EBROOTVEP/vep
echo "starting with custom VEP annotation"
/apps/sources/v/VEP/ensembl-vep-release-90.3/vep \
        -i "${gavinOutputFinalMergedRLV}" \
        --vcf \
        --custom "${geneNetworkPrefixSampleResult}_positionsAfterSorting.bed",GN.Position,bed \
        --custom "${geneNetworkPrefixSampleResult}_Scores.bed.gz",GN.ZScore,bed \
        -o "${tmpGeneNetworkVcf}"

mv ${tmpGeneNetworkVcf} ${geneNetworkVcf}
echo "moved ${tmpGeneNetworkVcf} ${geneNetworkVcf}"

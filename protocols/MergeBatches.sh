set -o pipefail
#Parameter mapping
#string tmpName
#string gatkVersion
#string htsLibVersion
#string ngsUtilsVersion
#string tempDir
#string intermediateDir
#string projectVariantsMergedSortedGz
#list batchID
#string projectPrefix
#string tmpDataDir
#string project
#string logsDir 
#string intermediateDir
#string groupname
#string sortVCFpl
#string indexFile
#string indexFileFastaIndex
#string indexFileDictionary
#string extension
#string dataDir
#string capturingKit
#string bcfToolsVersion

#Load module GATK,tabix
module load "${gatkVersion}"
module load "${bcfToolsVersion}"
module list

makeTmpDir "${projectVariantsMergedSortedGz}"
tmpProjectVariantsMergedSortedGz="${MC_tmpFile}"

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

INPUTS=()

for b in "${batchID[@]}"
do
	if [[ -f "${projectPrefix}.batch-${b}.${extension}" ]]
	then
		array_contains INPUTS "-I ${projectPrefix}.batch-${b}.${extension}" || INPUTS+=("-I ${projectPrefix}.batch-${b}.${extension}")
	fi
done

# shellcheck disable=SC2068 #${INPUTS[@]} => gatk needs seperate strings, not one captured in quotes
gatk --java-options "-Xmx5g -Djava.io.tmpdir=${tempDir}" MergeVcfs \
${INPUTS[@]} \
-O "${tmpProjectVariantsMergedSortedGz}" \
--SEQUENCE_DICTIONARY "${indexFileDictionary}"

echo "##intervals=[${dataDir}/${capturingKit}/human_g1k_v37/captured.merged.bed]" > "${intermediateDir}/bedfile.txt"

bcftools annotate -h "${intermediateDir}/bedfile.txt" -O v -o "${tmpProjectVariantsMergedSortedGz}.tmp.vcf.gz" "${tmpProjectVariantsMergedSortedGz}"
tabix -p vcf "${tmpProjectVariantsMergedSortedGz}.tmp.vcf.gz"

mv -v "${tmpProjectVariantsMergedSortedGz}.tmp.vcf.gz" "${projectVariantsMergedSortedGz}"
mv -v "${tmpProjectVariantsMergedSortedGz}.tmp.vcf.gz.tbi" "${projectVariantsMergedSortedGz}.tbi"

### make allChromosomes bedfile to use it later in CheckOutput script
awk '{print $1}' "${dataDir}/${capturingKit}/human_g1k_v37/captured.merged.bed" | uniq > "${intermediateDir}/allChromosomes.txt"
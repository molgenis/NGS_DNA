#Parameter mapping
#string tmpName


#string gatkVersion
#string gatkJar
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


#Load module GATK.
module load "${gatkVersion}"
module list

makeTmpDir "${projectVariantsMergedSortedGz}"
tmpProjectVariantsMergedSortedGz="${MC_tmpFile}"

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=${2}
    local in=0
    for element in "${!array-}"; do
        if [[ "${element}" == "${seeking}" ]]; then
            in=1
            break
        fi
    done
    return "${in}"
}

INPUTS=()
for b in "${batchID[@]}"
do
	if [ -f "${projectPrefix}.batch-${b}.${extension}" ]
	then
		array_contains INPUTS "--INPUT=${projectPrefix}.batch-${b}.${extension}" && INPUTS+=("--INPUT=${projectPrefix}.batch-${b}.${extension}")
	fi
done

gatk --java-options "-Xmx5g -Djava.io.tmpdir=${tempDir}" MergeVcfs \
${INPUTS[@]} \
--OUTPUT="${tmpProjectVariantsMergedSortedGz}" \
--SEQUENCE_DICTIONARY="${indexFileDictionary}"

mv "${tmpProjectVariantsMergedSortedGz}" "${projectVariantsMergedSortedGz}"
mv "${tmpProjectVariantsMergedSortedGz}.tbi" "${projectVariantsMergedSortedGz}.tbi"
echo "moved ${tmpProjectVariantsMergedSortedGz} to ${projectVariantsMergedSortedGz}"

### make allChromosomes bedfile to use it later in CheckOutput script
awk '{print $1}' "${dataDir}/${capturingKit}/human_g1k_v37/captured.merged.bed" | uniq > "${intermediateDir}/allChromosomes.txt"

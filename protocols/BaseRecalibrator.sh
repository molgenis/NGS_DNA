#Parameter mapping
#string tmpName


#string tempDir
#string intermediateDir
#string project
#string logsDir
#string indexFile 
#string groupname
#string tmpDataDir
#string gatkVersion
#string gatkJar
#string dbSnp
#string sampleMergedBam
#string sambambaVersion
#string sambambaTool
#string mergedBamRecalibratedTable

module load "${gatkVersion}"
module load "${sambambaVersion}"

module list

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=0
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=1
            break
        fi
    done
    return $in
}

INPUTS=()
for bamFile in "${sampleMergedBam[@]}"
do
	array_contains INPUTS "-I ${bamFile}" && INPUTS+=("-I ${bamFile}")    # If bamFile does not exist in array add it
done

makeTmpDir "${mergedBamRecalibratedTable}" "${intermediateDir}"
tmpMergedBamRecalibratedTable="${MC_tmpFile}"

"${sambambaTool}" index "${sampleMergedBam}"

gatk --java-options "-XX:ParallelGCThreads=7 -Djava.io.tmpdir=${tempDir} -Xmx9g" BaseRecalibrator \
-R "${indexFile}" \
"${INPUTS[@]}" \
--known-sites "${dbSnp}" \
-O "${tmpMergedBamRecalibratedTable}"

mv "${tmpMergedBamRecalibratedTable}" "${mergedBamRecalibratedTable}"
echo "moved ${tmpMergedBamRecalibratedTable}  ${mergedBamRecalibratedTable}"

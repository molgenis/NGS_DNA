#MOLGENIS walltime=23:59:00 mem=10gb ppn=8

#Parameter mapping
#string tmpName
#string stage
#string checkStage
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

"${stage}" "${gatkVersion}"
"${stage}" "${sambambaVersion}"

"${checkStage}"

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

for bamFile in "${sampleMergedBam[@]}"
do
	array_contains INPUTS "$bamFile" || INPUTS+=("-I $bamFile")    # If bamFile does not exist in array add it
        array_contains INPUTBAMS "$bamFile" || INPUTBAMS+=("-I $bamFile")    # If bamFile does not exist in array add it
done

makeTmpDir "${mergedBamRecalibratedTable}"
tmpMergedBamRecalibratedTable="${MC_tmpFile}"

"${sambambaTool}" index "${sampleMergedBam}"


java -XX:ParallelGCThreads=7 -Djava.io.tmpdir="${tempDir}" -Xmx9g -jar "${EBROOTGATK}/${gatkJar}" \
   -T BaseRecalibrator \
   -R "${indexFile}" \
   ${INPUTS[@]} \
   -nct 8 \
   -knownSites "${dbSnp}" \
   -o "${tmpMergedBamRecalibratedTable}"

mv "${tmpMergedBamRecalibratedTable}" "${mergedBamRecalibratedTable}"
echo "moved ${tmpMergedBamRecalibratedTable}  ${mergedBamRecalibratedTable}"

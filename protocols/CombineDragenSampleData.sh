#Parameter mapping
#string logsDir
#string tmpDirectory
#string seqType
#string intermediateDir
#string project
#string groupname
#string tmpName
#string projectResultsDir
#string tempDir
#string gatkJar
#list sampleBatchGenotypedVariantCalls
#string projectBatchGenotypedVariantCalls


module load "${gatkVersion}"

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

makeTmpDir "${projectBatchGenotypedVariantCalls}"
tmpProjectBatchGenotypedVariantCalls="${MC_tmpFile}"

for extId in "${sampleBatchGenotypedVariantCalls[@]}"
do
	
	array_contains INPUTS "--variant ${sampleId}" || INPUTS+=("--variant ${sampleId}") 	# If bamFile does not exist in array add it
done

java -XX:ParallelGCThreads=1 -Djava.io.tmpdir="${tempDir}" -Xmx7g -jar \
"${EBROOTGATK}/${gatkJar}" \
-T CombineVariants \
-R "${indexFile}" \
${INPUTS[@]} \
"${tmpProjectBatchGenotypedVariantCalls}"

mv -v "${tmpProjectBatchGenotypedVariantCalls}" "${projectBatchGenotypedVariantCalls}"


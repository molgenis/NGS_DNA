#MOLGENIS walltime=23:59:00 mem=13gb ppn=8

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
#string inputMergeBam

${stage} ${gatkVersion}
${checkStage}

#Function to check if array contains value
array_contains () {
	local array="${1[@]}"
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

for bamFile in "${inputMergeBam[@]}"
do
        array_contains INPUTS "$bamFile" || INPUTS+=("-I $bamFile")    # If bamFile does not exist in array add it
        array_contains INPUTBAMS "$bamFile" || INPUTBAMS+=("-I $bamFile")    # If bamFile does not exist in array add it
done

java -jar -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g ${EBROOTGATK}/${gatkJar} \
   -T PrintReads \
   -R ${indexFile} \
   ${INPUTS[@]} \
   -BQSR ${inputMergeBam}.recalibrated.table \
   -o ${inputMergeBam}.recalibrated.bam

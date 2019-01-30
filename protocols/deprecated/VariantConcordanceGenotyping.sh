#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string project
#string tmpDataDir
#string logsDir
#string groupname
#string intervalListDir

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

if [[ ${intervalListDir} == *"ONCO_v"* ]]
then

	#Load GATK module
	${stage} "${gatkVersion}"
	${checkStage}

	ALLGVCFs=()

	for i in $(ls ${intermediateDir}*.variant.calls.g.vcf.gz)
	do
		array_contains ALLGVCFs "--variant ${i}" || ALLGVCFs+=("--variant ${i}")
	done

	gvcfSize=${#ALLGVCFs[@]}
	if [ ${gvcfSize} -ne 0 ]
	then
	java -Xmx16g -XX:ParallelGCThreads=2 -Djava.io.tmpdir="${tempDir}" -jar \
		"${EBROOTGATK}/${gatkJar}" \
		-T GenotypeGVCFs \
		-R "${indexFile}" \
		-L ${intervalListDir}/GSA_SNPS.bed \
		-allSites \
		-o ${intermediateDir}/${project}.concordanceCheckSNPs.vcf \
		${ALLGVCFs[@]} 

	else
		echo ""
		echo "there is nothing to genotype, skipped"
		echo ""
	fi
else
	echo "this is not a ONCO run" 
fi

#MOLGENIS walltime=23:59:00 mem=14gb ppn=2

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string capturedBatchBed
#string femaleCapturedBatchBed
#string dbSnp
#string sampleBatchVariantCalls
#string sampleBatchVariantCallsIndex
#string sampleBatchVariantCallsMaleNONPAR
#string sampleBatchVariantCallsMaleNONPARIndex
#string sampleBatchVariantCallsFemale
#string sampleBatchVariantCallsFemaleIndex
#string tmpDataDir
#string externalSampleID
#string	project
#string logsDir 
#string groupname
#string dedupBam
#string sampleMergedBam

sleep 5

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

#Load GATK module
${stage} ${gatkVersion}
${checkStage}

makeTmpDir "${sampleBatchVariantCalls}"
tmpSampleBatchVariantCalls=${MC_tmpFile}

makeTmpDir "${sampleBatchVariantCallsIndex}"
tmpSampleBatchVariantCallsIndex=${MC_tmpFile}

makeTmpDir "${sampleBatchVariantCallsMaleNONPAR}"
tmpSampleBatchVariantCallsMaleNONPAR=${MC_tmpFile}

makeTmpDir "${sampleBatchVariantCallsMaleNONPARIndex}"
tmpSampleBatchVariantCallsMaleNONPARIndex=${MC_tmpFile} 

makeTmpDir "${sampleBatchVariantCallsFemale}"
tmpSampleBatchVariantCallsFemale=${MC_tmpFile}

makeTmpDir "${sampleBatchVariantCallsFemaleIndex}"
tmpSampleBatchVariantCallsFemaleIndex=${MC_tmpFile}

MALE_BAMS=()
BAMS=()
INPUTS=()
for SampleID in "${externalSampleID[@]}"
do
        array_contains INPUTS "$SampleID" || INPUTS+=("$SampleID")    # If bamFile does not exist in array add it
done
baitBatchLength=""
sex=$(less ${intermediateDir}/${externalSampleID}.chosenSex.txt | awk 'NR==2')
if [ -f "${capturedBatchBed}" ] 
then
	baitBatchLength=`cat "${capturedBatchBed}" | wc -l`
fi

if [ ! -d ${intermediateDir}/gVCF ]
then
	mkdir -p ${intermediateDir}/gVCF
fi

bams=($(printf '%s\n' "${dedupBam[@]}" | sort -u ))
inputs=$(printf ' -I %s ' $(printf '%s\n' ${bams[@]}))

if [[ ! -f "${capturedBatchBed}" ||  ${baitBatchLength} -eq 0 ]]
then
	echo "skipped ${capturedBatchBed}, because the batch is empty or does not exist"  
else
	if [[ "${capturedBatchBed}" == *batch-[0-9]*chrX.bed || "${capturedBatchBed}" == *batch-chrXnp.bed || "${capturedBatchBed}" == *batch-chrXp.bed ]]
	then
		if [[ "${sex}" == "Female" || "${sex}" == "Unknown" || "${capturedBatchBed}" == *batch-chrXp.bed ]]
		then
			if [ "${capturedBatchBed}" == *batch-chrXp.bed ]
			then
				echo "Par region of X, both female and male are diploid for this region"
			else
				echo "X (female)"
			fi
		
			#Run GATK HaplotypeCaller in DISCOVERY mode to call SNPs and indels
        		java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar \
        		${EBROOTGATK}/${gatkJar} \
        		-T HaplotypeCaller \
        		-R ${indexFile} \
        		$inputs \			
			--BQSR ${sampleMergedBam}.recalibrated.table \
			-dontUseSoftClippedBases \
	        	--dbsnp ${dbSnp} \
        		-o "${tmpSampleBatchVariantCalls}" \
        		-L "${capturedBatchBed}" \
        		--emitRefConfidence GVCF \
			-ploidy 2 
		elif [ "${sex}" == "Male" ]
		then
			echo "X (male): non autosomal region, mono ploid call"
			java -Xmx12g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -jar \
			${EBROOTGATK}/${gatkJar} \
			-T HaplotypeCaller \
			-R ${indexFile} \
			--dbsnp ${dbSnp} \
			--BQSR ${sampleMergedBam}.recalibrated.table \
			${inputs} \
			-dontUseSoftClippedBases \
			-o "${tmpSampleBatchVariantCalls}" \
			-L "${capturedBatchBed}" \
			--emitRefConfidence GVCF \
			-ploidy 1

		else 
			echo "The sex has not a known option (Male, Female, Unknown)"
			exit 1
		fi
	elif [[ "${capturedBatchBed}" == *batch-[0-9]*chrY.bed || "${capturedBatchBed}" == *batch-chrY.bed ]]
	then
		echo "Y"
		if [[ "${sex}" == "Female" || "${sex}" == "Unknown" ]]
        	then
			### Female Y is not existing, but this is
			### to prevent an error when combining all the variants together in one vcf 
			java -Xmx12g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -jar \
                        ${EBROOTGATK}/${gatkJar} \
                        -T HaplotypeCaller \
                        -R ${indexFile} \
                        --dbsnp ${dbSnp}\
			--BQSR ${sampleMergedBam}.recalibrated.table \
                        ${inputs} \
                        -dontUseSoftClippedBases \
                        -o "${tmpSampleBatchVariantCalls}" \
                        -L "${femaleCapturedBatchBed}" \
                        --emitRefConfidence GVCF \
                        -ploidy 2
        	elif [ "${sex}" == "Male" ]
		then
			java -Xmx12g -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -jar \
                        ${EBROOTGATK}/${gatkJar} \
                        -T HaplotypeCaller \
                        -R ${indexFile} \
                        --dbsnp ${dbSnp} \
			--BQSR ${sampleMergedBam}.recalibrated.table \
                        ${inputs} \
                        -dontUseSoftClippedBases \
                        -o "${tmpSampleBatchVariantCalls}" \
                        -L "${capturedBatchBed}" \
                        --emitRefConfidence GVCF \
                        -ploidy 2
		fi
	else
		echo "Autosomal"
		java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar \
                ${EBROOTGATK}/${gatkJar} \
                -T HaplotypeCaller \
                -R ${indexFile} \
                $inputs \
                -dontUseSoftClippedBases \
                --BQSR ${sampleMergedBam}.recalibrated.table \
                --dbsnp ${dbSnp} \
                -o "${tmpSampleBatchVariantCalls}" \
                -L "${capturedBatchBed}" \
		--emitRefConfidence GVCF \
                -ploidy 2
	fi

	echo -e "\nVariantCalling finished succesfull. Moving temp files to final.\n\n"
	if [ -f "${tmpSampleBatchVariantCalls}" ]
	then
        	mv "${tmpSampleBatchVariantCalls}" "${sampleBatchVariantCalls}"
        	mv "${tmpSampleBatchVariantCallsIndex}" "${sampleBatchVariantCallsIndex}"
			
		cp "${sampleBatchVariantCalls}" ${intermediateDir}/gVCF/
		cp "${sampleBatchVariantCallsIndex}" ${intermediateDir}/gVCF/
	else
		echo "ERROR: output file is missing"
		exit 1
	fi
fi

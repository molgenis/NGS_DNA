#MOLGENIS walltime=23:59:00 mem=14gb ppn=2

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string indexFile
#list sampleBatchVariantCalls
#string tmpDataDir
#string	project
#string logsDir 
#string groupname
#string tabixVersion
#string capturedBatchBed
#string projectJobsDir

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
${stage} ${tabixVersion}
${checkStage}

SAMPLESIZE=$(cat ${projectJobsDir}/${project}.csv | wc -l)
numberofbatches=$(($SAMPLESIZE / 200))
ALLGVCFs=()



if [ $SAMPLESIZE -gt 200 ]
then
    	for b in $(seq 0 $numberofbatches)
        do
          	if [ -f ${projectBatchCombinedVariantCalls}.$b ]
                then
                    	ALLGVCFs+=( ${projectBatchCombinedVariantCalls}.$b)
                fi
        done
else
    	for sbatch in "${sampleBatchVariantCalls[@]}"
        do
          	if [ -f $sbatch ]
                then
                    	array_contains ALLGVCFs "$sbatch" || ALLGVCFs+=("$sbatch")
                fi
        done
fi
count=${#ALLGVCFs[@]}
if [ $count -ne 0 ]
then
	mkdir -p ${intermediateDir}/gVCF/
	for i in ${ALLGVCFs[@]}
	do
		if [ -f $i ]
	        then
	                printf "bgzipping $i"
	                bgzip -c $i > $i.gz
	                printf "..done\ntabix-ing $i.gz .."
	                tabix -p vcf $i.gz	
       	         	printf "..done\n"
			echo "moving  $i.gz and matching index file to ${intermediateDir}/gVCF/"
			mv $i.gz ${intermediateDir}/gVCF/
			mv $i.gz.tbi ${intermediateDir}/gVCF/
			echo "done"
        	fi

	done
else
	echo "there are no batches to process, skipped"
fi

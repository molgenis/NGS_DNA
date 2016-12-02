#MOLGENIS walltime=02:00:00 mem=4gb queue=duo-ds

#list externalSampleID
#string intermediateDir
#string project
#string tmpName
#string logsDir

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

UNIQUESAMPLES=()
for samples in "${externalSampleID[@]}"
do
  	array_contains UNIQUESAMPLES "$samples" || UNIQUESAMPLES+=("$samples")    # If bamFile does not exist in array add it
done


echo "blaat"

for samp in ${UNIQUESAMPLES[@]}
do 
	rsync -rlD ${intermediateDir}/gVCF/new/${samp}*.g.vcf.gz /groups/umcg-gd/prm02/projects/5GPM_WGS/run01/results/alignment/gVCF/
	rsync -rlD ${intermediateDir}/gVCF/new/${samp}*.g.vcf.gz.tbi /groups/umcg-gd/prm02/projects/5GPM_WGS/run01/results/alignment/gVCF/
	
done


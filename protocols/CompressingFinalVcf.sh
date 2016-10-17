#MOLGENIS walltime=05:59:00 mem=6gb ppn=1

#list externalSampleID
#string tmpName
#string tabixVersion
#string stage
#string checkStage
#string logsDir 
#string groupname
#string	project
#string finalVcf

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

#Load Tabix module
${stage} ${tabixVersion}
${checkStage}

INPUTS=()
for SampleID in "${finalVcf}"
do
        array_contains INPUTS "$SampleID" || INPUTS+=("$SampleID")    # If bamFile does not exist in array add it
done

for i in ${INPUTS[@]}
do
	if [ -f $i ]
        then
        	printf "bgzipping $i"
        	bgzip -c $i > $i.gz
        	printf "..done\ntabix-ing $i.gz .."
        	tabix -p vcf $i.gz
        	printf "..done\n"
        	echo "done"
        fi
done

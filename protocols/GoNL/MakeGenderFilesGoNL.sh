#MOLGENIS ppn=4 mem=8gb walltime=07:00:00

#Parameter mapping
#string logsDir

#string project
#string groupname
#string tmpName
#list externalSampleID
#string intermediateDir

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

INPUTS=()

bqsr="false"

for sample in "${externalSampleID[@]}"
do
	array_contains INPUTS "$sample" || INPUTS+=("$sample")    # If bamFile does not exist in array add it
done

for i in ${INPUTS[@]}
do
	 awk -v var="$i" -v var2="$intermediateDir" '{if ($2 == var){if ($5=="1"){print "M\nMale" > var2""$2".chosenSex.txt"}else{print "F\nFemale" > var2""$2".chosenSex.txt"}}}' ${intermediateDir}/children.ped
done


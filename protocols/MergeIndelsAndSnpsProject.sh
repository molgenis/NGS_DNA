#list externalSampleID
#string tmpName
#string gatkVersion
#string gatkJar
#string indexFile


#string projectPrefix
#string logsDir 
#string groupname
#string intermediateDir
^#string project

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

#Load GATK module
module load "${gatkVersion}"
module list

INPUTS=()
for externalID in "${externalSampleID[@]}"
do
        array_contains INPUTS "--variant ${intermediateDir}/${externalID}.final.vcf" || INPUTS+=("--variant ${intermediateDir}/${externalID}.final.vcf")    # If bamFile does not exist in array add it
done

#merge all samples into one big vcf
java -Xmx2g -jar "${EBROOTGATK}/${gatkJar}" \
-R "${indexFile}" \
-T CombineVariants \
${INPUTS[@]} \
-o "${projectPrefix}.final.vcf.tmp"

echo "moving ${projectPrefix}.final.vcf.tmp to ${projectPrefix}.final.vcf"
mv "${projectPrefix}.final.vcf.tmp" "${projectPrefix}.final.vcf"


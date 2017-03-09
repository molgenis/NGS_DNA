#MOLGENIS walltime=23:59:00 mem=6gb ppn=8

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string project
#string logsDir 
#string groupname
#string dedupBam
#string externalSampleID
sleep 5

${stage} ${verifyBamIDVersion}
${checkStage}

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

#Create string with input BAM files for Picard
#This check needs to be performed because Compute generates duplicate values in array
INPUTS=()

#for externalID in "${externalSampleID[@]}"
#do
#  	array_contains INPUTS "$externalID" || INPUTS+=("$externalID")    # If bamFile does not exist in array add it
#done

verifyBamID \
--vcf ${intermediateDir}/${externalSampleID}.final.vcf \
--bam ${dedupBam} \
--out ${intermediateDir}/verifyBamID.output \
--verbose \
--ignoreRG



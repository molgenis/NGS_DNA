#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string gatkVersion
#string indexFile
#string capturedBed
#string capturingKit
#string xhmmDir
#string xhmmDepthOfCoverage
#string dedupBam
#string intermediateDir
#string DepthOfCoveragePerSample

module load GATK/3.6-Java-1.8.0_74

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

makeTmpDir ${xhmmDir}
tmpXhmmDir=${MC_tmpFile}

for bamFile in "${dedupBam[@]}"
do
        array_contains INPUTS "$bamFile" || INPUTS+=("$bamFile")    # If bamFile does not exist in array add it
        array_contains INPUTBAMS "$bamFile" || INPUTBAMS+=("$bamFile")    # If bamFile does not exist in array add it
done

## Creating bams directory
mkdir -p ${xhmmDepthOfCoverage}

## write capturingkit to file to make it easier to split
echo $capturingKit > ${intermediateDir}/capt.txt
CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)

rm -f ${xhmmDir}/${CAPT}.READS.bam.list

for i in ${INPUTS[@]}
do
        echo "$i" >> ${xhmmDir}/${CAPT}.READS.bam.list
done

sID=$(basename $dedupBam)
sampleID=${sID%%.*}

java -Xmx3072m -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
-T DepthOfCoverage \
-I ${xhmmDir}/${CAPT}.READS.bam.list \
-L ${capturedBed} \
-R ${indexFile} \
-dt BY_SAMPLE -dcov 5000 -l INFO --omitDepthOutputAtEachBase --omitLocusTable \
--minBaseQuality 0 --minMappingQuality 20 --start 1 --stop 5000 --nBins 200 \
--includeRefNSites \
--countType COUNT_FRAGMENTS \
-o ${DepthOfCoveragePerSample}.${CAPT}


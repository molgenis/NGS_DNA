#MOLGENIS walltime=23:59:00 mem=13gb

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string indexFile
#string indexFileFastaIndex
#string capturedIntervals
#string logsDir 
#string groupname
#string project

#list externalSampleID
#string tmpDataDir
#string sortVCFpl
#string gatkVersion
#string gatkJar
#string javaVersion
#string dbSNPDir

#string projectBatchGenotypedVariantCalls
#string projectBatchGenotypedVariantCallsAnnotated

sleep 5

makeTmpDir ${projectBatchGenotypedVariantCallsAnnotated}
tmpProjectBatchGenotypedVariantCallsAnnotated=${MC_tmpFile}

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

for externalID in "${externalSampleID[@]}"
do
        array_contains SAMPLES "$externalID" || SAMPLES+=("$externalID")    # If bamFile does not exist in array add it
done

for sample in "${SAMPLES[@]}"
do
	echo "sample: ${sample}"		
  	INPUTS+=("-I ${intermediateDir}/${sample}.merged.dedup.bam")
done

#Load GATK module
${stage} ${javaVersion}
${stage} ${gatkVersion}
${stage} ngs-utils

${checkStage}

java -XX:ParallelGCThreads=4 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar \
${EBROOTGATK}/${gatkJar} \
-T VariantAnnotator \
-R ${indexFile} \
${INPUTS[@]} \
-A AlleleBalance \
-A BaseCounts \
-A BaseQualityRankSumTest \
-A ChromosomeCounts \
-A Coverage \
-A FisherStrand \
-A LikelihoodRankSumTest \
-A MappingQualityRankSumTest \
-A MappingQualityZeroBySample \
-A ReadPosRankSumTest \
-A RMSMappingQuality \
-A QualByDepth \
-A VariantType \
-A AlleleBalanceBySample \
-A DepthPerAlleleBySample \
-A SpanningDeletions \
--disable_auto_index_creation_and_locking_when_reading_rods \
-D ${dbSNPDir}/dbsnp_137.b37.vcf \
--variant ${projectBatchGenotypedVariantCalls} \
-L ${projectBatchGenotypedVariantCalls} \
-o ${tmpProjectBatchGenotypedVariantCallsAnnotated}

mv ${tmpProjectBatchGenotypedVariantCallsAnnotated} ${projectBatchGenotypedVariantCallsAnnotated}
echo "mv ${tmpProjectBatchGenotypedVariantCallsAnnotated} ${projectBatchGenotypedVariantCallsAnnotated}"


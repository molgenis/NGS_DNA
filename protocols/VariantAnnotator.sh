#MOLGENIS walltime=23:59:00 mem=18gb

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

#string projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated
#string projectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated

sleep 5

makeTmpDir ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated}
tmpProjectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated=${MC_tmpFile}

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

perl -i -wpe 'my @t = split("\t",$_);$t[7] =~ s/ /_/g if ($t[7]);$t[7] =~ s/;$//g if ($t[7]);$_ = join("\t",@t)' ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated}

${checkStage}
if [ -f ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated} ]
then
java -XX:ParallelGCThreads=4 -Djava.io.tmpdir=${tempDir} -Xmx16g -jar \
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
-A SnpEff \
-A VariantType \
-A AlleleBalanceBySample \
-A DepthPerAlleleBySample \
-A SpanningDeletions \
--disable_auto_index_creation_and_locking_when_reading_rods \
-D ${dbSNPDir}/dbsnp_137.b37.vcf \
--variant ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated} \
--snpEffFile ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated} \
-L ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated} \
-o ${tmpProjectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated}

mv ${tmpProjectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated} ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated}
echo "mv ${tmpProjectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated} ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_GATK_Annotated}"

else
	echo "batch not available, skipped"
fi

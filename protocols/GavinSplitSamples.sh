#MOLGENIS walltime=05:59:00 mem=6gb ppn=2

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string intermediateDir
#string project
#string logsDir
#string groupname
#string gatkVersion
#string gatkJar
#string indexFile
#string capturedIntervals
#string projectVariantsMerged
#string externalSampleID
#string sampleVariantsMergedGavin

module load ${gatkVersion}

makeTmpDir ${sampleVariantsMergedGavin}
tmpSampleVariantsMergedGavin=${MC_tmpFile}

#select only Indels
java -XX:ParallelGCThreads=2 -Xmx4g -jar ${EBROOTGATK}/${gatkJar} \
-R ${indexFile} \
-T SelectVariants \
--variant ${projectVariantsMerged} \
-o ${tmpSampleVariantsMergedGavin} \
-L ${capturedIntervals} \
-sn ${externalSampleID}

mv ${tmpSampleVariantsMergedGavin} ${sampleVariantsMergedGavin}
echo "moved ${tmpSampleVariantsMergedGavin} to ${sampleVariantsMergedGavin}"

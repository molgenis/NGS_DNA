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
#string projectVariantsMergedSorted
#string projectVariantsMergedSnpsVcf
#string projectVariantsMergedIndelsVcf
#string externalSampleID

module load ${gatkVersion}

makeTmpDir ${projectVariantsMergedIndelsVcf}
tmpProjectVariantsMergedIndelsVcf=${MC_tmpFile}

makeTmpDir ${projectVariantsMergedSnpsVcf}
tmpProjectVariantsMergedSnpsVcf=${MC_tmpFile}

sleep 5

#select only Indels
java -XX:ParallelGCThreads=2 -Xmx4g -jar ${EBROOTGATK}/${gatkJar} \
-R ${indexFile} \
-T SelectVariants \
--variant ${projectVariantsMergedSorted} \
-o ${tmpProjectVariantsMergedIndelsVcf} \
-L ${capturedIntervals} \
--selectTypeToInclude INDEL \
-sn ${externalSampleID}

mv ${tmpProjectVariantsMergedIndelsVcf} ${projectVariantsMergedIndelsVcf}
echo "moved ${tmpProjectVariantsMergedIndelsVcf} to ${projectVariantsMergedIndelsVcf}"

sleep 5

#Select SNPs and MNPs
java -XX:ParallelGCThreads=2 -Xmx4g -jar ${EBROOTGATK}/${gatkJar} \
-R ${indexFile} \
-T SelectVariants \
--variant ${projectVariantsMergedSorted} \
-o ${tmpProjectVariantsMergedSnpsVcf} \
-L ${capturedIntervals} \
--selectTypeToExclude INDEL \
-sn ${externalSampleID}

mv ${tmpProjectVariantsMergedSnpsVcf} ${projectVariantsMergedSnpsVcf}
echo "moved ${tmpProjectVariantsMergedSnpsVcf} to ${projectVariantsMergedSnpsVcf}"

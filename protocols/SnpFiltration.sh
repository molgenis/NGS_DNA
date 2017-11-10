#MOLGENIS walltime=05:59:00 mem=10gb

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string projectVariantsMergedSnpsVcf
#string projectVariantsMergedSnpsFilteredVcf
#string tmpDataDir
#string project
#string logsDir
#string groupname
#string stage

#Load GATK module
${stage} "${gatkVersion}"

makeTmpDir "${projectVariantsMergedSnpsFilteredVcf}"
tmpProjectVariantsMergedSnpsFilteredVcf="${MC_tmpFile}"

#Run GATK VariantFiltration to filter called SNPs on

java -XX:ParallelGCThreads=4 -Djava.io.tmpdir="${tempDir}" -Xmx8g -Xms6g -jar "${EBROOTGATK}/${gatkJar}" \
-T VariantFiltration \
-R "${indexFile}" \
-o "${tmpProjectVariantsMergedSnpsFilteredVcf}" \
--variant "${projectVariantsMergedSnpsVcf}" \
--filterExpression "QD < 2.0" \
--filterName "filterQD" \
--filterExpression "MQ < 25.0" \
--filterName "filterMQ" \
--filterExpression "FS > 60.0" \
--filterName "filterFS" \
--filterExpression "MQRankSum < -12.5" \
--filterName "filterMQRankSum" \
--filterExpression "ReadPosRankSum < -8.0" \
--filterName "filterReadPosRankSum"

mv "${tmpProjectVariantsMergedSnpsFilteredVcf}" "${projectVariantsMergedSnpsFilteredVcf}"
echo "moved ${tmpProjectVariantsMergedSnpsFilteredVcf} ${projectVariantsMergedSnpsFilteredVcf}"

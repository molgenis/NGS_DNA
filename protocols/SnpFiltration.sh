#Parameter mapping
#string tmpName


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


#Load GATK module
module load "${gatkVersion}"

makeTmpDir "${projectVariantsMergedSnpsFilteredVcf}"
tmpProjectVariantsMergedSnpsFilteredVcf="${MC_tmpFile}"

#Run GATK VariantFiltration to filter called SNPs on

java -XX:ParallelGCThreads=1 -Djava.io.tmpdir="${tempDir}" -Xmx4g -jar "${EBROOTGATK}/${gatkJar}" \
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

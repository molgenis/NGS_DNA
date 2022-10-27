#Parameter mapping
#string tmpName
#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string sampleVariantsMergedSnpsVcf
#string sampleVariantsMergedSnpsFilteredVcf
#string tmpDataDir
#string project
#string logsDir
#string groupname


#Load GATK module
module load "${gatkVersion}"

makeTmpDir "${sampleVariantsMergedSnpsFilteredVcf}"
tmpSampleVariantsMergedSnpsFilteredVcf="${MC_tmpFile}"

#Run GATK VariantFiltration to filter called SNPs on

java -XX:ParallelGCThreads=1 -Djava.io.tmpdir="${tempDir}" -Xmx4g -jar "${EBROOTGATK}/${gatkJar}" \
-T VariantFiltration \
-R "${indexFile}" \
-o "${tmpSampleVariantsMergedSnpsFilteredVcf}" \
--variant "${sampleVariantsMergedSnpsVcf}" \
--filterExpression "QD < 2.0" \
--filterName "filterQD_lt2.0" \
--filterExpression "MQ < 25.0" \
--filterName "filterMQ_lt25.0" \
--filterExpression "SOR > 3.0" \
--filterName "filterSOR_gt3.0" \
--filterExpression "MQRankSum < -12.5" \
--filterName "filterMQRankSum_lt-12.5" \
--filterExpression "ReadPosRankSum < -8.0" \
--filterName "filterReadPosRankSum_lt-8.0"

mv -v "${tmpSampleVariantsMergedSnpsFilteredVcf}" "${sampleVariantsMergedSnpsFilteredVcf}"

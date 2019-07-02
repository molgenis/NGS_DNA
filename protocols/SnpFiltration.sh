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
gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx4g" VariantFiltration \
-R "${indexFile}" \
-O "${tmpSampleVariantsMergedSnpsFilteredVcf}" \
-V "${sampleVariantsMergedSnpsVcf}" \
--filter-name "filterQD_lt2.0" \
--filter-expression "QD < 2.0" \
--filter-name "filterMQ_lt40.0" \
--filter-expression "MQ < 40.0" \
--filter-name "filterSOR_gt3.0" \
--filter-expression "SOR > 3.0" \
--filter-name "filterMQRankSum_lt-12.5" \
--filter-expression "MQRankSum < -12.5" \
--filter-name "filterReadPosRankSum_lt-8.0" \
--filter-expression "ReadPosRankSum < -8.0"

mv "${tmpSampleVariantsMergedSnpsFilteredVcf}" "${sampleVariantsMergedSnpsFilteredVcf}"
echo "moved ${tmpSampleVariantsMergedSnpsFilteredVcf} ${sampleVariantsMergedSnpsFilteredVcf}"

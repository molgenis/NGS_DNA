#Parameter mapping
#string tmpName


#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string sampleVariantsMergedIndelsVcf
#string sampleVariantsMergedIndelsFilteredVcf
#string tmpDataDir
#string project
#string logsDir
#string groupname


#Load GATK module
module load "${gatkVersion}"

makeTmpDir "${sampleVariantsMergedIndelsFilteredVcf}"
tmpSampleVariantsMergedIndelsFilteredVcf="${MC_tmpFile}"

#Run GATK VariantFiltration to filter called Indels on
gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx4g" VariantFiltration \
-R "${indexFile}" \
-O "${tmpSampleVariantsMergedIndelsFilteredVcf}" \
-V "${sampleVariantsMergedIndelsVcf}" \
--filter-name "filterQD" \
--filter-expression "QD < 2.0" \
--filter-name "filterSOR_gt10.0" \
--filter-expression "SOR > 10.0" \
--filter-name "filterReadPosRankSum" \
--filter-expression "ReadPosRankSum < -20.0"

mv "${tmpSampleVariantsMergedIndelsFilteredVcf}" "${sampleVariantsMergedIndelsFilteredVcf}"
echo " moved ${tmpSampleVariantsMergedIndelsFilteredVcf} ${sampleVariantsMergedIndelsFilteredVcf}"

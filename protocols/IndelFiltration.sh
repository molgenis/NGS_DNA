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

java -XX:ParallelGCThreads=1 -Djava.io.tmpdir="${tempDir}" -Xmx4g -jar "${EBROOTGATK}/${gatkJar}" \
-T VariantFiltration \
-R "${indexFile}" \
-o "${tmpSampleVariantsMergedIndelsFilteredVcf}" \
--variant "${sampleVariantsMergedIndelsVcf}" \
--filterExpression "QD < 2.0" \
--filterName "filterQD" \
--filterExpression "SOR > 10.0" \
--filterName "filterSOR_gt10.0" \
--filterExpression "ReadPosRankSum < -20.0" \
--filterName "filterReadPosRankSum"

mv -v "${tmpSampleVariantsMergedIndelsFilteredVcf}" "${sampleVariantsMergedIndelsFilteredVcf}"

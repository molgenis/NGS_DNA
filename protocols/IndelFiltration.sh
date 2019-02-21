#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string projectVariantsMergedIndelsVcf
#string projectVariantsMergedIndelsFilteredVcf
#string tmpDataDir
#string project
#string logsDir
#string groupname
#string stage

#Load GATK module
${stage} "${gatkVersion}"

makeTmpDir "${projectVariantsMergedIndelsFilteredVcf}"
tmpProjectVariantsMergedIndelsFilteredVcf="${MC_tmpFile}"

#Run GATK VariantFiltration to filter called Indels on

java -XX:ParallelGCThreads=1 -Djava.io.tmpdir="${tempDir}" -Xmx4g -jar "${EBROOTGATK}/${gatkJar}" \
-T VariantFiltration \
-R "${indexFile}" \
-o "${tmpProjectVariantsMergedIndelsFilteredVcf}" \
--variant "${projectVariantsMergedIndelsVcf}" \
--filterExpression "QD < 2.0" \
--filterName "filterQD" \
--filterExpression "FS > 200.0" \
--filterName "filterFS" \
--filterExpression "ReadPosRankSum < -20.0" \
--filterName "filterReadPosRankSum"

mv "${tmpProjectVariantsMergedIndelsFilteredVcf}" "${projectVariantsMergedIndelsFilteredVcf}"
echo " moved ${tmpProjectVariantsMergedIndelsFilteredVcf} ${projectVariantsMergedIndelsFilteredVcf}"

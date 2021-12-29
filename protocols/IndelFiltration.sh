#Parameter mapping
#string tmpName


#string gatkVersion
#string tempDir
#string intermediateDir
#string indexFile

#string projectVariantsIndelsOnlyVcf
#string projectVariantsIndelsOnlyFilteredVcf

#string tmpDataDir
#string project
#string logsDir
#string groupname


#Load GATK module
module load "${gatkVersion}"

makeTmpDir "${projectVariantsIndelsOnlyFilteredVcf}"
tmpProjectVariantsIndelsOnlyFilteredVcf="${MC_tmpFile}"

#Run GATK VariantFiltration to filter called Indels on
gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx4g" VariantFiltration \
--reference="${indexFile}" \
--output="${tmpProjectVariantsIndelsOnlyFilteredVcf}" \
--variant="${projectVariantsIndelsOnlyVcf}" \
--filter-name="filterQD" \
--filter-expression="QD < 2.0" \
--filter-name="filterSOR_gt10.0" \
--filter-expression="SOR > 10.0" \
--filter-name="filterReadPosRankSum" \
--filter-expression="ReadPosRankSum < -20.0"

mv "${tmpProjectVariantsIndelsOnlyFilteredVcf}" "${projectVariantsIndelsOnlyFilteredVcf}"
echo " moved ${tmpProjectVariantsIndelsOnlyFilteredVcf} ${projectVariantsIndelsOnlyFilteredVcf}"

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
#string projectVariantsMergedIndelsVcf
#string projectVariantsMergedIndelsFilteredVcf
#string tmpDataDir
#string project
#string logsDir
#string groupname

sleep 5
}

#Load GATK module
module load  ${gatkVersion}

makeTmpDir ${projectVariantsMergedIndelsFilteredVcf}
tmpProjectVariantsMergedIndelsFilteredVcf=${MC_tmpFile}

#Run GATK VariantFiltration to filter called Indels on

java -XX:ParallelGCThreads=4 -Djava.io.tmpdir=${tempDir} -Xmx8g -Xms6g -jar ${EBROOTGATK}/${gatkJar} \
-T VariantFiltration \
-R ${indexFile} \
-o ${tmpProjectVariantsMergedIndelsFilteredVcf} \
--variant ${projectVariantsMergedIndelsVcf} \
--filterExpression "QD < 2.0" \
--filterName "filterQD" \
--filterExpression "FS > 200.0" \
--filterName "filterFS" \
--filterExpression "ReadPosRankSum < -20.0" \
--filterName "filterReadPosRankSum"

echo -e "\nVariantFiltering finished succesfull. Moving temp files to final.\n\n"
mv ${tmpProjectVariantsMergedIndelsFilteredVcf} ${projectVariantsMergedIndelsFilteredVcf}

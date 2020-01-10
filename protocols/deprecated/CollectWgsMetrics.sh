#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string picardVersion
#string dedupBam
#string indexFile
#string tempDir
#string picardJar
#string gcBiasMetrics
^#string project
#string logsDir 
#string groupname
#string intermediateDir

#string wgsMetrics

#Load Picard module
${stage} "${picardVersion}"
${checkStage}

makeTmpDir "${wgsMetrics}" "${intermediateDir}"
tmpWgsMetrics="${MC_tmpFile}"

#Run Picard GcBiasMetrics
java -XX:ParallelGCThreads=2 -jar -Xmx4g "${EBROOTPICARD}/${picardJar}" CollectWgsMetrics \
R="${indexFile}" \
I="${dedupBam}" \
O="${tmpWgsMetrics}" \
TMP_DIR="${tempDir}"

echo -e "\nWgsMetrics finished succesfull. Moving temp files to final.\n\n"
mv "${tmpWgsMetrics}" "${wgsMetrics}"



#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string picardVersion
#string bamIndexStatsJar
#string dedupBam
#string dedupBamIdx
#string tempDir
#string capturingKit
#string picardJar
#string bamIndexStats
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load Picard module
${stage} "${picardVersion}"

makeTmpDir "${bamIndexStats}" "${intermediateDir}"
tmpBamIndexStats="${MC_tmpFile}"


#Run Picard BamIndexStats
java -jar -Xmx3g -XX:ParallelGCThreads=1 "${EBROOTPICARD}/${picardJar}" "${bamIndexStatsJar}" \
INPUT="${dedupBam}" \
VALIDATION_STRINGENCY=LENIENT \
TMP_DIR="${tempDir}" \
> "${tmpBamIndexStats}"

mv "${tmpBamIndexStats}" "${bamIndexStats}"
echo "moved ${tmpBamIndexStats} to ${bamIndexStats}"


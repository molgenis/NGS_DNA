
#Parameter mapping
#string tmpName


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
#string gatkVersion

#Load Picard module
module load "${gatkVersion}"
module list

makeTmpDir "${bamIndexStats}" "${intermediateDir}"
tmpBamIndexStats="${MC_tmpFile}"


#Run Picard BamIndexStats
gatk --java-options "-Xmx3g -XX:ParallelGCThreads=1" BamIndexStats \
--INPUT="${dedupBam}" \
--VALIDATION_STRINGENCY=LENIENT \
--TMP_DIR="${tempDir}" \
> "${tmpBamIndexStats}"

mv "${tmpBamIndexStats}" "${bamIndexStats}"
echo "moved ${tmpBamIndexStats} to ${bamIndexStats}"


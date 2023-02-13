set -o pipefail
#Parameter mapping
#string tmpName
#string gatkVersion
#string dedupBam
#string tempDir
#string bamIndexStats
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load gatk module
module load "${gatkVersion}"
module list

makeTmpDir "${bamIndexStats}" "${intermediateDir}"
tmpBamIndexStats="${MC_tmpFile}"

gatk --java-options "-Xmx3g -XX:ParallelGCThreads=1" BamIndexStats \
-I "${dedupBam}" \
--VALIDATION_STRINGENCY LENIENT \
--TMP_DIR "${tempDir}" \
> "${tmpBamIndexStats}"

mv -v "${tmpBamIndexStats}" "${bamIndexStats}"


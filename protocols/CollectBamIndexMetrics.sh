#MOLGENIS walltime=05:59:00 mem=6gb ppn=6


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

#Load Picard module
${stage} "${picardVersion}"

makeTmpDir "${bamIndexStats}"
tmpBamIndexStats="${MC_tmpFile}"


#Run Picard BamIndexStats
java -jar -Xmx4g "${EBROOTPICARD}/${picardJar}" "${bamIndexStatsJar}" \
INPUT="${dedupBam}" \
VALIDATION_STRINGENCY=LENIENT \
TMP_DIR="${tempDir}" \
> "${tmpBamIndexStats}"

mv "${tmpBamIndexStats}" "${bamIndexStats}"
echo "moved ${tmpBamIndexStats} to ${bamIndexStats}"


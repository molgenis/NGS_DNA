#MOLGENIS walltime=23:59:00 mem=10gb 

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string picardVersion
#string picardJar
#string samToBamJar
#string alignedSam
#string tempDir
#string intermediateDir
#string dedupBam
#string tmpDataDir
#string project
#string logsDir 
#string groupname

#Load Picard module
"${stage}" "${picardVersion}"
"${checkStage}"

makeTmpDir "${alignedBam}"
tmpAlignedBam="${MC_tmpFile}"

#Run picard, convert SAM to BAM
java -XX:ParallelGCThreads=4 -jar -Xmx9g "${EBROOTPICARD}/${picardJar}" WgsMetrics \
INPUT="${dedupBam}" \
OUTPUT="${dedupBam}.wgsmetrics" \
VALIDATION_STRINGENCY=LENIENT \
MAX_RECORDS_IN_RAM=2000000 \
TMP_DIR="${tempDir}"

echo -e "\nSamToBam finished succesfull. Moving temp files to final.\n\n"
mv "${tmpAlignedBam}" "${alignedBam}"



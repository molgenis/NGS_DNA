#Parameter mapping
#string groupname
#string tmpName
#string tmpDataDir
#string tempDir
#string intermediateDir
#string projectResultsDir
#string logsDir

#string gatkVersion
#string indexFile

#string project

#string externalSampleID
#string dedupBam

#string mergedBamRecalibratedTable
#string sampleMergedRecalibratedBam


#Load GATK module.
module load "${gatkVersion}"
module list

# Make a tmp folder for this step, which will be the output location.
makeTmpDir "${sampleMergedRecalibratedBam}" "${intermediateDir}"
tmpSampleMergedRecalibratedBam="${MC_tmpFile}"

# Create the list of BAM files for input
mapfile -t bams < <(printf '%s\n' "${dedupBam[@]}" | sort -u )
inputs=$(printf -- '--input %s ' "$(printf '%s\n' "${bams[@]}")")

# shellcheck disable=SC2086 #${inputs} => gatk needs seperate strings, not one captured in quotes
gatk --java-options "-XX:ParallelGCThreads=1 -Djava.io.tmpdir=${tempDir} -Xmx9g" ApplyBQSR \
-R "${indexFile}" \
${inputs} \
--bqsr-recal-file "${mergedBamRecalibratedTable}" \
-O "${tmpSampleMergedRecalibratedBam}"

mv "${tmpSampleMergedRecalibratedBam}" "${sampleMergedRecalibratedBam}"
mv "${tmpSampleMergedRecalibratedBam%.bam}.bai" "${sampleMergedRecalibratedBam%.bam}.bai"
echo "moved ${tmpSampleMergedRecalibratedBam}  ${sampleMergedRecalibratedBam}"

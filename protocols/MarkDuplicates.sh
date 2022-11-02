#Parameter mapping
#string tmpName
#string externalSampleID
#string sampleProcessStepID
#string sampleMergedBam
#string sampleMergedBamIdx
#string tempDir
#string dedupBam
#string dedupBamIdx
#string tmpDataDir
#string sambambaVersion
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string flagstatMetrics

#Load sambamba module
module load "${sambambaVersion}"
module list

makeTmpDir "${dedupBam}" "${intermediateDir}"
tmpDedupBam="${MC_tmpFile}"

makeTmpDir "${dedupBamIdx}" "${intermediateDir}"
tmpDedupBamIdx="${MC_tmpFile}"

echo  "${externalSampleID}" > "${intermediateDir}/${externalSampleID}.txt"

##Run picard, sort BAM file and create index on the fly
sambamba markdup \
--nthreads=4 \
--overflow-list-size 1000000 \
--hash-table-size 1000000 \
-p \
--tmpdir="${tempDir}" \
"${sampleMergedBam}" "${tmpDedupBam}"

echo -e "\nMarkDuplicates finished succesfull. Moving temp files to final.\n\n"
mv -v "${tmpDedupBam}" "${dedupBam}"
mv -v "${tmpDedupBamIdx}" "${dedupBamIdx}"

echo "making symlinks of the bams in the results folder to ${intermediateDir} for later use"
cd "${intermediateDir}" 

ln -sf "${dedupBam}"
ln -sf "${dedupBamIdx}"

cd -

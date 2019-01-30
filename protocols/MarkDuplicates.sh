#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string sampleMergedBam
#string sampleMergedBamIdx
#string tempDir
#string dedupBam
#string dedupBamIdx
#string tmpDataDir
#string picardJar
#string sambambaVersion
#string sambambaTool
#string	project
#string logsDir 
#string groupname
#string intermediateDir
#string flagstatMetrics

#Load Picard module
${stage} "${sambambaVersion}"
${checkStage}

makeTmpDir "${dedupBam}" "${intermediateDir}"
tmpDedupBam="${MC_tmpFile}"

makeTmpDir "${dedupBamIdx}" "${intermediateDir}"
tmpDedupBamIdx="${MC_tmpFile}"

##Run picard, sort BAM file and create index on the fly
"${sambambaTool}" markdup \
--nthreads=4 \
--overflow-list-size 1000000 \
--hash-table-size 1000000 \
-p \
--tmpdir="${tempDir}" \
"${sampleMergedBam}" "${tmpDedupBam}"

echo -e "\nMarkDuplicates finished succesfull. Moving temp files to final.\n\n"
mv "${tmpDedupBam}" "${dedupBam}"
echo "moved ${tmpDedupBam} ${dedupBam}"
mv "${tmpDedupBamIdx}" "${dedupBamIdx}"
echo "mv ${tmpDedupBamIdx} ${dedupBamIdx}"

echo "making symlinks of the bams in the results folder to ${intermediateDir} for later use"
cd "${intermediateDir}" 

ln -sf "${dedupBam}"
ln -sf "${dedupBamIdx}"

cd -

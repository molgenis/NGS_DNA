#Parameter mapping
#string tmpName


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

#Load Sambamba module
module load "${sambambaVersion}"
module list

makeTmpDir "${dedupBam}" "${intermediateDir}"
tmpDedupBam="${MC_tmpFile}"

makeTmpDir "${dedupBamIdx}" "${intermediateDir}"
tmpDedupBamIdx="${MC_tmpFile}"

##Run Sambamba, sort BAM file and create index on the fly
sambamba markdup \
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
cd "${intermediateDir}" || exit

ln -sf "${dedupBam}" .
ln -sf "${dedupBamIdx}" .

cd - || exit

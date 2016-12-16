#MOLGENIS walltime=16:00:00 mem=30gb ppn=5

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
#string flagstatMetrics

#Load Picard module
${stage} ${sambambaVersion}
${checkStage}
sleep 5

makeTmpDir ${dedupBam}
tmpDedupBam=${MC_tmpFile}

makeTmpDir ${dedupBamIdx}
tmpDedupBamIdx=${MC_tmpFile}

##Run picard, sort BAM file and create index on the fly
${EBROOTSAMBAMBA}/${sambambaTool} markdup \
--nthreads=4 \
--overflow-list-size 1000000 \
--hash-table-size 1000000 \
-p \
--tmpdir=${tempDir} \
${sampleMergedBam} ${tmpDedupBam}

echo -e "\nMarkDuplicates finished succesfull. Moving temp files to final.\n\n"
mv ${tmpDedupBam} ${dedupBam}
echo "moved ${tmpDedupBam} ${dedupBam}"
mv ${tmpDedupBamIdx} ${dedupBamIdx}
echo "mv ${tmpDedupBamIdx} ${dedupBamIdx}"

#MOLGENIS walltime=03:00:00 mem=30gb ppn=5

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string dedupBam
#string tmpDataDir
#string sambambaVersion
#string sambambaTool
#string dedupMetrics
#string	project
#string logsDir 
#string groupname
#string flagstatMetrics

#Load Picard module
${stage} ${sambambaVersion}
${checkStage}
sleep 5

makeTmpDir ${flagstatMetrics}
tmpFlagstatMetrics=${MC_tmpFile}

makeTmpDir ${dedupMetrics}
tmpDedupMetrics=${MC_tmpFile}

echo "starting to calculate flagstat metrics"
#make metrics file
${EBROOTSAMBAMBA}/${sambambaTool} \
flagstat \
--nthreads=4 \
${dedupBam} > ${tmpFlagstatMetrics}

echo -e "\nFlagstatMetrics calculated. Moving temp files to final.\n\n"

mv ${tmpFlagstatMetrics} ${flagstatMetrics}

echo "moved ${tmpFlagstatMetrics} ${flagstatMetrics}"


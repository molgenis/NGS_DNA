#Parameter mapping
#string tmpName


#string tempDir
#string dedupBam
#string tmpDataDir
#string sambambaVersion
#string sambambaTool
#string" project
#string logsDir 
#string groupname
#string flagstatMetrics
#string intermediateDir

#Load Picard module
module load "${sambambaVersion}"
module list

makeTmpDir "${flagstatMetrics}" "${intermediateDir}"
tmpFlagstatMetrics="${MC_tmpFile}"

echo "starting to calculate flagstat metrics"
#make metrics file
"${sambambaTool}" \
flagstat \
--nthreads=4 \
"${dedupBam}" > "${tmpFlagstatMetrics}"

echo -e "\nFlagstatMetrics calculated. Moving temp files to final.\n\n"

mv "${tmpFlagstatMetrics}" "${flagstatMetrics}"

echo "moved ${tmpFlagstatMetrics} ${flagstatMetrics}"


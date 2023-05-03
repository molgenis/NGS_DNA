set -o pipefail
#Parameter mapping
#string tmpName
#string intermediateDir
#string project
#string logsDir
#string groupname
#string gatkVersion
#string indexFile
#string capturedIntervals
#string sampleVariantCallsSnpEff_Annotated
#string sampleSnpsOnlyVcf
#string sampleIndelsOnlyVcf

module purge
module load "${gatkVersion}"

makeTmpDir "${sampleSnpsOnlyVcf}"
tmpSampleSnpsOnlyVcf="${MC_tmpFile}"

makeTmpDir "${sampleIndelsOnlyVcf}"
tmpSampleIndelsOnlyVcf="${MC_tmpFile}"

#select only Indels
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${sampleVariantCallsSnpEff_Annotated}" \
-O "${tmpSampleIndelsOnlyVcf}" \
--select-type-to-include INDEL

mv -v "${tmpSampleIndelsOnlyVcf}" "${sampleIndelsOnlyVcf}"

#Select SNPs and MNPs
gatk --java-options "-XX:ParallelGCThreads=1 -Xmx5g" SelectVariants \
-R "${indexFile}" \
-V "${sampleVariantCallsSnpEff_Annotated}" \
-O "${tmpSampleSnpsOnlyVcf}" \
--select-type-to-exclude INDEL 

mv -v "${tmpSampleSnpsOnlyVcf}" "${sampleSnpsOnlyVcf}"

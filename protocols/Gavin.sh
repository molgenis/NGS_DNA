#MOLGENIS walltime=05:59:00 mem=6gb
#string tmpName
#Parameter mapping
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string project
#string logsDir
#string groupname
#string snpEffVersion
#string javaVersion
#string indexFile

#string gavinClinVar
#string gavinCGD
#string gavinFDR
#string gavinCalibrations
#string gavinOutputFirstPass
#string gavinOutputFinal
#string gavinToCADD
#string gavinFromCADD
#string gavinToCADDgz
#string gavinFromCADDgz
#string htsLibVersion
#string bcfToolsVersion

#string gavinJar
#string gavinOutputFinalMerged
#string gavinOutputFinalMergedRLV
#string sampleFinalVcf

#string gavinPlusVersion
#string gavinPlusJar
#string ngsUtilsVersion

makeTmpDir "${gavinOutputFinal}"
tmpGavinOutputFinal="${MC_tmpFile}"

${stage} "${htsLibVersion}"
${stage} "${gavinPlusVersion}"
${stage} "${bcfToolsVersion}"
${stage} "${ngsUtilsVersion}"

${checkStage}

touch "${intermediateDir}/emptyFile.tsv"

bcftools norm -f "${indexFile}" -m -any "${sampleFinalVcf}" > "${sampleFinalVcf}.splitPerAllele.vcf"

java -Xmx4g -jar "${EBROOTGAVINMINPLUS}/${gavinPlusJar}" \
-i "${sampleFinalVcf}.splitPerAllele.vcf" \
-o "${tmpGavinOutputFinal}" \
-m ANALYSIS \
-c "${intermediateDir}/emptyFile.tsv" \
-p "${gavinClinVar}" \
-d "${gavinCGD}" \
-f "${gavinFDR}" \
-g "${gavinCalibrations}" \
-k \
-s \
-q

echo "Gavin finished, now sorting the vcf"

sortVCFbyFai.pl -fastaIndexFile ${indexFile}.fai -inputVCF "${tmpGavinOutputFinal}" -outputVCF "${gavinOutputFinalMergedRLV}"


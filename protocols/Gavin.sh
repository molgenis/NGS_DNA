set -o pipefail
#string tmpName
#Parameter mapping


#string tempDir
#string intermediateDir
#string project
#string logsDir
#string groupname
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

#string gavinOutputFinalMerged
#string gavinOutputFinalMergedRLV
#string inputFile

#string gavinPlusVersion
#string gavinPlusJar
#string picardVersion
#string indexFileDictionary

makeTmpDir "${gavinOutputFinal}"
tmpGavinOutputFinal="${MC_tmpFile}"
module purge
module load "${htsLibVersion}"
module load "${gavinPlusVersion}"
module load "${bcfToolsVersion}"
module load "${picardVersion}"

touch "${intermediateDir}/emptyFile.tsv"

bcftools norm -f "${indexFile}" -m -any "${inputFile}" > "${inputFile}.splitPerAllele.vcf"

java -Xmx4g -jar "${EBROOTGAVINMINPLUS}/${gavinPlusJar}" \
-i "${inputFile}.splitPerAllele.vcf" \
-o "${tmpGavinOutputFinal}" \
-m ANALYSIS \
-c "${intermediateDir}/emptyFile.tsv" \
-p "${gavinClinVar}" \
-d "${gavinCGD}" \
-f "${gavinFDR}" \
-g "${gavinCalibrations}" \
-x \
-y \
-k \
-s \
-q BOTH

#echo "Gavin finished, now sorting the vcf"
java -jar "${EBROOTPICARD}/picard.jar" SortVcf \
-I "${tmpGavinOutputFinal}" \
-SD "${indexFileDictionary}" \
-O "${gavinOutputFinalMergedRLV}"

perl -pi -e 's|=""|="\\"|' "${gavinOutputFinalMergedRLV}"
#sortVCFbyFai.pl -fastaIndexFile "${indexFile}.fai" -inputVCF "${tmpGavinOutputFinal}" -outputVCF "${gavinOutputFinalMergedRLV}"
perl -pi -e 's|RLV=|;RLV=|'  "${gavinOutputFinalMergedRLV}"

printf '%s' "bgzipping ${gavinOutputFinalMergedRLV}"
bgzip -c "${gavinOutputFinalMergedRLV}" > "${gavinOutputFinalMergedRLV}.gz"
printf '%s' "..done\ntabix-ing ${gavinOutputFinalMergedRLV}.gz .."
tabix -p vcf "${gavinOutputFinalMergedRLV}.gz"
printf "..done\n"
echo "done"
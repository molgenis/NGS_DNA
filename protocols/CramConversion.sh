set -o pipefail
#string tmpName
#string dedupBam
#string indexFile
#string dedupBamCram
#string dedupBamCramIdx
#string dedupBamCramBam
#string indexFile
#string project
#string logsDir
#string groupname
#string intermediateDir
#string iolibVersion
#string samtoolsVersion

module load "${iolibVersion}"
module load "${samtoolsVersion}"
module list

makeTmpDir "${dedupBamCram}" "${intermediateDir}"
tmpDedupBamCram="${MC_tmpFile}"

makeTmpDir "${dedupBamCramIdx}" "${intermediateDir}"
tmpDedupBamCramIdx="${MC_tmpFile}"

echo "Starting scramble BAM to CRAM conversion"

scramble \
-I bam \
-O cram \
-r "${indexFile}" \
-P \
-m \
-t 8 \
"${dedupBam}" \
"${tmpDedupBamCram}"

echo "conversion completed, now indexing the cramfile"
cd "${MC_tmpFolder}" || exit
samtools index "${tmpDedupBamCram}"
echo "indexing completed, now starting to make a checksum"
md5sum "$(basename "${tmpDedupBamCram}")" > "$(basename "${tmpDedupBamCram}").md5"
cd - || exit

mv -v "${tmpDedupBamCram}" "${dedupBamCram}"
mv -v "${tmpDedupBamCramIdx}" "${dedupBamCramIdx}"
mv -v "${tmpDedupBamCram}.md5" "${dedupBamCram}.md5"

#To convert from CRAM -> BAM do:
#scramble \
#-I cram \
#-O bam \
#-r ${indexFile} \
#-m \
#-t 8 \
# ${tmpDedupBamCram} \
# ${tmpDedupBamCramBam}

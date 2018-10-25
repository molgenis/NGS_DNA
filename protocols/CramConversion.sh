#MOLGENIS walltime=05:59:00 mem=6gb ppn=9
#string tmpName
#string dedupBam
#string indexFile
#string dedupBamCram
#string dedupBamCramBam
#string indexFile
#string	project
#string logsDir
#string groupname
#string intermediateDir
#string iolibVersion
#string samtoolsVersion

module load "${iolibVersion}"
module load "${samtoolsVersion}"
module list

makeTmpDir "${dedupBamCram}"
tmpDedupBamCram="${MC_tmpFile}"

makeTmpDir "${dedupBamCramBam}"
tmpDedupBamCramBam="${MC_tmpFile}"

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


echo "dirname"
mv "${tmpDedupBamCram}" "${dedupBamCram}"
cd "${intermediateDir}"

samtools index "${dedupBamCram}"
md5sum $(basename "${dedupBamCram}") > $(basename "${dedupBamCram}").md5

cd -

#To convert from CRAM -> BAM do:
#scramble \
#-I cram \
#-O bam \
#-r ${indexFile} \
#-m \
#-t 8 \
# ${tmpDedupBamCram} \
# ${tmpDedupBamCramBam}

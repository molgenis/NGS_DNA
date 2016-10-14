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

module load ${iolibVersion}
module list

makeTmpDir ${dedupBamCram}
tmpDedupBamCram=${MC_tmpFile}

makeTmpDir ${dedupBamCramBam}
tmpDedupBamCramBam=${MC_tmpFile}

echo "Starting scramble BAM to CRAM conversion"

scramble \
-I bam \
-O cram \
-r ${indexFile} \
-m \
-t 8 \
${dedupBam} \
${tmpDedupBamCram}


echo "dirname"
mv ${tmpDedupBamCram} ${dedupBamCram}
cd ${intermediateDir}

md5sum $(basename ${dedupBamCram}) > $(basename ${dedupBamCram}).md5

cd -

#To convert from CRAM -> BAM do:
#scramble \
#-I cram \
#-O bam \
#-r ${indexFile} \
#-m \
#-t 8 \
#${tmpDedupBamCram} \
#${tmpDedupBamCramBam}

#MOLGENIS walltime=04:00:00 mem=20gb

#string tmpName
#string dedupBam
#string	project
#string tempDir
#string logsDir
#string groupname
#string bioPetVersion
#string bioPetJar
#string dedupBam
#string indexFile
#string intermediateDir

module load $bioPetVersion

makeTmpDir ${intermediateDir}
tmpIntermediateDir=${MC_tmpFile}

BAS=$(basename ${dedupBam})
NAME=${BAS%%.*}

java -jar -Xmx19g -Djava.io.tmpdir=${tempDir} ${EBROOTBIOPET}/${bioPetJar} \
tool BamStats \
-b ${dedupBam} \
-R ${indexFile} \
--tsvOutputs \
-o ${tmpIntermediateDir}

### Flagstat results
### Clipping information
### Mapping quality

cd ${tmpIntermediateDir}/
rename '' "${NAME}_" *

cd -

echo "moving ${tmpIntermediateDir}/ ${intermediateDir}"

mv ${tmpIntermediateDir}/* ${intermediateDir}


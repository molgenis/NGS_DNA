#MOLGENIS walltime=01:00:00 mem=4gb

#string tmpName
#string dedupBam
#string	project
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

java -jar ${EBROOTBIOPET}/${bioPetJar} \
tool BamStats \
-b ${dedupBam} \
-R ${indexFile} \
--tsvOutputs \
-o ${tmpIntermediateDir}

### Flagstat results
### Clipping information
### Mapping quality

"moving ${tmpIntermediateDir} ${intermediateDir}"

mv ${tmpIntermediateDir} ${intermediateDir}


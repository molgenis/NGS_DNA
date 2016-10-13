#MOLGENIS walltime=16:00:00 mem=30gb ppn=21
#string tmpName
#string project
#string logsDir
#string groupname
#string indexFile
#string intermediateDir
#string mantaVersion
#string dedupBam
#string mantaDir
#string mantaVersion
#string pythonVersion
#string GCC_Analysis

makeTmpDir ${mantaDir}
tmpMantaDir=${MC_tmpFile}


module load ${mantaVersion}
module load ${pythonVersion}

rm -rf ${mantaDir}

if [ "${GCC_Analysis}" == "diagnostiek" ] || [ "${GCC_Analysis}" == "diagnostics" ] || [ "${GCC_Analysis}" == "Diagnostiek" ] || [ "${GCC_Analysis}" == "Diagnostics" ]
then
    	echo "Manta is skipped"
else
	mkdir ${mantaDir}

	python ${EBROOTMANTA}/bin/configManta.py \
	--bam ${dedupBam} \
	--referenceFasta ${indexFile} \
	--runDir ${tmpMantaDir}

	python ${tmpMantaDir}/runWorkflow.py -m local -j 20

	mv ${tmpMantaDir}/* ${mantaDir} 
fi



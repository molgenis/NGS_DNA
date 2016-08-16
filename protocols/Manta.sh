#MOLGENIS walltime=120:00:00 mem=30gb ppn=25
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

if [ "${GCC_Analysis}" == "diagnostiek" ] || [ "${GCC_Analysis}" == "diagnostics" ] || [ "${GCC_Analysis}" == "Diagnostiek" ] || [ "${GCC_Analysis}" == "Diagnostics" ]
then
    	echo "Manta is skipped"
else
	if [ ! -d ${mantaDir} ]
	then	
		mkdir ${mantaDir}
	fi

	python ${EBROOTMANTA}/bin/configManta.py \
	--bam ${dedupBam} \
	--referenceFasta ${indexFile} \
	--runDir ${tmpMantaDir}
fi


python ${tmpMantaDir}/runWorkflow.py -m local -j 24

mv ${tmpMantaDir}/* ${mantaDir} 



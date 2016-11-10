\#MOLGENIS walltime=16:00:00 mem=30gb ppn=21
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
#string capturingKit

makeTmpDir ${mantaDir}
tmpMantaDir=${MC_tmpFile}


module load ${mantaVersion}
module load ${pythonVersion}

rm -rf ${mantaDir}

bedfile=$(basename $capturingKit)

if [[ "${bedfile}" == *"CARDIO_v"* || "${bedfile}" == *"DER_v"* || "${bedfile}" == *"DYS_v"* || "${bedfile}" == *"EPI_v"* \
|| "${bedfile}" == *"LEVER_v"* || "${bedfile}" == *"MYO_v"* || "${bedfile}" == *"NEURO_v"* || "${bedfile}" == *"ONCO_v"* \
|| "${bedfile}" == *"PCS_v"* || "${bedfile}" == *"TID_v"* ]]
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



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
#string capturingKit
#string capturedBed
#string bedToolsVersion
#string htsLibVersion
#string stage
#string checkStage
#string externalSampleID

${stage} ${mantaVersion}
${stage} ${pythonVersion}
${stage} ${htsLibVersion}

${checkStage}

rm -rf ${mantaDir}
mkdir  ${mantaDir}

makeTmpDir ${mantaDir}
tmpMantaDir=${MC_tmpFile}


bedfile=$(basename $capturingKit)
if [[ "${bedfile}" == *"Exoom"* || "${bedfile}" == *"wgs"* || "${bedfile}" == *"WGS"* || "${bedfile}" == *"All_Exon_v1"* ]] 
then
	## Exclude Manta_1 script when executing test project (PlatinumnSubset)
	SCRIPTNAME=$(basename $0)
	if [[ "${project}" == *"PlatinumSubset"* && ${SCRIPTNAME} == *Manta_1.sh* ]] 
	then
		echo "PlatinumSubset is executed, therefore this script will not run (need a fix in making PhiX reads, forward/reversed)"
		mv ${SCRIPTNAME}.{started,finished}
		touch ${SCRIPTNAME}.env
		script=${SCRIPTNAME%.*}
		chmod ugo+x ${script}.env 
		trap - EXIT
		exit 0
	fi

        bgzip -c "${capturedBed}" > "${tmpMantaDir}/capturedBed.bed.gz"
        tabix -p bed "${tmpMantaDir}/capturedBed.bed.gz"

	python ${EBROOTMANTA}/bin/configManta.py \
	--bam ${dedupBam} \
	--referenceFasta ${indexFile} \
	--exome \
	--runDir ${tmpMantaDir} \
	--callRegions "${tmpMantaDir}/capturedBed.bed.gz"


        python ${tmpMantaDir}/runWorkflow.py -m local -j 20

	mv "${tmpMantaDir}/"* "${mantaDir}/"

else
	echo "Manta is skipped"

fi

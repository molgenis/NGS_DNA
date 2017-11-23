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
#string ngsversion

${stage} "${ngsversion}"
${stage} "${mantaVersion}"
${stage} "${pythonVersion}"
${stage} "${htsLibVersion}"

${checkStage}

rm -rf "${mantaDir}"
mkdir -p "${mantaDir}"

makeTmpDir "${mantaDir}"
tmpMantaDir="${MC_tmpFile}"

bedfile=$(basename $capturingKit)
if [[ "${bedfile}" == *"wgs"* || "${bedfile}" == *"WGS"* ]]
then

	python "${EBROOTMANTA}/bin/configManta.py" \
	--bam "${dedupBam}" \
	--referenceFasta "${indexFile}" \
	--runDir "${tmpMantaDir}" 
else
	## Exclude Manta_1 script when executing test project (PlatinumnSubset)
	SCRIPTNAME=$(basename "${0}")
	if [[ "${project}" == *"PlatinumSubset"* && ${SCRIPTNAME} == *Manta_1.sh* ]] 
	then
		echo "PlatinumSubset is executed, therefore this script will not run (need a fix in making PhiX reads, forward/reversed)"
		mv "${SCRIPTNAME}".{started,finished}
		touch "${SCRIPTNAME}.env"
		script=${SCRIPTNAME%.*}
		chmod ugo+x "${script}.env"
		trap - EXIT
		exit 0
	fi

	python "${EBROOTMANTA}/bin/configManta.py" \
        --bam "${dedupBam}" \
        --referenceFasta "${indexFile}" \
        --exome \
	--config ${EBROOTNGS_DNA}/conf/configManta.py.ini \
        --runDir "${tmpMantaDir}" 

fi

## run Manta 
python "${tmpMantaDir}/runWorkflow.py" -m local -j 20

mv "${tmpMantaDir}/"* "${mantaDir}/"


mkdir -p ${mantaDir}/results/variants/real/

### If a capturingkit is used then only limit the output to those regions 
if [[ "${capturingKit}" != *"wgs"* ]]
then
	bedtools intersect -header -a ${mantaDir}/results/variants/candidateSmallIndels.vcf.gz -b ${capturedBed} >> ${mantaDir}/results/variants/real/candidateSmallIndels.vcf
	if [ -f ${mantaDir}/results/variants/real/candidateSmallIndels.vcf ]
        then
		bgzip -c ${mantaDir}/results/variants/real/candidateSmallIndels.vcf > ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz
		printf "..done\ntabix-ing ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz .."
		tabix -p vcf ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz
		printf "${mantaDir}/results/variants/real/candidateSmallIndels.vcf ..done\n"
	else
		echo "no candidateSmallIndels's left after filtering with the bedfile"
                touch ${mantaDir}/results/variants/real/NO_candidateSmallIndels 
	fi
	bedtools intersect -header -a${mantaDir}/results/variants/candidateSV.vcf.gz -b ${capturedBed} >> ${mantaDir}/results/variants/real/candidateSV.vcf
	if [ -f ${mantaDir}/results/variants/real/candidateSV.vcf ]
	then
		bgzip -c ${mantaDir}/results/variants/real/candidateSV.vcf > ${mantaDir}/results/variants/real/candidateSV.vcf.gz
		printf "..done\ntabix-ing ${mantaDir}/results/variants/real/candidateSV.vcf.gz .."
		tabix -p vcf ${mantaDir}/results/variants/real/candidateSV.vcf.gz
		printf "${mantaDir}/results/variants/real/candidateSV.vcf ..done\n"
	else
		echo "no candidateSV's left after filtering with the bedfile"
		touch ${mantaDir}/results/variants/real/NO_candidateSV
	fi

	bedtools intersect -header -a ${mantaDir}/results/variants/diploidSV.vcf.gz -b ${capturedBed} >> ${mantaDir}/results/variants/real/diploidSV.vcf
	if [ -f ${mantaDir}/results/variants/real/diploidSV.vcf ]
        then
		bgzip -c ${mantaDir}/results/variants/real/diploidSV.vcf > ${mantaDir}/results/variants/real/diploidSV.vcf.gz
		printf "..done\ntabix-ing ${mantaDir}/results/variants/real/diploidSV.vcf.gz .."
		tabix -p vcf ${mantaDir}/results/variants/real/diploidSV.vcf.gz
		printf "${mantaDir}/results/variants/real/diploidSV.vcf ..done\n"
	else
		echo "no diploidSV's left after filtering with the bedfile"
                touch ${mantaDir}/results/variants/real/NO_diploidSV
	fi


else
	echo "WGS sample, just move"
	zcat ${mantaDir}/results/variants/candidateSmallIndels.vcf.gz > ${mantaDir}/results/variants/real/candidateSmallIndels.vcf
	bgzip -c ${mantaDir}/results/variants/real/candidateSmallIndels.vcf > ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz
	tabix -p vcf ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz

	zcat ${mantaDir}/results/variants/candidateSV.vcf.gz > ${mantaDir}/results/variants/real/candidateSV.vcf
	bgzip -c ${mantaDir}/results/variants/real/candidateSV.vcf > ${mantaDir}/results/variants/real/candidateSV.vcf.gz
	tabix -p vcf ${mantaDir}/results/variants/real/candidateSV.vcf.gz

	zcat ${mantaDir}/results/variants/real/diploidSV.vcf.gz > ${mantaDir}/results/variants/real/diploidSV.vcf
	bgzip -c ${mantaDir}/results/variants/real/diploidSV.vcf > ${mantaDir}/results/variants/real/diploidSV.vcf.gz
	tabix -p vcf ${mantaDir}/results/variants/real/diploidSV.vcf.gz

fi

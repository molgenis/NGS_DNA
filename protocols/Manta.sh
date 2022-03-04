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
#string capturingKit
#string capturedBed
#string bedToolsVersion
#string htsLibVersion
#string python2Version

#string externalSampleID
#string ngsversion

module load "${ngsversion}"
module load "${mantaVersion}"
module load "${python2Version}"
module load "${htsLibVersion}"
module load "${bedToolsVersion}"

module list

rm -rf "${mantaDir}"
mkdir -p "${mantaDir}"

makeTmpDir "${mantaDir}"
tmpMantaDir="${MC_tmpFile}"

bedfile=$(basename "${capturingKit}")
SCRIPTNAME=${MC_jobScript}

if [[ "${bedfile}" == *"wgs"* || "${bedfile}" == *"WGS"* ]]
then
	python "${EBROOTMANTA}/bin/configManta.py" \
	--bam "${dedupBam}" \
	--referenceFasta "${indexFile}" \
	--runDir "${tmpMantaDir}" 
elif [[ "${bedfile}" == *"Exon"* || "${bedfile}" == *"Exoom"*  || "${bedfile}" == *"NGS_DNA_Test"* ]]
then

	## Exclude Manta_1 script when executing test project (PlatinumnSubset)
	if [[ "${project}" == *"PlatinumSubset"* && ${SCRIPTNAME} == *Manta_1.sh* ]] 
	then
		echo "PlatinumSubset is executed, therefore this script will not run (need a fix in making PhiX reads, forward/reversed)"
		mv "${SCRIPTNAME}".{started,finished}
		script=${SCRIPTNAME%.*}
		touch "${script}.env"
		chmod ugo+x "${script}.env"
		trap - EXIT
		exit 0
	fi
	python "${EBROOTMANTA}/bin/configManta.py" \
	--bam "${dedupBam}" \
	--referenceFasta "${indexFile}" \
	--exome \
	--config "${EBROOTNGS_DNA}/conf/configManta.py.ini" \
	--runDir "${tmpMantaDir}" 

else

	echo "not WGS or Exome, skipping"
	mv "${SCRIPTNAME}".{started,finished}
	script=${SCRIPTNAME%.*}
	touch "${script}.env"
	chmod ugo+x "${script}.env"
	trap - EXIT
	exit 0

fi

## run Manta 
python "${tmpMantaDir}/runWorkflow.py" -m local -j 8

mv "${tmpMantaDir}/"* "${mantaDir}/"


mkdir -p "${mantaDir}/results/variants/real/"

### If a capturingkit is used then only limit the output to those regions 
if [[ "${capturingKit,,}" != *"wgs"* ]]
then
	bedtools intersect -header -a "${mantaDir}/results/variants/candidateSmallIndels.vcf.gz" -b "${capturedBed}" > "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.tmp"

	if [ -f "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.tmp" ]
	then
		grep "^#" "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.tmp" > "${mantaDir}/results/variants/real/candidateSmallIndels.vcf"
		grep -v "^#" "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.tmp" | uniq >> "${mantaDir}/results/variants/real/candidateSmallIndels.vcf"

		bgzip -c "${mantaDir}/results/variants/real/candidateSmallIndels.vcf" > "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz"
		printf '%s' "..done\ntabix-ing ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz .."
		tabix -p vcf "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz"
		printf '%s' "${mantaDir}/results/variants/real/candidateSmallIndels.vcf ..done\n"
	else
		echo "no candidateSmallIndels's left after filtering with the bedfile"
		touch "${mantaDir}/results/variants/real/NO_candidateSmallIndels"
	fi

	bedtools intersect -header -a "${mantaDir}/results/variants/candidateSV.vcf.gz" -b "${capturedBed}" > "${mantaDir}/results/variants/real/candidateSV.vcf.tmp"

	if [ -f "${mantaDir}/results/variants/real/candidateSV.vcf.tmp" ]
	then
		grep "^#" "${mantaDir}/results/variants/real/candidateSV.vcf.tmp" > "${mantaDir}/results/variants/real/candidateSV.vcf"
		grep -v "^#" "${mantaDir}/results/variants/real/candidateSV.vcf.tmp" | uniq >> "${mantaDir}/results/variants/real/candidateSV.vcf"

		bgzip -c "${mantaDir}/results/variants/real/candidateSV.vcf" > "${mantaDir}/results/variants/real/candidateSV.vcf.gz"
		printf '%s' "..done\ntabix-ing ${mantaDir}/results/variants/real/candidateSV.vcf.gz .."
		tabix -p vcf "${mantaDir}/results/variants/real/candidateSV.vcf.gz"
		printf '%s' "${mantaDir}/results/variants/real/candidateSV.vcf ..done\n"
	else
		echo "no candidateSV's left after filtering with the bedfile"
		touch "${mantaDir}/results/variants/real/NO_candidateSV"
	fi

	bedtools intersect -header -a "${mantaDir}/results/variants/diploidSV.vcf.gz" -b "${capturedBed}" > "${mantaDir}/results/variants/real/diploidSV.vcf.tmp"
	if [ -f "${mantaDir}/results/variants/real/diploidSV.vcf.tmp" ]
	then
		grep "^#" "${mantaDir}/results/variants/real/diploidSV.vcf.tmp" > "${mantaDir}/results/variants/real/diploidSV.vcf"
		grep -v "^#" "${mantaDir}/results/variants/real/diploidSV.vcf.tmp" | uniq >> "${mantaDir}/results/variants/real/diploidSV.vcf"

		bgzip -c "${mantaDir}/results/variants/real/diploidSV.vcf" > "${mantaDir}/results/variants/real/diploidSV.vcf.gz"
		printf '%s' "..done\ntabix-ing ${mantaDir}/results/variants/real/diploidSV.vcf.gz .."
		tabix -p vcf "${mantaDir}/results/variants/real/diploidSV.vcf.gz"
		printf '%s' "${mantaDir}/results/variants/real/diploidSV.vcf ..done\n"
	else
		echo "no diploidSV's left after filtering with the bedfile"
		touch "${mantaDir}/results/variants/real/NO_diploidSV"
	fi


else
	echo "WGS sample, just move"
	if [[ -f "${mantaDir}/results/variants/candidateSmallIndels.vcf.gz" ]]
	then
		zcat "${mantaDir}/results/variants/candidateSmallIndels.vcf.gz" > "${mantaDir}/results/variants/real/candidateSmallIndels.vcf"
		bgzip -c "${mantaDir}/results/variants/real/candidateSmallIndels.vcf" > "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz"
		tabix -p vcf "${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz"
	else
		echo "there is no ${mantaDir}/results/variants/candidateSmallIndels.vcf.gz file"
	fi
	if [[ -f "${mantaDir}/results/variants/candidateSV.vcf.gz" ]]
	then	
		zcat "${mantaDir}/results/variants/candidateSV.vcf.gz" > "${mantaDir}/results/variants/real/candidateSV.vcf"
		bgzip -c "${mantaDir}/results/variants/real/candidateSV.vcf" > "${mantaDir}/results/variants/real/candidateSV.vcf.gz"
		tabix -p vcf "${mantaDir}/results/variants/real/candidateSV.vcf.gz"
	else
		echo "there is no ${mantaDir}/results/variants/candidateSV.vcf.gz file"
	fi
	if [[ -f  "${mantaDir}/results/variants/real/diploidSV.vcf.gz" ]]
	then
		zcat "${mantaDir}/results/variants/real/diploidSV.vcf.gz" > "${mantaDir}/results/variants/real/diploidSV.vcf"
		bgzip -c "${mantaDir}/results/variants/real/diploidSV.vcf" > "${mantaDir}/results/variants/real/diploidSV.vcf.gz"
		tabix -p vcf "${mantaDir}/results/variants/real/diploidSV.vcf.gz"
	else
		echo "there is no ${mantaDir}/results/variants/real/diploidSV.vcf.gz file"
	fi
fi

#MOLGENIS walltime=23:59:00 mem=6gb ppn=8

#Parameter mapping
#string project
#string logsDir
#string groupname
#string stage
#string vepVersion
#string htsLibVersion
#string ngsUtilsVersion
#string checkStage
#string intermediateDir
#string mantaDir
#string vepDataDir
#string vepAssemblyVersion
#string indexFile

set -e
set -u


"${stage}" "${ngsUtilsVersion}"
"${stage}" "${vepVersion}"
"${stage}" "${htsLibVersion}"
"${checkStage}"

makeTmpDir "${intermediateDir}"
tmpIntermediateDir="${MC_tmpFile}"

for i in  "candidateSV" "diploidSV"
do
	if [ -f "${mantaDir}/results/variants/${i}.vcf.gz" ]
	then
		"${EBROOTVEP}"/vep \
		-i "${mantaDir}/results/variants/${i}.vcf.gz" \
		--offline \
		--cache \
		--dir_cache "${vepDataDir}" \
		--species "homo_sapiens" \
		--assembly "${vepAssemblyVersion}" \
		--force_overwrite \
		--stats_file "${tmpIntermediateDir}/${i}_VEP_summary" \
		-o "${tmpIntermediateDir}/${i}_VEP.vcf"


		printf "sorting VCF file...\n"
		sortVCFbyFai.pl -fastaIndexFile "${indexFile}.fai" -inputVCF "${tmpIntermediateDir}/${i}_VEP.vcf" -outputVcf "${tmpIntermediateDir}/${i}_VEP.sorted.vcf"

		printf "compressing VCF file...\n"
		bgzip -c "${tmpIntermediateDir}/${i}_VEP.sorted.vcf" > "${tmpIntermediateDir}/${i}_VEP.vcf.gz"

		printf "Making VCF index file...\n"
		tabix -p vcf "${tmpIntermediateDir}/${i}_VEP.vcf.gz"

		mv "${tmpIntermediateDir}/${i}_VEP.vcf.gz" "${mantaDir}/results/variants/"
		echo "moved ${tmpIntermediateDir}/${i}_VEP.vcf.gz ${mantaDir}/results/variants/"

		mv "${tmpIntermediateDir}/${i}_VEP.vcf.gz.tbi" "${mantaDir}/results/variants/"
		echo "moved ${tmpIntermediateDir}/${i}_VEP.vcf.gz.tbi ${mantaDir}/results/variants/"

		mv "${tmpIntermediateDir}/${i}_VEP_summary.html" "${mantaDir}/results/variants/"
		echo "moved ${tmpIntermediateDir}/${i}_VEP_summary.html ${mantaDir}/results/variants/"

	else
		echo "skipped"
	fi

done

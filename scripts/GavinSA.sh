#!/bin/bash

set -e
set -u
module load BCFtools
cd '/groups/umcg-gd/tmp06/GavinStandAlone/input'

INPUTDIR=$(pwd)

if ls *.vcf.gz 1> /dev/null 2>&1
then
	for i in *.vcf.gz
	do
		groupname=$(basename $(cd ../../../ && pwd ))
		tmpDirectory=$(basename $(cd ../../ && pwd ))
		fileName=$(basename "${i}")
		name=${fileName%%.*}

		genScripts="/groups/${groupname}/${tmpDirectory}/generatedscripts/NGS_DNA/Gavin_${name}/"
		mkdir -p "${genScripts}"

		cp ${EBROOTNGS_DNA}/startFromVcf.sh "${genScripts}/"

		echo "cp ${i} ${genScripts}" >> "${INPUTDIR}/${name}.run.logs"

		bcftools annotate -x "^INFO/AC,INFO/AF,INFO/AN,INFO/DP" ${i} -o "${genScripts}/${name}.stripped.vcf"
		originalVcfCount=$(zcat ${i} | awk '{if ($0 !~ /#/){print $0}}' | wc -l)
		strippedCount=$(awk '{if ($0 !~ /#/){print $0}}' "${genScripts}/${name}.stripped.vcf" | wc -l)
		if [[ "${originalVcfCount}" -ne "${strippedCount}" ]]
		then
			echo "the stripped vcf is not the same size as the original one, exiting" >> "${INPUTDIR}/${name}.run.logs"
			exit 1
		fi

		perl -p -e 's|workflow_startFromVcf.csv|workflow_GavinStandAlone.csv|' "${genScripts}/startFromVcf.sh" > "${genScripts}/startFromVcf.sh.tmp"
		mv "${genScripts}/startFromVcf.sh.tmp" "${genScripts}/startFromVcf.sh"
		cd "/groups/${groupname}/${tmpDirectory}/generatedscripts/NGS_DNA/Gavin_${name}/"

		"${EBROOTNGS_DNA}/startFromVcf.sh" -v "${name}.stripped.vcf" -c 'Agilent\\/Exoom_v3'

		cd "/groups/${groupname}/${tmpDirectory}/projects/NGS_DNA/Gavin_${name}/run01/jobs/"
		bash submit.sh >> "${INPUTDIR}/${name}.run.logs"
		cd "${INPUTDIR}"
		echo "it will now be running in /groups/${groupname}/${tmpDirectory}/projects/NGS_DNA/Gavin_${name}/run01/jobs/" > "${name}.started"
		mv "${i}" 'processing/'
	done
fi

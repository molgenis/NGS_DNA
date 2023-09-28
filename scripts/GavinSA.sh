#!/bin/bash

set -e
set -u
module load BCFtools
cd '/groups/umcg-gd/tmp06/GavinStandAlone/input'

INPUTDIR=$(pwd)
if ls *.vcf 1> /dev/null 2>&1
then
	for i in $(ls *.vcf)
	do
		groupname=$(basename $(cd ../../../ && pwd ))
		tmpDirectory=$(basename $(cd ../../ && pwd ))
		fileName=$(basename "${i}")
		name=${fileName%%.*}

		genScripts="/groups/${groupname}/${tmpDirectory}/generatedscripts/NGS_DNA/Gavin_${name}"
		mkdir -p "${genScripts}"

		cp "${EBROOTNGS_DNA}/startFromVcf.sh" "${genScripts}/NGS_DNA/Gavin_${name}/"

		mac2unix "${i}"
		echo "cp ${i} ${genScripts}" >> "${INPUTDIR}/${name}.run.logs"

		bcftools annotate -x "^INFO/AC,INFO/AF,INFO/AN,INFO/DP" "${i}" -o "${genScripts}/${fileName%.*}.stripped.vcf"
		originalVcfCount=$(awk '{if ($0 !~ /#/){print $0}}' "${i}" | wc -l)
		strippedCount=$(awk '{if ($0 !~ /#/){print $0}}' "${genScripts}/${fileName%.*}.stripped.vcf" | wc -l)
		if [[ "${originalVcfCount}" != "${strippedCount}" ]]
		then
			echo "the stripped vcf is not the same size as the original one, exiting" >> "${INPUTDIR}/${name}.run.logs"
			exit 1
		fi

		perl -p -e 's|workflow_startFromVcf.csv|workflow_GavinStandAlone.csv|' "${genScripts}/startFromVcf.sh" > "${genScripts}/startFromVcf.sh.tmp"
		mv "${genScripts}/startFromVcf.sh.tmp" "${genScripts}/startFromVcf.sh"

		cd "${genScripts}"

		startFromVcf.sh -v "${fileName%.*}.stripped.vcf" -c 'Exoom_v3'

		cd "/groups/${groupname}/${tmpDirectory}/projects/NGS_DNA/Gavin_${name}/run01/jobs/"
		bash 'submit.sh' >> "${INPUTDIR}/${name}.run.logs"
		cd ${INPUTDIR}
		echo "it will now be running in /groups/${groupname}/${tmpDirectory}/projects/NGS_DNA/Gavin_${name}/run01/jobs/" > "${i}.started"
		mv -v "${i}" "processing/"
	done
fi

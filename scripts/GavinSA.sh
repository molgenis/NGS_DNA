#!/bin/bash

set -e
set -u
module load BCFtools/1.6-foss-2015b

declare groupname=''
declare tmpDirectory=''
while getopts "g:t:h" opt
do
	case $opt in
		h)
			showHelp
			;;
		g)
			groupname="${OPTARG}"
			;;
		t)
			tmpDirectory="${OPTARG}"
			;;
	esac
done

#
# Check commandline options.
#
if [[ -z "${groupname:-}" ]]
then
	echo "Must specify a groupname with -g."
	exit 1
fi

if [[ -z "${tmpDirectory:-}" ]]
then
	echo 'Must specify a tmpDirectory with -t.'
	exit 1
fi


cd "/groups/${groupname}/${tmpDirectory}/GavinStandAlone/input/"


INPUTDIR=$(pwd)
if ls *.vcf 1> /dev/null 2>&1
then
	for i in $(ls *.vcf)
	do
		fileName=$(basename "${i}")
		name=${fileName%%.*}

		mkdir -p "/groups/${groupname}/${tmpDirectory}/generatedscripts/Gavin_${name}/"
		cp "${EBROOTNGS_DNA}/startFromVcf.sh" "/groups/${groupname}/${tmpDirectory}/generatedscripts/Gavin_${name}/"

		mac2unix "${i}"
		echo "cp ${i} /groups/${groupname}/${tmpDirectory}/generatedscripts/Gavin_${name}/" >> "${INPUTDIR}/${name}.run.logs"

		bcftools annotate -x "^INFO/AC,INFO/AF,INFO/AN,INFO/DP" "${i}" -o "/groups/${groupname}/${tmpDirectory}/generatedscripts/Gavin_${name}/"${fileName%.*}".stripped.vcf"
		originalVcfCount=$(awk '{if ($0 !~ /#/){print $0}}' $i | wc -l)
		strippedCount=$(awk '{if ($0 !~ /#/){print $0}}' "/groups/${groupname}/${tmpDirectory}/generatedscripts/Gavin_${name}/"${fileName%.*}".stripped.vcf" | wc -l)
		if [ "${originalVcfCount}" -ne "${strippedCount}" ]
		then
			echo "the stripped vcf is not the same size as the original one, exiting" >> ${INPUTDIR}/${name}.run.logs 
			exit 1
		fi

		perl -pi -e 's|workflow_startFromVcf.csv|workflow_GavinStandAlone.csv|' "/groups/${groupname}/${tmpDirectory}/generatedscripts/Gavin_${name}/startFromVcf.sh"
		cd "/groups/${groupname}/${tmpDirectory}/generatedscripts/Gavin_${name}/"

		sh startFromVcf.sh -v ${fileName%.*}.stripped.vcf -c Exoom_v1

		cd "/groups/${groupname}/${tmpDirectory}/projects/Gavin_${name}/run01/jobs/"
		sh submit.sh >> "${INPUTDIR}/${name}.run.logs"
		cd "${INPUTDIR}"
		echo "it will now be running in /groups/${groupname}/${tmpDirectory}/projects/Gavin_${name}/run01/jobs/" > ${i}.started
		mv "${i}" processing/
	done
fi

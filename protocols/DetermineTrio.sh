set -o pipefail
#Parameter mapping
#string vcfPedVersion
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string projectPrefix

module load "${vcfPedVersion}"

inputVcfFile="${projectPrefix}.final.vcf"

python "${EBROOTVCFPED}/bin/vcfped" "${inputVcfFile}" -o "${projectPrefix}"

trioInformationPrefix="${intermediateDir}/trioInformation"

teller=0
inputTrioFile="${projectPrefix}.trio"
# shellcheck disable=SC1003
sed -i -e '$a\' "${inputTrioFile}"
count=$(wc -l "${inputTrioFile}" | awk '{print $1}')

if [[ "${count}" -gt 1 ]]
then
	while read -r trioFile
	do
		echo -e "${trioFile}"
		if [[ "${teller}" == 0 ]]
		then
			teller=$((teller+1))
			continue
		else
			trioString=$(echo -e "${trioFile}" | awk '{print $1}')
			child=$(echo -e "${trioFile}" | awk '{print $2}')

			trio=()
			mapfile -t trio < <(echo "${trioString}" | awk '{split($0, array, ","); for (i=1; i <= length(array); i++) {print array[i]}}')

			parents=()

			for i in "${trio[@]}"
			do
				if [[ "${i}" -ne "${child}" ]]
				then
					parents+=("${i}")
				fi
			done
			echo "PARENTS: ${parents[0]} ${parents[1]}"
			awk -v parent1="${parents[0]}" -v parent2="${parents[1]}" '{if ($0 ~ /^#CHROM/){print $(parent1+9)"\n"$(parent2+9)}}' "${inputVcfFile}" > "${trioInformationPrefix}Parents_family${teller}.tmp"
			awk -v child="${child}" '{if ($0 ~ /^#CHROM/){print $(child+9)" Child"}}' "${inputVcfFile}" > "${trioInformationPrefix}_family${teller}.txt"

			while read -r line
			do
				printf '%s' "${line} "
				if [[ "$(tail -1 "${intermediateDir}/${line}.chosenSex.txt")" == 'Female' ]]
				then
					echo "Mother"
				else
					echo "Father"
				fi
			done<"${trioInformationPrefix}Parents_family${teller}.tmp" >> "${trioInformationPrefix}_family${teller}.txt"

		fi
		teller=$((teller+1))
	done<"${inputTrioFile}"
	
	mapfile -t familyTxt < <(find "${trioInformationPrefix}_family"*".txt")
	
	for i in "${familyTxt[@]}"
	do
		child=$(head -1 "${i}" | awk '{print $1}' )
		cp "${i}" "${intermediateDir}/${child}.hasFamily"
	done

else
	echo "there were no trio's found in this data"
fi

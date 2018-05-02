#MOLGENIS walltime=05:59:00 mem=10gb ppn=10

#Parameter mapping
#string vcfPedVersion
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string projectPrefix

set -eu

module load ${vcfPedVersion}

inputVcfFile="${projectPrefix}.final.vcf"

vcfped ${inputVcfFile} -o ${projectPrefix}

trioInformationPrefix="${intermediateDir}/trioInformation"

teller=0
inputTrioFile="${projectPrefix}.trio"

count=$(cat ${inputTrioFile} | wc -l)

if [ $count -gt 1 ]
then
	while read trioFile
	do
		echo -e "${trioFile}"
		if [ $teller == 0 ]
		then
			teller=$((teller+1))
			continue
		else
			trioString=$(echo -e "${trioFile}" | awk '{print $1}')
			child=$(echo -e "${trioFile}" | awk '{print $2}')

			trio=()
			IFS="," trio=($(echo "$trioString"))

			parents=()

			for i in ${trio[@]}
			do
				if [[ ${i} -ne ${child} ]]
				then
					parents+=(${i})
				fi
			done
			echo "PARENTS: ${parents[0]} ${parents[1]}"
			awk -v parent1=${parents[0]} -v parent2=${parents[1]} '{if ($0 ~ /^#CHROM/){print $(parent1+9)"\n"$(parent2+9)}}' "${inputVcfFile}" > ${trioInformationPrefix}Parents_family${teller}.tmp
			awk -v child=${child} '{if ($0 ~ /^#CHROM/){print $(child+9)": Child"}}' "${inputVcfFile}" > ${trioInformationPrefix}_family${teller}.txt 

			while read line
			do
				printf "${line}: "
				if [ $(tail -1 ${intermediateDir}/${line}.chosenSex.txt) == "Female" ]
				then
					echo "Mother"
				else
					echo "Father"
				fi
			done<${trioInformationPrefix}Parents_family${teller}.tmp >> ${trioInformationPrefix}_family${teller}.txt 
		fi
		teller=$((teller+1))
	done<${inputTrioFile}
else
	echo "there were no trio's found in this data"
fi

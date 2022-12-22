#Parameter mapping
#string logsDir

#string seqType
#string peEnd1BarcodeFqGz
#string peEnd2BarcodeFqGz
#string srBarcodeFqGz
#string srBarcodeRecodedFqGz
#string peEnd1BarcodePhiXRecodedFqGz
#string peEnd2BarcodePhiXRecodedFqGz
#string peEnd1BarcodePhiXFqGz
#string peEnd2BarcodePhiXFqGz

#string intermediateDir
#string project
#string groupname
#string tmpName
#list externalSampleID
#string intermediateDir

#string phiXEnd1Gz
#string phiXEnd2Gz
#string seqTkVersion
#string pigzVersion


#Load module
module load "${seqTkVersion}"
module load "${pigzVersion}"

array_contains () {
	local array="$1[@]"
	local seeking="${2}"
	local in=1
	for element in "${!array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
			in=0
			break
		fi
	done
	return "${in}"
}

INPUTS=()
for sample in "${externalSampleID[@]}"
do
	array_contains INPUTS "${sample}" || INPUTS+=("${sample}")
done

echo "starting with phiX part"
# Spike phiX only once
if [[ "${seqType}" == "PE" ]]
then
	samp=$(zcat "${peEnd1BarcodeFqGz}" | tail -n10)
	phiX=$(zcat "${phiXEnd1Gz}" | tail -n10)

	if [[ "${samp}" = "${phiX}" ]]
	then
		echo "Skip this step! PhiX was already spiked in!"
		exit 0
	else
		rm -f "${peEnd1BarcodePhiXFqGz}"
		rm -f "${peEnd2BarcodePhiXFqGz}"
		echo "Append phiX reads"
		cat "${peEnd1BarcodeFqGz}" "${phiXEnd1Gz}" >> "${peEnd1BarcodePhiXFqGz}"
		cat "${peEnd2BarcodeFqGz}" "${phiXEnd2Gz}" >> "${peEnd2BarcodePhiXFqGz}"
	fi
	echo -e "finished with phiX part...\nstarting with IlluminaEncoding"


else
	echo "Single Read, phiX spike skipped"
fi

checkIlluminaEncoding() {
	barcodeFqGz="${1}"
	barcodeFinalFqGz="${2}"

	mapfile -t lines< <(zcat "${barcodeFqGz}" | head -20000 | tail -192 | awk 'NR % 4 == 0')
	count=1
	nodecision=0
	numberoflines=0
	for line in "${lines[@]}"
	do
		numberoflines=$(( numberoflines+1 ))
		#check for illumina encoding 1.5
		if [[ "${line}" =~ [P-Z] ]] || [[ "${line}" =~ [a-g] ]]
			then
				encoding="1.5"
			if [[ "${count}" -eq 1 ]]
			then
				lastEncoding="${encoding}"
				count=$(( count+1 ))
			fi

			if ! [[ "${encoding}" == "${lastEncoding}" ]]
			then
				echo "error, encoding not possible"
				echo "${encoding} is not matching last encoding (${lastEncoding})"
				echo "LINE: ${line}"
				exit 1
			fi
			lastEncoding="${encoding}"

		#check for illumina encoding 1.8/1.9
		elif [[ "${line}" =~ [0-9] ]] || [[ "${line}" =~ [\<=\>?] ]]
		then
			encoding="1.9"
			if [[ "${count}" -eq 1 ]]
			then
				lastEncoding="${encoding}"
				count=$(( count+1 ))
			fi
			if ! [[ "${encoding}" == "${lastEncoding}" ]]
			then
				echo "error, encoding not possible"
				echo "${encoding} is not matching last encoding (${lastEncoding})"
				echo "LINE: ${line}"
			exit 1
			fi
			lastEncoding="${encoding}"
		elif [[ "${line}" =~ @ ]] || [[ "${line}" =~ [A-J] ]]
		then
			nodecision=$(( nodecision+1 ))
		else
			echo "The encoding is not matching to anything, check FastQ documentation (count=${count})"
		fi
	done
	if [[ "${nodecision}" == "${numberoflines}" ]]
	then
		echo "Within all the lines, no decision was made about the encoding, all the encoding is between A and J. This is then probably an 1.9 encoding sample, so 1.9 is set as encoding"
		encoding="1.9"
	fi

	if [[ "${encoding}" == "1.9" ]]
	then
		echo "encoding is Illumina 1.8 - Sanger / Illumina 1.9"
		echo "Only move ${barcodeFqGz} to ${barcodeFinalFqGz}"
		mv "${barcodeFqGz}" "${barcodeFinalFqGz}"

	else
		#make fastQ out of the fq.gz file
		echo "converting Illumina encoding"
		seqtk seq "${barcodeFqGz}" -Q 64 -V > "${barcodeFqGz}".encoded.fq

		echo -e "done..\nNow gzipping ${barcodeFqGz}.encoded.fq > ${barcodeFinalFqGz}"
		pigz -c "${barcodeFqGz}.encoded.fq" > "${barcodeFinalFqGz}"

	fi

}

#check illumina encoding using function checkIlluminaEncoding()

#If paired-end do fastqc for both ends, else only for one
if [[ "${seqType}" == "PE" ]]
then
	checkIlluminaEncoding "${peEnd1BarcodePhiXFqGz}" "${peEnd1BarcodePhiXRecodedFqGz}"
	checkIlluminaEncoding "${peEnd2BarcodePhiXFqGz}" "${peEnd2BarcodePhiXRecodedFqGz}"
elif [[ "${seqType}" == "SR" ]]
then
	checkIlluminaEncoding "${srBarcodeFqGz}" "${srBarcodeRecodedFqGz}"
else
	echo "SeqType unknown"
	exit 1
fi

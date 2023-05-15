set -o pipefail
#string tmpName
#string allRawNgsTmpDataDir
#list seqType
#list sequencingStartDate
#list sequencer
#list run
#list flowcell
#string mainParameters
#string worksheet 
#string outputdir
#string workflowpath
#list externalSampleID
#string project
#string logsDir 
#string groupname
#string intermediateDir
#list barcode
#list lane

array_contains () {
	local array="$1[@]"
	local seeking="${2}"
	local barcodeLane="${3}"
	rejected="false"
	for element in "${!array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
		
			if [[ "${barcodeLane}" == "true" ]]
			then
				echo "barcode+Lane already exists!!"
				exit 1
			else
				rejected="true"
				continue
			fi
		fi
	done
}
arrayUniqueBarcodes=()
allRawDataAvailable='true'

mkdir -p "${logsDir}/${project}/"
max_index=${#externalSampleID[@]}-1
rm -f "${logsDir}/${project}/${project}.copyDataFromPrm.requested"
for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do
	dataProcessingStarted='false'
	RUNNAME="${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}"
	TMPDATADIR="${allRawNgsTmpDataDir}/${RUNNAME}/"
	mkdir -vp "${TMPDATADIR}"
	
	if [[ -f "${TMPDATADIR}/rejectedBarcodes.txt" ]]
	then
		arrayRejected=()

		while read -r line
		do
			arrayRejected+=("${line}")
		done<"${TMPDATADIR}/rejectedBarcodes.txt"
	fi

	if [[ -f "${logsDir}/${project}/${project}.copyDataFromPrm.started" ]]
	then
		dataProcessingStarted='true'
	fi
	
	## Single Read
	if [[ "${seqType[samplenumber]}" == 'SR' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz" ]]
			then
				if [[ "${dataProcessingStarted}" == 'false' ]]
				then
					echo "rawdata/ngs/${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}.fq.gz" >> "${logsDir}/${project}/${project}.copyDataFromPrm.requested"
				fi
				echo "${TMPDATADIR}/${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}.fq.gz missing"
				allRawDataAvailable='false'
			else
				echo "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz available"
			fi
		else
			array_contains arrayUniqueBarcodes "${barcode[samplenumber]}-L${lane[samplenumber]}" || arrayUniqueBarcodes+=("${barcode[samplenumber]}-L${lane[samplenumber]}") 
			if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz" ]]
			then
				if [[ "${dataProcessingStarted}" == 'false' ]]
				then
					echo "rawdata/ngs/${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz" >> "${logsDir}/${project}/${project}.copyDataFromPrm.requested"
				fi
				echo "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz missing"
				allRawDataAvailable='false'
			else
				echo "${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz available"
			fi
		fi
		## PAIRED END
	elif [[ "${seqType[samplenumber]}" == 'PE' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz" ]]
			then
				if [[ "${dataProcessingStarted}" == 'false' ]]
				then
					echo "rawdata/ngs/${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz" >> "${logsDir}/${project}/${project}.copyDataFromPrm.requested"
				fi
				echo "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz missing"
				allRawDataAvailable='false'
			else
				echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz available"	
			fi
			
			if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz" ]]
			then
				if [[ "${dataProcessingStarted}" == 'false' ]]
				then
					echo "rawdata/ngs/${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz" >> "${logsDir}/${project}/${project}.copyDataFromPrm.requested"
				fi
				echo "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz missing"
				allRawDataAvailable='false'
			else
				echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz available"
			fi
		else	
			array_contains arrayRejected "${barcode[samplenumber]}" "false"
			if [[ "${rejected}" == "false" ]]
			then
				array_contains arrayUniqueBarcodes "${barcode[samplenumber]}-L${lane[samplenumber]}" "true" || arrayUniqueBarcodes+=("${barcode[samplenumber]}-L${lane[samplenumber]}")
				if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz" ]]
				then
					if [[ "${dataProcessingStarted}" == 'false' ]]
					then
						echo "rawdata/ngs/${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz" >> "${logsDir}/${project}/${project}.copyDataFromPrm.requested"
					fi
					echo "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz missing"
					allRawDataAvailable='false'
				else
					echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz available"
				fi
		
				if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz" ]]
				then
					if [[ "${dataProcessingStarted}" == 'false' ]]
					then
						echo "rawdata/ngs/${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz" >> "${logsDir}/${project}/${project}.copyDataFromPrm.requested"
					fi
					echo "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz missing"
					allRawDataAvailable='false'
				else
					echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz available"
				fi
			else
				echo -e "\n############ barcode: ${barcode[samplenumber]} IS REJECTED#######################\n"
			fi
		fi
	fi
done


if [[ "${allRawDataAvailable}" == 'true' ]]
then
	echo "rawdata already available"
	if [[  -f "${logsDir}/${project}/${project}.copyDataFromPrm.started" ]]
	then
		mv "${logsDir}/${project}/${project}.copyDataFromPrm."{started,finished}
		rm -f "${logsDir}/${project}/${project}.copyDataFromPrm.failed"
	else
		touch "${logsDir}/${project}/${project}.copyDataFromPrm.finished"
	fi
else
	rm -f "${logsDir}/${project}/${project}.copyDataFromPrm.finished"
	echo "all Data is not yet available, manually stopping dependent jobs"
	teller=0
	while read -r line 
	do
		if [[ "${teller}" == 0 ]]
		then
			teller=1
		else
			jobId=$(echo "${line}" | awk 'BEGIN {FS=":"}{print $2}')
			jobName=$(echo "${line}" | awk 'BEGIN {FS=":"}{print $1}')
			echo -n "INFO: Cancelling job ${jobName} (${jobId})... "
			scancel -Q "${jobId}"
		fi

	done <"molgenis.submitted.log"
	
	trap - EXIT
	exit 0
fi

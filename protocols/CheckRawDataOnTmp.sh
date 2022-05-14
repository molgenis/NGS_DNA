#string tmpName
#string allRawNgsTmpDataDir
#string allRawNgsPrmDataDir
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
#string permanentDataDir
#string intermediateDir
#list barcode
#list lane
#string prmHost


allRawDataAvailable='true'

for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do

	RUNNAME="${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}"
	TMPDATADIR="${allRawNgsTmpDataDir}/${RUNNAME}/"
	mkdir -vp "${TMPDATADIR}"
	## Single Read
	if [[ "${seqType[samplenumber]}" == 'SR' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz" ]]
			then
				echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}.fq.gz" >> "${logsDir}/${project}/${project}.data.requested"
				allRawDataAvailable='false'
			fi
		else
			if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz" ]]
			then
				echo "${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz" >> "${logsDir}/${project}/${project}.data.requested"
				allRawDataAvailable='false'
			fi
		fi
		## PAIRED END
	elif [[ "${seqType[samplenumber]}" == 'PE' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			if [[ ! -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz" ]]
			then
				echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz" >> "${logsDir}/${project}/${project}.data.requested"
				allRawDataAvailable='false'
			fi
			
			if [[ -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz" ]]
			then
				echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz" >> "${logsDir}/${project}/${project}.data.requested"
				allRawDataAvailable='false'
			fi
		else	
			if [[ -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz" ]]
			then
				echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz" >> "${logsDir}/${project}/${project}.data.requested"
				allRawDataAvailable='false'
			fi
		
			if [[ -f "${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz" ]]
			then
				echo "${RUNNAME}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz" >> "${logsDir}/${project}/${project}.data.requested"
				allRawDataAvailable='false'
			fi
		fi
	fi
done

if [[ "${allRawDataAvailable}" == 'true' ]]
then
	echo "rawdata already available"
	mv "${logsDir}/${project}/${project}.data."{started,finished}
fi

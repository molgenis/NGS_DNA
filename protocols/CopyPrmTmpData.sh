#MOLGENIS walltime=02:00:00 mem=4gb

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

array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
		echo "barcode+Lane already exists!!"
		exit 1
        fi
    done
    return $in
}

max_index=${#externalSampleID[@]}-1




WHOAMI=$(whoami)
HOST=$(hostname -s)
arrayUniqueBarcodes=()
if ls "${permanentDataDir}/logs/"*.mailinglist 1>/dev/null 2>&1
then
	rsync --verbose --links --no-perms --times --group --no-owner --devices --specials --checksum \
		"${permanentDataDir}/logs/"*.mailinglist \
		"${tmpDataDir}/logs/"
fi

for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do
	RUNNAME="${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}"
	if [ "${prmHost}" == "localhost" ]
	then
		PRMDATADIR="${allRawNgsPrmDataDir}/${RUNNAME}"
	else
		PRMDATADIR="${prmHost}:${allRawNgsPrmDataDir}/${RUNNAME}"
	fi
	TMPDATADIR="${allRawNgsTmpDataDir}/${RUNNAME}"

	mkdir -vp "${TMPDATADIR}"

	if [[ "${seqType[samplenumber]}" == 'SR' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			rsync --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials --checksum \
				"${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz"* \
				"${TMPDATADIR}/"
		else
			array_contains arrayUniqueBarcodes "${barcode[samplenumber]}-L${lane[samplenumber]}" || arrayUniqueBarcodes+=("${barcode[samplenumber]}-L${lane[samplenumber]}") 
			rsync --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials --checksum \
				"${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz"* \
				"${TMPDATADIR}/"
		fi
	elif [[ "${seqType[samplenumber]}" == 'PE' ]]
	then
		if [[ "${barcode[samplenumber]}" == 'None' ]]
		then
			rsync --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials --checksum \
				"${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz"* \
				"${TMPDATADIR}/"
			rsync --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials --checksum \
				"${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz"* \
				"${TMPDATADIR}/"
		else
			array_contains arrayUniqueBarcodes "${barcode[samplenumber]}-L${lane[samplenumber]}" || arrayUniqueBarcodes+=("${barcode[samplenumber]}-L${lane[samplenumber]}") 
			rsync --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials --checksum \
				"${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz"* \
				"${TMPDATADIR}/"

			rsync --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials --checksum \
				"${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz"* \
				"${TMPDATADIR}/"
		fi
	fi
done


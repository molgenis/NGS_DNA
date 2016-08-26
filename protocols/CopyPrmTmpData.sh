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
#string batchIDList 
#string worksheet 
#string outputdir
#string workflowpath
#list internalSampleID
#string project
#string logsDir 
#string groupname
#string permanentDataDir
#string intermediateDir
#list barcode
#list lane

n_elements=${internalSampleID[@]}
max_index=${#internalSampleID[@]}-1

WHOAMI=$(whoami)
HOST=$(hostname)

if [[ "$HOST" == "zinc-finger.gcc.rug.nl" ||  "$HOST" == "leucine-zipper.gcc.rug.nl" ]] && [ ! -d /groups/${groupname}/prm02 ]
then
	printf "On zinc-finger or leucine-zipper...\n"
	if [ ! -f /groups/umcg-gd/${tmpName}/logs/mailinglistDiagnostiek.txt ]
	then
		rsync ${WHOAMI}@calculon.hpc.rug.nl:${permanentDataDir}/logs/mailinglistDiagnostiek.txt /groups/umcg-gd/${tmpName}/logs/
		printf "mailinglistDiagnostiek.txt copied from prm02 to /groups/umcg-gd/${tmpName}/logs/ \n"
	fi
fi

for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do

	RUNNAME=${sequencingStartDate[samplenumber]}_${sequencer[samplenumber]}_${run[samplenumber]}_${flowcell[samplenumber]}	
	if [[ "$HOST" == "zinc-finger.gcc.rug.nl" ||  "$HOST" == "leucine-zipper.gcc.rug.nl" ]] && [ ! -d /groups/${groupname}/prm02 ]
	then
		echo "${WHOAMI}@calculon.hpc.rug.nl:${allRawNgsPrmDataDir}/${RUNNAME}"
		PRMDATADIR="${WHOAMI}@calculon.hpc.rug.nl:${allRawNgsPrmDataDir}/${RUNNAME}"
	else	
		PRMDATADIR=${allRawNgsPrmDataDir}/${RUNNAME}
	fi

	TMPDATADIR=${allRawNgsTmpDataDir}/${RUNNAME}

	if [[ ${seqType[samplenumber]} == "SR" ]]
	then
  		mkdir -p ${TMPDATADIR}
		if [[ ${barcode[samplenumber]} == "None" ]]
		then
			echo "copying ${RUNNAME}_L${lane[samplenumber]}.fq.gz..." 
			rsync -a -r --no-perms --no-owner \
			${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz \
			${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz
			rsync -a -r --no-perms --no-owner \
			${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz.md5 \
			${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}.fq.gz.md5
		else
			echo "copying ${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz..." 
			rsync -a -r --no-perms --no-owner \
			${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz \
			${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz
			rsync -a -r --no-perms --no-owner \
			${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5 \
			${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}.fq.gz.md5	
		fi
	elif [[ ${seqType[samplenumber]} == "PE" ]]
	then
		mkdir -p ${TMPDATADIR}
		if [[ ${barcode[samplenumber]} == "None" ]]
    		then
		echo "copying ${RUNNAME}_L${lane[samplenumber]}_1.fq.gz..." 
    		rsync -a -r --no-perms --no-owner \
    			${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz \
    			${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz
		echo "copying ${RUNNAME}_L${lane[samplenumber]}_2.fq.gz..." 
		rsync -a -r --no-perms --no-owner \
			${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz \
			${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz
		rsync -a -r --no-perms --no-owner \
			${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz.md5 \
			${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_1.fq.gz.md5
        	rsync -a -r --no-perms --no-owner \
        		${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz.md5 \
        		${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_2.fq.gz.md5
		else          
		echo "copying ${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz..." 
        	rsync -a -r --no-perms --no-owner \
        		${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz \
        		${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz
		echo "copying ${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz..." 
        	rsync -a -r --no-perms --no-owner \
        		${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz \
        		${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz
        	rsync -a -r --no-perms --no-owner \
        		${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5 \
        		${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_1.fq.gz.md5
        	rsync -a -r --no-perms --no-owner \
        		${PRMDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5 \
        		${TMPDATADIR}/${RUNNAME}_L${lane[samplenumber]}_${barcode[samplenumber]}_2.fq.gz.md5
    		fi
 	fi	

done





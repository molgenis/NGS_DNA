#MOLGENIS walltime=05:59:00 mem=10gb ppn=10

#Parameter mapping
#string project
#string logsDir
#string groupname
#string convadingLogfile
#string convadingFinallist
#string convadingLonglist
#string convadingLonglistCombinedFiltered
#string convadingShortlist
#string convadingTotallist
#string xhmmXcnvFinal
#string externalSampleID
#string convadingOnlyCall
#string xhmmOnlyCall
#string xhmmOnlyCallMerged
#string overlapCall
#string convadingBed
#string xhmmBed
#string convadingLonglistBed
#string combinedFiltered
#string convadingFinallistFiltered 
#string xhmmXcnvFinalFiltered
#string rejectedCalls
#string sampleRatios
#string filteredOut
#string decisionTreeDir
#string unreliableCalls
#string ngsversion
#string longlistPlusPlus
#string xhmmPlusPlus
#string longlistPlusPlusFinal
#string overlapLonglistCall
#string intermediateDir
#string bedToolsVersion


if [ ! -f "${intermediateDir}/convading.skipped" ]
then

	module load "${ngsversion}"
	module load "${bedToolsVersion}"

	if [ ! -d "${decisionTreeDir}" ]
	then
		mkdir -p "${decisionTreeDir}"
	fi
	rm -f "${longlistPlusPlus}"
	rm -f "${xhmmPlusPlus}"

	rm -f "${combinedFiltered}.XHMM"
	rm -f "${combinedFiltered}"
	rm -f "${combinedFiltered}.failedSampleTree"

	rm -f "${xhmmXcnvFinal}.filtered"

	rm -f "${convadingLonglistCombinedFiltered}"
	rm -f "${convadingFinallistFiltered}"

	#
	##
	### Functions
	##
	#
	Sample_Ratio () {
		# Grep Sample Ratio and label it depending on value
		inputFile=$1
		j=$(grep SAMPLE_RATIO: $inputFile)
		echo -e "${inputFile%%.*}\t$j" > ${sampleRatios}
		awk 'BEGIN{OFS="\t"}{
			if($3 <= "0.09"){
				print "Good"
			}
			if($3 > "0.09" && $3 <= "0.2"){
				print "Bad"
			}
			if($3 > "0.2"){
				print $3"\tExtreme_Sample_Ratio"
			}
		}' "${sampleRatios}"
	}

	Locations () {
		boom="${1}"
		tail -n +2 "${convadingFinallist}" | awk '{OFS="\t"}{print $1,$2,$3}' > "${convadingBed}"
		tail -n +2 "${xhmmXcnvFinal}" |  awk '{print $3}' | awk -F'[:-]' '{OFS="\t"}{print $1,$2,$3}' > "${xhmmBed}"

		rm -rf "${overlapCall}"
		rm -rf "${convadingOnlyCall}"
		rm -rf "${xhmmOnlyCall}"
		rm -rf "${combinedFiltered}.failedSampleTree"
		rm -rf "${combinedFiltered}"
		# overlap CoNVaDING and XHMM
		bedtools intersect -wa -a "${convadingBed}" -b "${xhmmBed}" | awk 'BEGIN {OFS="\t"}{print $1, $2, $3}' | uniq > "${overlapCall}"
		bedtools intersect -wa -a "${xhmmBed}" -b "${convadingBed}" | awk 'BEGIN {OFS="\t"}{print $1":"$2"-"$3}' | uniq > "${overlapCall}.XHMM"
		# no overlap
		# CoNVaDING only calls
		bedtools intersect -v -a "${convadingBed}"  -b "${xhmmBed}" | awk 'BEGIN {OFS="\t"}{print $0}' |uniq > "${convadingOnlyCall}"
		# XHMM only calls
		bedtools intersect -v -a "${xhmmBed}" -b "${convadingBed}" | awk 'BEGIN {OFS="\t"}{print $0}' | uniq > "${xhmmOnlyCall}"

		rm -f "${combinedFiltered}" "${convadingFinallistFiltered}" "${xhmmXcnvFinalFiltered}"
		partialDone="false"
		if [ -s "${overlapCall}" ]
		then
			while read line
			do
				if grep -q "$line" "${convadingFinallist}"
				then
					grep "$line" "${convadingFinallist}"
				fi
			done < "${overlapCall}" >> "${combinedFiltered}"

			if [[ "${boom}" == "F" && -s "${convadingOnlyCall}" ]]
			then
				echo "Call_has_partial_overlap"
				partialDone="true"
				while read part 
				do
					grep "$part" "${convadingFinallist}"
				done<"${convadingOnlyCall}" >>  "${combinedFiltered}.failedSampleTree"
			else
				echo "Call_has_overlap"
			fi

			while read line
			do
				if grep -q "$line" "${xhmmXcnvFinal}"
				then
					grep "$line" "${xhmmXcnvFinal}"
				fi
			done < "${overlapCall}.XHMM" >> "${combinedFiltered}.XHMM"

		elif [[ "${boom}" == "F" && -s "${convadingOnlyCall}" && "${partialDone}" == "false" ]]
		then
			echo "Call_has_no_overlap"
			while read part
			do
				grep "$part" "${convadingFinallist}"
			done<"${convadingOnlyCall}" >>  "${combinedFiltered}.failedSampleTree"
		fi


		if [ -s "${convadingOnlyCall}" ]
		then
			echo "CoNVaDING_only_call"
			while read line
			do
				if grep -q "$line" "${convadingFinallist}"
				then
					grep "$line" "${convadingFinallist}"
				fi
			done <"${convadingOnlyCall}" >> "${convadingFinallistFiltered}"
		fi

		if [ -s "${xhmmOnlyCall}" ]
		then
			awk '{print $1":"$2"-"$3}' "${xhmmOnlyCall}" > "${xhmmOnlyCallMerged}"
			echo "XHMM_only_call"
			while read line
			do
				if grep -q "$line" "${xhmmXcnvFinal}"
				then
					grep "$line" "${xhmmXcnvFinal}"
				fi
			done < "${xhmmOnlyCallMerged}" > "${xhmmXcnvFinalFiltered}"
		fi

	}

	Locations_longlist () {
		tail -n +2 "${convadingLonglist}" | awk '{OFS="\t"}{print $1,$2,$3}' > "${convadingLonglistBed}"
		tail -n +2 "${xhmmXcnvFinal}" |  awk '{print $3}' | awk -F'[:-]' '{OFS="\t"}{print $1,$2,$3}' > "${xhmmBed}"

		# overlap CoNVaDING longlist and XHMM
		bedtools intersect -wa -a "${convadingLonglistBed}" -b "${xhmmBed}" | awk 'BEGIN {OFS="\t"}{print $0}' > "${overlapLonglistCall}"

		# no overlap
		# CoNVaDING only calls
		#bedtools intersect -v -a ${convadingLonglistBed} -b ${xhmmBed}  | awk '{print $0"\t CoNVaDING only call"}'

		# XHMM only calls
		bedtools intersect -v -a "${xhmmBed}"  -b "${convadingLonglistBed}" | awk 'BEGIN {OFS="\t"}{print $0}' > "${xhmmOnlyCall}"

		cat "${xhmmOnlyCall}"
		rm -f "${convadingLonglistCombinedFiltered}"
		sizeOverlapLonglist=$(cat "${overlapLonglistCall}" | wc -l)
		if [ -s "${overlapLonglistCall}" ]
		then
			while read line
			do
				if grep -q "$line" "${convadingLonglist}"
				then
					grep "$line" "${convadingLonglist}" >> "${convadingLonglistCombinedFiltered}"
				fi
			done <"${overlapLonglistCall}"

			sizeXhmmXcnvFinal=$(($(cat "${xhmmXcnvFinal}" | wc -l) -1))
			if [ "${sizeXhmmXcnvFinal}" == "${sizeOverlapLonglist}" ]
			then
				echo "Complete_on_CoNVaDING_longlist"
			elif [ "${sizeXhmmXcnvFinal}" > "${sizeOverlapLonglist}" ]
			then
				echo "Partially_on_CoNVaDING_longlist"
				while read line
				do
					if grep -q "$line" "${xhmmXcnvFinal}"
					then
						grep "$line" "${xhmmXcnvFinal}"
					fi
				done<"${xhmmOnlyCall}" >> "${xhmmXcnvFinal}.filtered"
			fi
		else
			echo "not_on_CoNVaDING_longlist"

		fi

	}

	Single_exon () {
		awk -v boom="${2}" 'BEGIN{OFS="\t"}{
		if($5 == 1){
			print $0"\t"boom"\tSingle_exon_call"}
		if($5 > 1){
			print "Call_has_multiple_exons"}}' $1
	}

	Number_of_genes () {

		no_of_genes=$(tail -n +2 "${convadingFinallist}" | awk '{print $4}' | sort | uniq | wc -l)


		if [ "${no_of_genes}" -lt 4 ]
		then
			echo "Good_number_of_genes"
		else
			awk -v boom="${2}" '{print $0"\t"boom"\tToo_many_genes"}' "${1}"
		fi
	}

	Q_scores () {
		awk -v b="${2}" 'BEGIN{OFS="\t"}{
			if (NR>1){
				if($10 >= 13 && $11 >= 13){
					print $10,$11,"Q_scores_are_good"}
				else{
					print $0"\t"b"\tQ_scores_too_low"
				}
			}
		}' "${xhmmXcnvFinal}"
	}

	Shapiro_wilk () {

	awk -v b="${2}" 'BEGIN{OFS="\t"}{
			if($5 == $6){
				print $0,b"\tCall_is_final"
			}
			if($6 == 0){
				print $0,b"\tunreliable_call"
			}
			else{
				print $0,b"\tCall_is_final"
			}
		}' "${1}"
	}

	#
	##
	### TREES
	##
	#

	#
	##
	### Failed sample tree
	##
	#
	Failed_Sample_Tree () {
		boom="${1}"
		# Tests if locations overlap
		location=$(Locations "${boom}")
		exons="unset"
		values="unset"
		qscore="unset"
		shapiro="unset"
		Call=""
		if [[ "${location}" == *"Call_has_overlap"* ]]
		then
			echo "Call has overlap, program continues > "
			exons=$(Single_exon "${combinedFiltered}" "${boom}")
		elif [[ "${location}" == *"Call_has_partial_overlap"* ]]
		then
			echo "Call has partially overlap, program continues > "
			exons=$(Single_exon "${combinedFiltered}" "${boom}")

			echo -e "${boom}\tCall has partially no overlap, program stops. "
			awk -v b="${boom}" '{print $0"\t"b"\tNo_overlap"}' "${combinedFiltered}.failedSampleTree" >> "${longlistPlusPlus}"
		elif [[ "${location}" == *"Call_has_no_overlap"* ]]
		then
			echo -e "${boom}\tCall has no overlap, program stops. "
			awk -v b="${boom}" '{print $0"\t"b"\tNo_overlap"}' "${combinedFiltered}.failedSampleTree" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		else
			echo -e "${boom}\tCall has no overlap, program stops. "
			awk -v b="${boom}" '{print $0"\t"b"\tNo_overlap"}' "${convadingFinallist}" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi
		# Tests if a call has multiple exons or a single exon
		if [[ "${exons}" == *"Call_has_multiple_exons"* ]]
		then
			echo "Call has multiple exons, program continues > "
			genes=$(Number_of_genes "${combinedFiltered}" "${boom}")
		else
			echo -e "${boom}\tCall is single exon, program stops. "
			echo "${exons}" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi


		# Tests if a call has a good number of genes
		if [[ "${genes}" == *"Good_number_of_genes"* ]]
		then
			echo "Call has a good number of genes, program continues > "
			##Conv values
			values=$(python "${EBROOTNGS_DNA}/scripts/CoNVaDING_filter.py" "${combinedFiltered}" "${convadingTotallist}" "${boom}")
		else
			echo -e "${boom}\tCall has too many genes, program stops."
			echo "${genes}" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi
		# Tests if a call has good CoNVaDING values
		if [[ "${values}" == *"CoNVaDING_has_good_values"* ]]
		then
			echo "CoNVaDING has good values, program continues > "
			qscore=$(Q_scores "${combinedFiltered}" "${boom}")
		else
			echo -e "${boom}\tCoNVaDING values are not good, program stops."
			echo "$values" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi


		#Tests if a call has a good Q-score
		if [[ "${qscore}" == *"Q_scores_are_good"* ]]
		then
			echo "Q-scores are good, program continues > "
			shapiro=$(Shapiro_wilk "${combinedFiltered}" "${boom}")
		else
			echo "${qscore}" >> "${longlistPlusPlus}"
			echo -e "${boom}\tQ-scores are not good, program stops."
			trap - EXIT
			exit 0
		fi

		if [[ "${shapiro}" == *"Call_is_final"* ]]
		then
			echo -e "${boom}\tThe call is final."
			awk '{print $0"\tF\tFinal"}' "${combinedFiltered}" >>  "${longlistPlusPlus}"
		else
			echo "${shapiro}" >> "${longlistPlusPlus}"
			echo -e "${boom}\tCall is unreliable, no targets through Shapiro Wilk test."
			cat "${unreliableCalls}"
		fi


	}

	#
	##
	### Convading only tree
	##
	#

	CoNVaDING_only_tree () {
		boom="${1}"
		# Tests if a call has multiple exons or a single exon
		exons=$(Single_exon "${convadingFinallistFiltered}" "${boom}")

		values="unset"
		shapiro="unset"

		if [[ "${exons}" == *"Call_has_multiple exons"* ]]
		then
			echo "Call has multiple exons, program continues > "
			values=$(python "${EBROOTNGS_DNA}/scripts/CoNVaDING_filter.py" "${convadingFinallistFiltered}" "${convadingTotallist}" "${boom}")
		else
			echo -e "${boom}\tCall is single exon, program stops. "
			awk -v b="${boom}" '{if (NR>1){print $0"\t"b"\tSingle_Exon"}}' "${convadingFinallist}" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi

		# Tests if a call has good CoNVaDING values
		if [[ "${values}" == *"CoNVaDING_has_good_values"* ]]
		then
			echo "CoNVaDING has good values, program continues > "
			shapiro=$(Shapiro_wilk "${convadingFinallistFiltered}" "${boom}")
		else
			echo -e "${boom}\tCoNVaDING values are not good, program stops."
			echo "${values}" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi
		if [[ "${shapiro}" == *"Call_is_final"* ]]
		then
			echo -e "${boom}\tThe call is final."
			awk '{print $0"\tC\tFinal"}' "${convadingFinallistFiltered}" >>  "${longlistPlusPlus}"
		else
			echo "${shapiro}" >> "${longlistPlusPlus}"
			echo -e "${boom}\tCall is unreliable, no targets through Shapiro Wilk test."
			cat "${unreliableCalls}"
		fi
		trap - EXIT
		exit 0
	}

	#
	##
	### XHMM only tree
	##
	#

	XHMM_only_tree () {
		boom=${1}
		#Tests if a call has a good Q-score
		qscore=$(Q_scores "${convadingFinallist}" "${boom}")

		values="unset"
		shapiro="unset"
		if [[ "${qscore}" == *"Q_scores_are_good"* ]]
		then
			echo "Q-scores are good, program continues > "
			location_longlist=$(Locations_longlist "${convadingLonglist}")
		else
			echo -e "${boom}\tQ-scores are not good, program stops."
			echo "${qscore}" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi

		# Tests if call is on CoNVaDING longlist
		if [[ "${location_longlist}" == *"Complete_on_CoNVaDING_longlist"* ]]
		then
			echo "Call is present on CoNVaDING longlist, program continues > "
			values=$(python "${EBROOTNGS_DNA}/scripts/CoNVaDING_filter.py" "${convadingLonglistCombinedFiltered}" "${convadingTotallist}" "${boom}")
		elif [[ "${location_longlist}" == *"Partially_on_CoNVaDING_longlist"* ]]
		then
			echo -e "${boom}\tSome calls are on CoNVaDING longlist, program continues. "
			values=$(python "${EBROOTNGS_DNA}/scripts/CoNVaDING_filter.py" "${convadingLonglistCombinedFiltered}" "${convadingTotallist}" "${boom}")

			echo -e "${boom}\tSome calls are NOT on CoNVaDING longlist, program stops. "
			awk '{print $0"\tX\tNo_overlap_on_longlist"}' "${xhmmXcnvFinal}.filtered" >> "${xhmmPlusPlus}"

			trap - EXIT
			exit 0

		elif [[ "${location_longlist}" == *"not_on_CoNVaDING_longlist"* ]]
		then
			echo -e "${boom}\tCall is not on CoNVaDING longlist, program stops. "

			tail -n+2 "${xhmmXcnvFinal}" | awk '{print $0"\tX\tNo_overlap_on_longlist"}' >> "${xhmmPlusPlus}"

			trap - EXIT
			exit 0
		fi

		# Tests if a call has good CoNVaDING values
		if [[ "${values}" == *"CoNVaDING_has_good_values"* ]]
		then
			echo "CoNVaDING has good values, program continues > "
			shapiro=$(Shapiro_wilk "${convadingLonglistCombinedFiltered}" "${boom}")
		else
			echo -e "${boom}\tCoNVaDING values are not good, program stops."
			echo "${values}" >> "${longlistPlusPlus}"
			trap - EXIT
			exit 0
		fi

		if [[ "${shapiro}" == *"Call_is_final"* ]]
		then
			echo -e "${boom}\tThe call is final."
			awk '{print $0"\tX\tFinal"}' "${convadingLonglistCombinedFiltered}" >>  "${longlistPlusPlus}"
		else
			echo "${shapiro}" >> "${longlistPlusPlus}"
			echo -e "${boom}\tCall is unreliable, no targets through Shapiro Wilk test."
			cat "${unreliableCalls}"
		fi

		trap - EXIT
		exit 0
	}
	#
	##
	### MAIN
	##
	#
	ratio=$(Sample_Ratio "${convadingLogfile}")
	convfinalSize=$(cat "${convadingFinallist}" | wc -l)

	if grep -q "${externalSampleID}" "${xhmmXcnvFinal}"
	then
		xhmm="true"
	else
		xhmm="false"
	fi

	if [[ "${xhmm}" == "true" || "${convfinalSize}" -gt 1 ]]
	then
		if [[ "${ratio}" == *"Bad"* ]]
		then
			echo "Failed sample tree for sample: ${externalSampleID}"
			failed_tree=$(Failed_Sample_Tree "F")
			echo "${failed_tree}"
		fi

		if [[ "${ratio}" == *"Good"* ]]
		then
			boom="undefined"
			location=$(Locations "${boom}")
			if [[ "${location}" == *"Call_has_overlap"* ]]
			then
				echo -e "c+x\tCoNVaDING XHMM tree for sample: ${externalSampleID}"
				awk '{print $0"\tC+X\tFinal"}' "${combinedFiltered}" >>  "${longlistPlusPlus}"
				awk '{print $0"\tC+X\tFinal"}' "${combinedFiltered}.XHMM"
				awk '{print $0"\tC+X\tFinal"}' "${combinedFiltered}.XHMM" > "${xhmmPlusPlus}"
				echo "The call is final. Call is made by CoNVaDING and XHMM"
			fi
			if [[ "${location}" == *"CoNVaDING_only_call"* ]]
			then
				echo "CoNVaDING only tree for sample: ${externalSampleID}"
				convading_tree=$(CoNVaDING_only_tree "C")
				echo "${convading_tree}"
			fi

			if [[ "${location}" == *"XHMM_only_call"* ]]
			then
				echo "XHMM only tree for sample: ${externalSampleID}"
				xhmm_tree=$(XHMM_only_tree "X")
				echo "${xhmm_tree}"
			fi
		fi

		if [[ "${ratio}" == *"Extreme_Sample_Ratio"* ]]
		then
			echo "Sample ratio is extremely high"
			awk '{if (NR>1){print $0"\tExtreme Sample Ratio"}}' "${convadingFinallist}" >> "${longlistPlusPlus}"
		fi
	else
		echo "No call made in both programs"
	fi

	echo "write header to ${longlistPlusPlusFinal}"
	echo -e "CHR\tSTART\tSTOP\tGENE\tNUMBER_OF_TARGETS\tNUMBER_OF_TARGETS_PASS_SHAPIRO-WILK_TEST\tABBERATION\tCall\tFilter\tKB\tMID_BP\tTARGETS\tQ_EXACT\tQ_SOME\tQ_NON_DIPLOID\tQ_START\tQ_STOP\tMEAN_RD\tMEAN_ORIG_RD" > "${longlistPlusPlusFinal}"

	count=0
	while read line
	do
		if [[ "${count}" -ne 0 ]]
		then
			if [ -f  "${longlistPlusPlus}" ]
			then
				perl -pi -e 's| ||g' "${longlistPlusPlus}"
				if grep "${line}" "${longlistPlusPlus}"
				then
					grep "${line}" "${longlistPlusPlus}" >> "${longlistPlusPlusFinal}"
				else
					echo -e "${line}\t-\t-"  >> "${longlistPlusPlusFinal}"
				fi
			else
				echo -e "${line}\t-\t-"  >> "${longlistPlusPlusFinal}"
			fi
		fi
		count=$((count+1))
	done<"${convadingLonglist}"
	
	if [ -f "${xhmmPlusPlus}" ]
	then
		SIZE=$(cat "${xhmmPlusPlus}" | wc -l)
		echo "cat ${xhmmPlusPlus} to ${longlistPlusPlusFinal}"
		awk 'BEGIN{OFS="\t"}{$1="replacement"; print $0}' "${xhmmPlusPlus}" > "${xhmmPlusPlus}.tmp"
		while read line; do VAL=$(echo "${line}" | awk '{print $3}'); CHR=$(echo "${VAL}" | awk '{print $1}' FS=":"); POS=$(echo "${VAL}" | awk '{print $2}' FS=":" | awk '{print $1,$2}' FS="-" OFS="\t"); REMAIN=$(echo "${line}" | awk '{for(i=4;i<=NF;++i)printf "\t" $i}' ); FIRST=$(echo "${line}" | awk '{print $1,$2}' FS="\t"); echo -e -n "${FIRST}\t${CHR}\t${POS}\t${REMAIN}\n";done<"${xhmmPlusPlus}.tmp" | awk 'BEGIN {OFS="\t"}{print $3,$4,$5,"-",$10,"-",$2,$18,$19,$6,$8,$9,$11,$12,$13,$14,$15,$16,$17}' >> "${longlistPlusPlusFinal}"
	fi
	
	echo "Calls can be found here: ${longlistPlusPlusFinal}"
	
else
	echo "SKIPPED"
fi

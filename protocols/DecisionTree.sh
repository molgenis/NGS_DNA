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
#string xhmmSampleTxt
#string sampleRatios
#string filteredOut
#string decisionTreeDir
#string unreliableCalls
#string ngsversion
#string longlistPlusPlus
#string overlapLonglistCall

sleep 5

ml $ngsversion
if [ ! -d ${decisionTreeDir} ]
then
	mkdir -p ${decisionTreeDir}
fi

rm -f ${longlistPlusPlus}

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
        		print $3"\tExtreme Sample Ratio"
		}
	}' ${sampleRatios}
}

Locations () {
	tail -n +2 ${convadingFinallist} | awk '{OFS="\t"}{print $1,$2,$3}' > ${convadingBed}
	tail -n +2 ${xhmmXcnvFinal} |  awk '{print $3}' | awk -F'[:-]' '{OFS="\t"}{print $1,$2,$3}' > ${xhmmBed}
	ml BEDTools
	# overlap CoNVaDING and XHMM
	#bedtools intersect -wa -a ${convadingBed} -b ${xhmmBed} | awk '{print "Call has overlap"}'
	bedtools intersect -wa -a ${convadingBed} -b ${xhmmBed} | awk 'BEGIN {OFS="\t"}{print $1, $2, $3}' > ${overlapCall}
	# no overlap
	# CoNVaDING only calls
	#bedtools intersect -v -a ${convadingBed}  -b ${xhmmBed} | awk '{print "CoNVaDING only call"}'
	bedtools intersect -v -a ${convadingBed}  -b ${xhmmBed} | awk 'BEGIN {OFS="\t"}{print $0}' > ${convadingOnlyCall}
	# XHMM only calls
	#bedtools intersect -v -a ${xhmmBed} -b ${convadingBed} | awk '{print "XHMM only call"}'
	bedtools intersect -v -a ${xhmmBed} -b ${convadingBed} | awk 'BEGIN {OFS="\t"}{print $0}' > ${xhmmOnlyCall}
	
	rm -f ${combinedFiltered} ${convadingFinallistFiltered} ${xhmmXcnvFinalFiltered}
	if [ -s ${overlapCall} ]
	then
    		echo "Call has overlap"
        	while read line
        	do
          		if grep -q "$line" ${convadingFinallist}
                	then
                    		grep "$line" ${convadingFinallist}
                	fi
        	done < ${overlapCall} >> ${combinedFiltered}
	fi
	
	if [ -s ${convadingOnlyCall} ]
	then
    		echo "CoNVaDING only call"
        	while read line
        	do
          		if grep -q "$line" ${convadingFinallist}
                	then
                    		grep "$line" ${convadingFinallist}

                	fi
        	done <${convadingOnlyCall} >> ${convadingFinallistFiltered}
	fi
	
	if [ -s ${xhmmOnlyCall} ]
	then
    		awk '{print $1":"$2"-"$3}' ${xhmmOnlyCall} > ${xhmmOnlyCallMerged}
        	echo "XHMM only call"
        	while read line
        	do
          		if grep -q "$line" ${xhmmXcnvFinal}
                	then
                    		grep "$line" ${xhmmXcnvFinal}
                	fi
        	done < ${xhmmOnlyCallMerged} > ${xhmmXcnvFinalFiltered}
	
	fi

}

Locations_longlist () {
	tail -n +2 ${convadingLonglist} | awk '{OFS="\t"}{print $1,$2,$3}' > ${convadingLonglistBed}
	tail -n +2 ${xhmmXcnvFinal} |  awk '{print $3}' | awk -F'[:-]' '{OFS="\t"}{print $1,$2,$3}' > ${xhmmBed}

	ml BEDTools
	
	# overlap CoNVaDING longlist and XHMM
	#bedtools intersect -wa -a ${xhmmBed}  -b ${convadingLonglistBed} | awk '{print $0"\t Call is on CoNVaDING longlist"}'
	bedtools intersect -wa -a ${convadingLonglistBed} -b ${xhmmBed} | awk 'BEGIN {OFS="\t"}{print $0}' > ${overlapLonglistCall}
	
	# no overlap
	# CoNVaDING only calls
	#bedtools intersect -v -a ${convadingLonglistBed} -b ${xhmmBed}  | awk '{print $0"\t CoNVaDING only call"}'
	
	# XHMM only calls
	#bedtools intersect -v -a ${xhmmBed}  -b ${convadingLonglistBed} | awk '{print $0"\t XHMM only call"}'
	bedtools intersect -v -a ${xhmmBed}  -b ${convadingLonglistBed} | awk 'BEGIN {OFS="\t"}{print $0}' > ${xhmmOnlyCall}
	
	cat ${xhmmOnlyCall}	
	rm -f ${convadingLonglistCombinedFiltered}
	sizeOverlapLonglist=$(cat ${overlapLonglistCall} | wc -l)
	if [ -s ${overlapLonglistCall} ]
	then
		
        	while read line
                do
                	if grep -q "$line" ${convadingLonglist}
                       	then
                       		grep "$line" ${convadingLonglist} >> ${convadingLonglistCombinedFiltered}
                      	fi
               	done <${overlapLonglistCall} >> ${convadingLonglistCombinedFiltered}

		sizeXhmmXcnvFinal=$(($(cat ${xhmmXcnvFinal} | wc -l) -1))
		if [ ${sizeXhmmXcnvFinal} == ${sizeOverlapLonglist} ]
		then
			echo "Complete on CoNVaDING longlist"
		elif [ ${sizeXhmmXcnvFinal} > ${sizeOverlapLonglist} ]
		then
			echo "Partially on CoNVaDING longlist"
			while read line
                	do
                  		if grep -q "$line" ${xhmmXcnvFinal}
	                       	then
        	               	    	grep "$line" ${xhmmXcnvFinal}
				fi
			done<${xhmmOnlyCall} >> ${xhmmXcnvFinal}.filtered
		fi
	else
		echo "not on CoNVaDING longlist"

	fi
	
}

Single_exon () {
	awk -v boom="$2" 'BEGIN{OFS="\t"}{
	if($5 == 1){
		print $0"\t"boom"\tSingle exon call"}
	if($5 > 1){
		print "Call has multiple exons"}}' $1
}

Number_of_genes () {
	
	call=$(tail -n +2 ${convadingFinallist} | awk '{OFS="\t"}{print $0}')
	no_of_genes=$(tail -n +2  ${convadingFinallist} | awk '{print $4}' | sort | uniq | wc -l)
	
	if [ $no_of_genes -lt 4 ]
	then
    		echo "Good number of genes"
	else
		head -1 ${convadingFinallist} 
    		tail -n +2 ${convadingFinallist} | awk -v boom="$2" '{print $0"\t"boom"\tToo many genes"}' 
		#echo "${call}\tToo many genes"
	fi
}

Q_scores () {
	if grep ${externalSampleID} ${xhmmXcnvFinal}
	then
    		head -1 ${xhmmXcnvFinal} > ${xhmmSampleTxt}
        	grep ${externalSampleID} ${xhmmXcnvFinal} >> ${xhmmSampleTxt}
	
        	awk -v b="$2" 'BEGIN{OFS="\t"}{
                	if(NR>1 && $10 >= 13 && $11 >= 13){
                        	print $10,$11,"Q_scores are good"}
                	else{
                     		if(NR==1){print $0"\tCall\tFilter"}
                        	else{
                             		print $0"\t"b"\tQ_scores too low"
                        	}
                	}
        	}' ${xhmmSampleTxt}
	fi
}

Shapiro_wilk () {

 awk -v b="$2" 'BEGIN{OFS="\t"}{
                if($5 == $6){
                        print $0,b"\tCall is final"
                }
                if($6 == 0){
                        print $0,b"\tunreliable call"
                }
                else{
                     	print $0,b"\tCall is final"
                }
        }' $1
}
#
##
### Failed sample tree
##
#
Failed_Sample_Tree () {
	boom=$1
	# Tests if locations overlap
	location=$(Locations)
	exons="unset"
	values="unset"
	qscore="unset"
	shapiro="unset"
	Call=""
	if [[ "${location}" == *"Call has overlap"* ]]
	then
    		echo "Call has overlap, program continues > "
	      	exons=$(Single_exon ${combinedFiltered} $boom)
	else
    		echo -e "$boom\tCall has no overlap, program stops. "
		awk -v b="$boom" '{if (NR==1){print $0"\tCall\tFilter"}else{print $0"\t"b"\tNo overlap"}}' ${convadingFinallist} >> ${longlistPlusPlus}
        	trap - EXIT
                exit 0
	fi
	
	
	# Tests if a call has multiple exons or a single exon
	if [[ "${exons}" == *"Call has multiple exons"* ]]
	then
    		echo "Call has multiple exons, program continues > "
	       	genes=$(Number_of_genes ${combinedFiltered} $boom)
	else
    		echo -e "$boom\tCall is single exon, program stops. "
		echo "${exons}" >> ${longlistPlusPlus}
        	trap - EXIT
                exit 0
	fi
	
	
	# Tests if a call has a good number of genes
	if [[ "${genes}" == *"Good number of genes"* ]]
	then
    		echo "Call has a good number of genes, program continues > "
        	##Conv values
		values=$(python ${EBROOTNGS_DNA}/CoNVaDING_filter.py ${combinedFiltered} ${convadingTotallist} $boom)
	else
    		echo -e "$boom\tCall has too many genes, program stops."
		echo "${genes}" >> ${longlistPlusPlus}
        	trap - EXIT
                exit 0
	fi
	
	
	# Tests if a call has good CoNVaDING values
	if [[ "${values}" == *"CoNVaDING has good values"* ]]
	then
    		echo "CoNVaDING has good values, program continues > "
	     	qscore=$(Q_scores ${combinedFiltered} )
	else
    		echo -e "$boom\tCoNVaDING values are not good, program stops."
		echo $values >> ${longlistPlusPlus}
        	Callinfo=$(tail -n +2 ${combinedFiltered} | awk '{OFS="\t"}{print $0}')
  #      	echo ${externalSampleID} ${Callinfo} "Bad CoNVaDING values" >> ${rejectedCalls}
        	trap - EXIT
                exit 0
	fi
	
	
	#Tests if a call has a good Q-score
	if [[ "${qscore}" == *"Q_scores are good"* ]]
	then
    		echo "Q-scores are good, program continues > "
        	shapiro=$(Shapiro_wilk ${combinedFiltered} $boom)
		
	else
		echo $qscore >> ${longlistPlusPlus}
 		echo -e "$boom\tQ-scores are not good, program stops."
        	trap - EXIT
                exit 0
	fi

	if [[ "${shapiro}" == *"Call is final"* ]]
       	then
       		echo -e "$boom\tThe call is final."
		head -1 ${convadingFinallist} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}
                awk '{print $0"\tC+X\tFinal"}' "${combinedFiltered}" >>  ${longlistPlusPlus}
       	else
       		echo $shapiro >> ${longlistPlusPlus}        
		echo -e "$boom\tCall is unreliable, no targets through Shapiro Wilk test."
              	cat ${unreliableCalls}
        fi
	

}

#
##
### Convading only tree
##
#

CoNVaDING_only_tree () {
	boom=$1
	# Tests if a call has multiple exons or a single exon
	exons=$(Single_exon ${convadingFinallistFiltered} $boom)

	values="unset"
	shapiro="unset"

	if [[ "${exons}" == *"Call has multiple exons"* ]]
	then
    		echo "Call has multiple exons, program continues > "
		values=$(python ${EBROOTNGS_DNA}/CoNVaDING_filter.py ${convadingFinallistFiltered} ${convadingTotallist} $boom)
	else
    		echo -e "$boom\tCall is single exon, program stops. "
		awk -v b="$boom" '{if (NR==1){print $0"\tCall\tFilter"}else{print $0"\t"b"\tSingle Exon"}}' ${convadingFinallist} >> ${longlistPlusPlus}
        	trap - EXIT
                exit 0
	fi
		
	# Tests if a call has good CoNVaDING values
	if [[ "${values}" == *"CoNVaDING has good values"* ]]
	then
    		echo "CoNVaDING has good values, program continues > "
        	shapiro=$(Shapiro_wilk ${convadingFinallistFiltered} $boom)
	else
    		echo -e "$boom\tCoNVaDING values are not good, program stops."
		head -1 ${convadingFinallist} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}
		echo "$values" >> ${longlistPlusPlus}
        	trap - EXIT
                exit 0
	fi
	
	if [[ "${shapiro}" == *"Call is final"* ]]
        then
            	echo -e "$boom\tThe call is final."
                head -1 ${convadingFinallist} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}
                awk '{print $0"\tC+X\tFinal"}' "${convadingFinallistFiltered}" >>  ${longlistPlusPlus}
        else
            	echo "$shapiro" >> ${longlistPlusPlus}
                echo -e "$boom\tCall is unreliable, no targets through Shapiro Wilk test."
                cat ${unreliableCalls}
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
	boom=$1
	#Tests if a call has a good Q-score
	qscore=$(Q_scores ${convadingFinallist} $boom)
        values="unset"
        shapiro="unset"
	if [[ "${qscore}" == *"Q_scores are good"* ]]
	then
    		echo "Q-scores are good, program continues > "
        	location_longlist=$(Locations_longlist ${convadingLonglist})
	else
    		echo -e "$boom\tQ-scores are not good, program stops."
		echo "$qscore" >> ${longlistPlusPlus}
        	trap - EXIT
                exit 0
	fi
	
	# Tests if call is on CoNVaDING longlist
	if [[ "${location_longlist}" == *"Complete on CoNVaDING longlist"* ]]
	then
    		echo "Call is present on CoNVaDING longlist, program continues > "
        	values=$(python ${EBROOTNGS_DNA}/CoNVaDING_filter.py ${convadingLonglistCombinedFiltered} ${convadingTotallist} $boom)
	elif [[ "${location_longlist}" == *"Partially on CoNVaDING longlist"* ]]
	then
		echo -e "$boom\tSome calls are on CoNVaDING longlist, program continues. "
		values=$(python ${EBROOTNGS_DNA}/CoNVaDING_filter.py ${convadingLonglistCombinedFiltered} ${convadingTotallist} $boom)

		echo -e "$boom\tSome calls are NOT on CoNVaDING longlist, program stops. "
		echo "" >>  ${longlistPlusPlus}
		head -1 ${xhmmXcnvFinal} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}
		awk '{print $0"\tX\tNo overlap on longlist"}' ${xhmmXcnvFinal}.filtered >>  ${longlistPlusPlus}

		trap - EXIT
                exit 0

	elif [[ "${location_longlist}" == *"not on CoNVaDING longlist"* ]]
	then	
    		echo -e "$boom\tCall is not on CoNVaDING longlist, program stops. "

		head -1 ${xhmmXcnvFinal} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}
		tail -n+2 ${xhmmXcnvFinal} | awk '{print $0"\tX\tNo overlap on longlist"}' >> ${longlistPlusPlus}

        	trap - EXIT
                exit 0
	fi
	
	# Tests if a call has good CoNVaDING values
	if [[ "${values}" == *"CoNVaDING has good values"* ]]
	then
    		echo "CoNVaDING has good values, program continues > "
        	shapiro=$(Shapiro_wilk ${convadingLonglistCombinedFiltered} $boom)
	else
		echo -e "$boom\tCoNVaDING values are not good, program stops."
                head -1 ${convadingFinallist} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}

                echo "$values" >> ${longlistPlusPlus}		
        	trap - EXIT
                exit 0
	fi

	if [[ "${shapiro}" == *"Call is final"* ]]
        then
            	echo -e "$boom\tThe call is final."
                head -1 ${convadingFinallist} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}
                awk '{print $0"\tX\tFinal"}' "${convadingLonglistCombinedFiltered}" >>  ${longlistPlusPlus}
        else
            	echo "$shapiro" >> ${longlistPlusPlus}
                echo -e "$boom\tCall is unreliable, no targets through Shapiro Wilk test."
                cat ${unreliableCalls}
        fi

	trap - EXIT
        exit 0
	
}
#
##
### MAIN
##
#
ratio=$(Sample_Ratio ${convadingLogfile})
convfinal=$(cat ${convadingFinallist} | wc -l)

if grep -q "${externalSampleID}" ${xhmmXcnvFinal}
then
        xhmm="true"
else
        xhmm="false"
fi

if [[ $xhmm == "true" || $convfinal -gt 1 ]]
then
        if [[ "${ratio}" == *"Bad"* ]]
        then
                echo "Failed sample tree for sample: ${externalSampleID}"
                failed_tree=$(Failed_Sample_Tree "F")
                echo $failed_tree
        fi

        if [[ "${ratio}" == *"Good"* ]]
        then
                location=$(Locations)
                if [[ "${location}" == *"Call has overlap"* ]]
                then
                        echo -e "c+x\tCoNVaDING XHMM tree for sample: ${externalSampleID}"
                        #CallCX=$(grep "$line" ${combinedFiltered})
			head -1 ${convadingFinallist} | awk '{print $0"\tCall\tFilter"}' >>  ${longlistPlusPlus}
			awk '{print $0"\tC+X\tFinal"}' "${combinedFiltered}" >>  ${longlistPlusPlus}
			echo "The call is final. Call is made by CoNVaDING and XHMM"

                fi
                if [[ "${location}" == *"CoNVaDING only call"* ]]
                then
                        echo "CoNVaDING only tree for sample: ${externalSampleID}"
                        convading_tree=$(CoNVaDING_only_tree "C")
			echo $convading_tree
                fi

                if [[ "${location}" == *"XHMM only call"* ]]
                then
                        echo "XHMM only tree for sample: ${externalSampleID}"
                        xhmm_tree=$(XHMM_only_tree "X")
		        echo $xhmm_tree
                fi

        fi

        if [[ "${ratio}" == *"Extreme Sample Ratio"* ]]
        then
                echo "Sample ratio is extremely high"
		awk '{if (NR==1){print $0"\tCall\tFilter"}else{print $0"\tExtreme Sample Ratio"}}' ${convadingFinallist} >>  ${longlistPlusPlus}
        fi
else
        echo "No call made in both programs"
fi

echo "Calls can be found here: ${longlistPlusPlus}"

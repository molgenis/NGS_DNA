. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e
set -u

for line in ${INPUTFILE}
do
	ratio=$(sh Sample_Ratio.sh ${step3path}/${sample}.${logfile})
        convfinal=$(cat ${step5path}/${sample}.${finallist} | wc -l)
	Call_informatie=$(tail -n +2 ${step5path}/${sample}.${finallist} | awk '{OFS="\t"}{print $0}')

        if grep -q "${sample}" ${xhmmdir}/${xhmmsample}
        then
                xhmm="true"
        else
                xhmm="false"
        fi
        if [[ $xhmm == "true" || $convfinal -gt 1 ]]
        then
		if [[ $ratio == *"Bad"* ]]
                then
                        echo "Failed sample tree for sample: ${sample}"
			echo "Call: ${Call_informatie}"
                        failed_tree=$(sh Failed_sample_tree.sh ${step5path}/${sample}.${finallist} "f")
                        echo $failed_tree
                fi

                if [[ $ratio == *"Good"* ]]
                then
			location=$(sh Locations.sh ${step5path}/${sample}.${finallist})
			if [[ $location == *"Call has overlap"* ]]
                        then
                                echo "CoNVaDING XHMM tree for sample: ${sample}"
				echo "Call: ${Call_informatie}"
				#CallCX=$(grep "$line" ${step5path}/${sample}.${finallist_combined_filtered})
				echo "The call is final. Call is made by CoNVaDING and XHMM"
		
			fi		
	                if [[ $location == *"CoNVaDING only call"* ]]
        	        then
                	        echo "CoNVaDING only tree for sample: ${sample}"
				echo "Call: ${Call_informatie}"
                                convading_tree=$(sh CoNVaDING_only_tree.sh ${step5path}/${sample}.${finallist} "c")
                                echo $convading_tree
                        fi

                        if [[ $location == *"XHMM only call"* ]]
                        then
                        	echo "XHMM only tree for sample: ${sample}" 
				xhmm_tree=$(sh XHMM_only_tree.sh ${step5path}/${sample}.${finallist} "x")
				echo $xhmm_tree
	    	        fi
                
		fi

                if [ -f ${sample}_Filterd_out.txt ]
                then
                        echo "Sample ratio is extremely high"
                fi
        else
                echo "No call made in both programs"
        fi
done
exit


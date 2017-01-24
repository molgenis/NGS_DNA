. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e 
set -u

#Tests if a call has a good Q-score
qscore=$(sh Q_scores.sh ${step5path}/${sample}.${finallist})
if [[ $qscore == *"Q_scores are good"* ]]
then
        echo "Q-scores are good, program continues > "
        location_longlist=$(sh Locations_longlist.sh ${step3path}/${sample}.${longlist})	
else
        echo "Q-scores are not good, program stops."
        exit 0
fi


# Tests if call is on CoNVaDING longlist
if [[ $location_longlist == *"Call is on CoNVaDING longlist"* ]]
then
        echo "Call is present on CoNVaDING longlist, program continues > "
        values=$(sh Conv_values.sh ${step3path}/${sample}.${longlist} ${step3path}/${sample}.${totallist})
else
        echo "Call is not on CoNVaDING longlist, program stops. "
        exit 0
fi



# Tests if a call has good CoNVaDING values
if [[ $values == *"CoNVaDING has good values"* ]]
then
        echo "CoNVaDING has good values, program continues > "
        shapiro=$(sh Shapiro_wilk.sh ${step3path}/${sample}.${longlist})
else
        echo "CoNVaDING values are not good, program stops."
	Callinformatie=$(tail -n +2 ${step3path}/${sample}.${longlist} | awk '{OFS="\t"}{print $0}')
        echo ${sample} ${Callinformatie} "Bad CoNVaDING values" >> ${sample}_Rejected_Calls.txt
        exit 0
fi



# Tests the results of the Shapiro Wilk test
if [[ $shapiro == *"Call is final"* ]]
then
	echo "The call is final."
else
        echo "Call is unreliable, no targets through Shapiro Wilk test."
fi
exit


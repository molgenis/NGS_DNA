. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e 
set -u


# Tests if a call has multiple exons or a single exon
exons=$(sh Single_exon.sh ${step5path}/${sample}.${finallist_filtered})
if [[ $exons == *"Call has multiple exons"* ]]
then
        echo "Call has multiple exons, program continues > "
        values=$(sh Conv_values.sh ${step5path}/${sample}.${finallist_filtered} ${step3path}/${sample}.${totallist})
else
        echo "Call is single exon, program stops. "
        exit 0
fi



# Tests if a call has good CoNVaDING values
if [[ $values == *"CoNVaDING has good values"* ]]
then
        echo "CoNVaDING has good values, program continues > "
        shapiro=$(sh Shapiro_wilk.sh ${step5path}/${sample}.${finallist_filtered})
else
        echo "CoNVaDING values are not good, program stops."
        Callinformatie=$(tail -n +2 ${step5path}/${sample}.${finallist_filtered} | awk '{OFS="\t"}{print $0}')
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


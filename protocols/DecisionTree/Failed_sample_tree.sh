. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e 
set -u


# Tests if locations overlap
location=$(sh Locations.sh ${step5path}/${sample}.${finallist})
if [[ $location == *"Call has overlap"* ]]
then
        echo "Call has overlap, program continues > "
        exons=$(sh Single_exon.sh ${step5path}/${sample}.${finallist_combined_filtered})
else
        echo "Call has no overlap, program stops. "
        exit 0
fi


# Tests if a call has multiple exons or a single exon
if [[ $exons == *"Call has multiple exons"* ]]
then
        echo "Call has multiple exons, program continues > "
        genes=$(sh Number_of_genes.sh ${step5path}/${sample}.${finallist_combined_filtered})
else
        echo "Call is single exon, program stops. "
        exit 0
fi


# Tests if a call has a good number of genes
if [[ $genes == *"Good number of genes"* ]]
then
        echo "Call has a good number of genes, program continues > "
        values=$(sh Conv_values.sh ${step5path}/${sample}.${finallist_combined_filtered} ${step3path}/${sample}.${totallist})
else
        echo "Call has to many genes, program stops."
        exit 0
fi


# Tests if a call has good CoNVaDING values
if [[ $values == *"CoNVaDING has good values"* ]]
then
        echo "CoNVaDING has good values, program continues > "
        qscore=$(sh Q_scores.sh ${step5path}/${sample}.${finallist_combined_filtered})
else
        echo "CoNVaDING values are not good, program stops."
	Callinfo=$(tail -n +2 ${step5path}/${sample}.${finallist_combined_filtered} | awk '{OFS="\t"}{print $0}')
        echo ${sample} ${Callinfo} "Bad CoNVaDING values" >> ${sample}_Rejected_Calls.txt
        exit 0
fi


#Tests if a call has a good Q-score
if [[ $qscore == *"Q_scores are good"* ]]
then
        echo "Q-scores are good, program continues > "
        shapiro=$(sh Shapiro_wilk.sh ${step5path}/${sample}.${finallist_combined_filtered})
else
        echo "Q-scores are not good, program stops."
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


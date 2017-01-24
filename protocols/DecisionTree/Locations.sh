. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e
set -u

tail -n +2 ${step5path}/${sample}.${finallist} | awk '{OFS="\t"}{print $1,$2,$3}' > ${tmpdirectory}/${sample}_CoNVaDING.bed
tail -n +2 ${xhmmdir}/${xhmmsample} |  awk '{print $3}' | awk -F'[:-]' '{OFS="\t"}{print $1,$2,$3}' > ${tmpdirectory}/${sample}_XHMM.bed

ml BEDTools
# overlap CoNVaDING and XHMM
#bedtools intersect -wa -a ${tmpdirectory}/${sample}_CoNVaDING.bed -b ${tmpdirectory}/${sample}_XHMM.bed | awk '{print "Call has overlap"}'
bedtools intersect -wa -a ${tmpdirectory}/${sample}_CoNVaDING.bed -b ${tmpdirectory}/${sample}_XHMM.bed | awk 'BEGIN {OFS="\t"}{print $1, $2, $3}' > ${tmpdirectory}/${sample}_Call_with_overlap.txt


# no overlap
# CoNVaDING only calls
#bedtools intersect -v -a ${tmpdirectory}/${sample}_CoNVaDING.bed -b ${tmpdirectory}/${sample}_XHMM.bed | awk '{print "CoNVaDING only call"}'
bedtools intersect -v -a ${tmpdirectory}/${sample}_CoNVaDING.bed -b ${tmpdirectory}/${sample}_XHMM.bed | awk 'BEGIN {OFS="\t"}{print $0}' > ${tmpdirectory}/${sample}_CoNVaDING_only_call.txt


# XHMM only calls
#bedtools intersect -v -a ${tmpdirectory}/${sample}_XHMM.bed -b ${tmpdirectory}/${sample}_CoNVaDING.bed | awk '{print "XHMM only call"}'
bedtools intersect -v -a ${tmpdirectory}/${sample}_XHMM.bed -b ${tmpdirectory}/${sample}_CoNVaDING.bed | awk 'BEGIN {OFS="\t"}{print $0}' > ${tmpdirectory}/${sample}_XHMM_only_call.txt
 

rm -f ${step5path}/${sample}.${finallist_combined_filtered} ${step5path}/${sample}.${finallist_filtered} ${xhmmdir}/${sample}.${xhmm_filtered}
if [ -s ${tmpdirectory}/${sample}_Call_with_overlap.txt ]
then
	echo "Call has overlap"
	while read line
	do
		if grep -q "$line" ${step5path}/${sample}.${finallist}
		then 
			grep "$line" ${step5path}/${sample}.${finallist}
		fi
 	done <${tmpdirectory}/${sample}_Call_with_overlap.txt >> ${step5path}/${sample}.${finallist_combined_filtered}
fi

if [ -s ${tmpdirectory}/${sample}_CoNVaDING_only_call.txt ]
then
	echo "CoNVaDING only call"
	while read line
	do
		if grep -q "$line" ${step5path}/${sample}.${finallist}
		then 
			grep "$line" ${step5path}/${sample}.${finallist}
		fi
	done <${tmpdirectory}/${sample}_CoNVaDING_only_call.txt >> ${step5path}/${sample}.${finallist_filtered}
fi

if [ -s ${tmpdirectory}/${sample}_XHMM_only_call.txt ]
then
	awk '{print $1":"$2"-"$3}' ${tmpdirectory}/${sample}_XHMM_only_call.txt > ${tmpdirectory}/${sample}_XHMM_only_call.columnsMerged.txt
	echo "XHMM only call"
	while read line 
	do 	
		if grep -q "$line" ${xhmmdir}/${xhmmsample}
		then
			grep "$line" ${xhmmdir}/${xhmmsample} 
		fi
	done <${tmpdirectory}/${sample}_XHMM_only_call.columnsMerged.txt > ${xhmmdir}/${sample}.${xhmm_filtered}

fi
#exit

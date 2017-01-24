. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg

tail -n +2 ${step3path}/${sample}.${longlist} | awk '{OFS="\t"}{print $1,$2,$3}' > ${tmpdirectory}/${sample}_CoNVaDING_longlist.bed
tail -n +2 ${xhmmdir}/${xhmmsample} |  awk '{print $3}' | awk -F'[:-]' '{OFS="\t"}{print $1,$2,$3}' > ${tmpdirectory}/${sample}_XHMM.bed

ml BEDTools

# overlap CoNVaDING longlist and XHMM
#bedtools intersect -wa -a ${tmpdirectory}/${sample}_XHMM.bed -b ${tmpdirectory}/${sample}_CoNVaDING_longlist.bed | awk '{print $0"\t Call is on CoNVaDING longlist"}'
bedtools intersect -wa -a ${tmpdirectory}/${sample}_XHMM.bed -b ${tmpdirectory}/${sample}_CoNVaDING_longlist.bed | awk 'BEGIN {OFS="\t"}{print $0}' > ${tmpdirectory}/${sample}_Call_with_overlap_longlist.txt

# no overlap
# CoNVaDING only calls
#bedtools intersect -v -a ${tmpdirectory}/${sample}_CoNVaDING_longlist.bed -b ${tmpdirectory}/${sample}_XHMM.bed | awk '{print $0"\t CoNVaDING only call"}'

# XHMM only calls
#bedtools intersect -v -a ${tmpdirectory}/${sample}_XHMM.bed -b ${tmpdirectory}/${sample}_CoNVaDING_longlist.bed | awk '{print $0"\t XHMM only call"}'
#bedtools intersect -v -a ${tmpdirectory}/${sample}_XHMM.bed -b ${tmpdirectory}/${sample}_CoNVaDING_longlist.bed | awk 'BEGIN {OFS="\t"}{print $0}' > ${tmpdirectory}/${sample}_XHMM_only_call.txt


rm -f ${step3path}/${sample}.${longlist_combined_filtered} 
if [ -s ${tmpdirectory}/${sample}_Call_with_overlap_longlist.txt ]
then
        echo "Call is on CoNVaDING longlist"
        while read line
                do 
			if grep -q "$line" ${step3path}/${sample}.${longlist}
			then
				grep "$line" ${step3path}/${sample}.${longlist}
			fi
                done <${tmpdirectory}/${sample}_Call_with_overlap_longlist.txt >> ${step3path}/${sample}.${longlist_combined_filtered}
fi
exit

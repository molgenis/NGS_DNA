. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e
set -u


if grep ${sample} ${xhmmdir}/${xhmmsample}
then
	head -1 ${xhmmdir}/${xhmmsample} > ${tmpdirectory}/${sample}_xhmm.txt
	grep ${sample} ${xhmmdir}/${xhmmsample} >> ${tmpdirectory}/${sample}_xhmm.txt

	awk -v SAMP=$sample 'BEGIN{OFS="\t"}{
		if(NR>1 && $10 >= 13 && $11 >= 13){
        		print $10,$11,"Q_scores are good"}
		else{
			if(NR==1){print $0 > SAMP"_Rejected_Calls.txt"}
			else{
        			print $0"\tQ score to low" >> SAMP"_Rejected_Calls.txt"
			}
		}
	}' ${tmpdirectory}/${sample}_xhmm.txt
fi


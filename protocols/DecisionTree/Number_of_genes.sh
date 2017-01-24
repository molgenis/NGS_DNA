. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e
set -u


Call=$(tail -n +2 ${step5path}/${sample}.${finallist} | awk '{OFS="\t"}{print $0}')
Number_of_genes=$(tail -n +2  ${step5path}/${sample}.${finallist} | awk '{print $4}' | sort | uniq | wc -l)

if [ $Number_of_genes -lt 4 ]
then
        echo "Good number of genes"
else
        echo $Call_informatie"\tTo Many Genes" > ${sample}_Rejected_Calls.txt
fi

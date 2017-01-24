. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e
set -u


# Grep Sample Ratio and label it depending on value

j=$(grep SAMPLE_RATIO: $INPUTFILE)
echo -e "${INPUTFILE%%.*}\t$j" > ${tmpdirectory}/${sample}_Sample_ratios_cardioset.txt

awk -v SAMP=$sample 'BEGIN{OFS="\t"}{
if($3 <= "0.09"){
        print "Good"}
if($3 > "0.09" && $3 <= "0.2"){
        print "Bad"}
if($3 > "0.2"){
        print $1, $3"\tExtreme Sample Ratio" > SAMP"_Filterd_out.txt"}}' ${tmpdirectory}/${sample}_Sample_ratios_cardioset.txt


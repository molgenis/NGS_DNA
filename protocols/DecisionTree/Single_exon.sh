. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e
set -u


awk -v SAMP=$sample 'BEGIN{OFS="\t"}NR>1{
if($5 == 1){
        print $0"\tSingle exon call" >> SAMP"_Rejected_Calls.txt"}
if($5 > 1){
        print "Call has multiple exons"}}' $1


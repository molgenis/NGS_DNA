. /groups/umcg-gdio/tmp04/umcg-mtfrans/CNV_detectie_scripts/Config.cfg
set -e
set -u


awk -v SAMP=$sample 'BEGIN{OFS="\t"}NR>1{
	if($5 == $6){
        	print "Call is final"}
        if($6 == 0){
                print $0 >> SAMP"_Unreliable_calls.txt"}
        else{
                print "Call is final"}}' $1


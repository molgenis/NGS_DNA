#MOLGENIS walltime=23:59:00 mem=4gb

#string tmpName
#string	project
#string logsDir 
#string groupname
#string projectResultsDir
#string ngsUtilsVersion

module load ngs-utils

rm -rf /home/umcg-molgenis/NGS_DNA/output
count=0
for i in PlatinumSubset PlatinumSample_NA12878 PlatinumSample_NA12891
do
	mkdir -p /home/umcg-molgenis/NGS_DNA/output/${i}
	
	${EBROOTNGSMINUTILS}/vcf-compare_2.0.sh -1 /home/umcg-molgenis/NGS_DNA/${i}_True.final.vcf.gz -2 ${projectResultsDir}/variants/${i}.final.vcf.gz -o /home/umcg-molgenis/NGS_DNA/output/${i}/
	
	if [[ -f /home/umcg-molgenis/NGS_DNA/output/${i}/notInVcf1.txt || -f /home/umcg-molgenis/NGS_DNA/output/${i}/notInVcf2.txt || -f /home/umcg-molgenis/NGS_DNA/output/${i}/inconsistent.txt ]]
	then
		echo "${i}: there are differences between the test and the original output"
        	echo "please fix the bug or update this test"
        	echo "the stats can be found here: /home/umcg-molgenis/NGS_DNA/output/${i}/vcfStats.txt"
        	exit 1
	else
		echo "${i}: test succeeded"
		head -2 /home/umcg-molgenis/NGS_DNA/output/${i}/vcfStats.txt	
		count=$((count + 1)
	fi
done

if [ ${count} == "3" ]
then
	echo "Autotest complete"
	echo "the statistics of the 3 tests can be found here: /home/umcg-molgenis/NGS_DNA/output/"
else
	echo "interesting, this cannot be true, count is ${count}"		
fi

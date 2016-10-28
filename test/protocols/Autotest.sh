#MOLGENIS walltime=23:59:00 mem=4gb

#string tmpName
#string	project
#string logsDir 
#string groupname
#string projectResultsDir
#string ngsUtilsVersion

rm -rf /home/umcg-molgenis/NGS_DNA/output

module load ngs-utils

${EBROOTNGSMINUTILS}/vcf-compare_2.0.sh -1 ${projectResultsDir}/variants/PlatinumSample.final.vcf.gz -2 /home/umcg-molgenis/NGS_DNA/PlatinumSample_True.final.vcf.gz -o /home/umcg-molgenis/NGS_DNA/output


if [[ -f /home/umcg-molgenis/NGS_DNA/output/notInVcf1.txt || -f /home/umcg-molgenis/NGS_DNA/output/notInVcf2.txt || -f /home/umcg-molgenis/NGS_DNA/output/inconsistent.txt ]]
then
	echo "there are differences between the test and the original output"
        echo "please fix the bug or update this test"
        echo "the stats can be found here: /home/umcg-molgenis/NGS_DNA/output/vcfStats.txt"
        exit 1
else
	echo "test succeeded"
	head -2 /home/umcg-molgenis/NGS_DNA/output/vcfStats.txt

fi

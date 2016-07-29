#MOLGENIS walltime=23:59:00 mem=4gb

#string tmpName
#string	project
#string logsDir 
#string groupname
#string projectResultsDir


module load ngs-utils

${EBROOTNGSMINUTILS}/vcf-compare_2.0.sh -vcf1 ${projectResultsDir}/variants/PlatinumSample.final.vcf -vcf2 /home/molgenis/PlatinumSample_True.final.vcf -o /home/umcg-molgenis/output


if [[ $difference == "" ]]
then
	echo "test succeeded"
else
	echo "there are differences between the test and the original output"
	echo "please fix the bug or update this test"
	echo $difference	
	exit -1
fi

#MOLGENIS walltime=23:59:00 mem=4gb

#string tmpName
#string	project
#string logsDir 
#string groupname
#string projectResultsDir

difference=$(diff -y ${projectResultsDir}/variants/PlatinumSample.final.vcf /home/molgenis/PlatinumSample.final.vcf)

if [[ $difference == "" ]]
then
	echo "test succeeded"
else
	echo "there are differences between the test and the original output"
	echo "please fix the bug or update this test"
	echo $difference	
	exit -1
fi

#string tmpName
#string projectJobsDir
#string intermediateDir
#string project
#string logsDir 
#string groupname
#string capturingKit
#string dataDir
#string gavinOutputFinalMergedRLV
#string samplePrefix

grep -v "^#" "${gavinOutputFinalMergedRLV}" | awk '{print $1}' | sort -V | uniq > "${samplePrefix}.allChromosomes.txt"

var=$(diff "${intermediateDir}/allChromosomes.txt" "${samplePrefix}.allChromosomes.txt" | wc -l)

if [[ "${var}" == 0 ]]
then
	echo "all chromosomes are found back in the output"

else
	echo "not all chromosomes are found back!!"
	diff "${intermediateDir}/allChromosomes.txt" "${samplePrefix}.allChromosomes.txt"
	exit 1
fi

#string tmpName
#string projectJobsDir
#string intermediateDir
#string project
#string logsDir 
#string groupname
#string capturingKit
#string dataDir
#string gavinOutputFinalMergedRLV
#string sampleNameID

grep -v "^#" "${gavinOutputFinalMergedRLV}" | awk '{print $1}' | sort -V | uniq > "${sampleNameID}.allChromosomes.txt"

var=$(diff "${intermediateDir}/allChromosomes.txt" "${sampleNameID}.allChromosomes.txt" | wc -l)

if [[ "${var}" == 0 ]]
then
	echo "all chromosomes are found back in the output"

else
	echo "not all chromosomes are found back!!"
	diff "${intermediateDir}/allChromosomes.txt" "${sampleNameID}.allChromosomes.txt"
	exit 1
fi

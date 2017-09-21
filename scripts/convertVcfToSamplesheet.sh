set -e
set -u

function showHelp() {
	#
	# Display commandline help on STDOUT.
	#
	cat <<EOH
===============================================================================================================
Usage:
	$(basename $0) OPTIONS
Options:
	-h	Show this help.
	Required:
	-i	inputFile (vcf format)
	-c	capturingKit (name of capturingKit (e.g. Agilent\/ONCO_v3)
	-p	projectName
	Optional:
	-w	workDir (default is this directory)

Output will be written in workDir with the name: {projectName}.csv
===============================================================================================================
EOH
	trap - EXIT
	exit 0
}

while getopts "i:p:c:h" opt; 
do
	case $opt in h)showHelp;; w)workDir="${OPTARG}";; i)inputFile="${OPTARG}";; p)projectName="${OPTARG}";; c)capturingKit="${OPTARG}";; 
	esac
done


if [[ -z "${inputFile:-}" ]]; then
	echo -e '\nERROR: Must specify an vcf as inputfile\n'

	showHelp
	exit 1
fi

if [[ -z "${workDir:-}" ]]; then
	workDir=$(pwd)
fi
if [[ -z "${capturingKit:-}" ]]; then
	echo -e '\nERROR: Must specify a capturingKit\n'
	exit 1

fi
if [[ -z "${projectName:-}" ]]; then
	echo -e '\nERROR: Must specify a projectName\n'
	exit 1

fi


SAMPLES=($(awk '{if ($1 ~ /#CHROM/){print $0} }' "${inputFile}" | awk '{for(i=10;i<=NF;++i)print $i}'))

count=1
totalCount=${#SAMPLES[@]}

printf "externalSampleID,barcode,project,capturingKit,seqType,Gender,arrayFile,lane,sequencingStartDate,sequencer,run,flowcell\n" > "${workDir}/${projectName}.csv"
for sample in ${SAMPLES[@]}
do
	printf "${sample}" >> "${workDir}/${projectName}.csv" ##externalSampleID
	printf ",${sample}" >> "${workDir}/${projectName}.csv" ## barcode
	printf ",${projectName}" >> "${workDir}/${projectName}.csv" ## project
	printf ",$capturingKit" >> "${workDir}/${projectName}.csv" ## capturingKit
	printf ",PE" >> "${workDir}/${projectName}.csv" ## seqType
	printf "," >> "${workDir}/${projectName}.csv"  ## Gender
	printf "," >> "${workDir}/${projectName}.csv" ## arrayFile
	printf ",1" >> "${workDir}/${projectName}.csv" ##lane
	printf ",DummyDate_${projectName}" >> "${workDir}/${projectName}.csv" ##sequencingstartdate
	printf ",DummySeq_${projectName}" >> "${workDir}/${projectName}.csv" ##sequencer
	printf ",DummyRun_${projectName}" >> "${workDir}/${projectName}.csv" ##run
	printf ",DummyFlowcell_${projectName}\n" >> "${workDir}/${projectName}.csv" ## flowcell
	
	echo "${count} of ${totalCount} done"

	if [ "${count}" == "${totalCount}" ]
	then
		echo "Finished"
	fi
	count=$((count+1))

done

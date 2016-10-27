set -e 
set -u

function usage () {
echo "

sh Convading_MakeControlGroup.sh -i /path/to/bams -w /path/to/workdir/ -p ONCO_v3 -b /apps/data/Agilent/ONCO_v3/human_g1k_v37/captured.bed

Arguments
        Required:
	-i|--bamsfolder		path to where all bams are
	-w|--workdir		path to working directory
        -p|--panel	    	name of panel (e.g. CARDIO_v2, ONCO_v3)
	-b|--bedfile		full path to bedfile (e.g. /apps/data/Agilent/ONCO_v3/human_g1k_v37/captured.bed)
	Optional:
	-o|--controlsDir	Place where final controls will be, the name of the panel will be pasted as folder and MONTH 
				default: /apps/data/Controls_Convading_XHMM/${panel}/\${MONTH}
	-r|--reference		path to reference genome (e.g. /apps/data/1000G/phase1/human_g1k_v37_phiX.fasta)
				default: /apps/data/1000G/phase1/human_g1k_v37_phiX.fasta"
}


PARSED_OPTIONS=$(getopt -n "$0"  -o i:w:p:b:o:r: --long "bamsfolder:workdir:panel:bedfile:controlsDir:reference:"  -- "$@")

#
# Bad arguments, something has gone wrong with the getopt command.
#
if [ $? -ne 0 ]; then
        usage
	echo "FATAL: Wrong arguments."
        exit 1
fi

eval set -- "$PARSED_OPTIONS"


#
# Now goes through all the options with a case and using shift to analyse 1 argument at a time.
# $1 identifies the first argument, and when we use shift we discard the first argument, so $2 becomes $1 and goes again through the case.
#
while true; do
  case "$1" in
	-i|--bamsfolder)
                case "$2" in
                "") shift 2 ;;
                *) bamsFolder=$2 ; shift 2 ;;
            esac ;;
        -w|--workdir)
                case "$2" in
                *) workingDir=$2 ; shift 2 ;;
            esac ;;
        -p|--panel)
                case "$2" in
                *) panel=$2 ; shift 2 ;;
            esac ;;
        -b|--bedfile)
                case "$2" in
                *) capturedBed=$2 ; shift 2 ;;
            esac ;;
        -o|--controlsDir)
                case "$2" in
                *) pathToControls=$2 ; shift 2 ;;
            esac ;;
        -r|--reference)
                case "$2" in
                *) reference=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
  esac
done

empty=""
#
# Check required options were provided.
if [[ -z "${bamsFolder-}" ]]; then
        usage
	exit 1
fi
if [[ -z "${workingDir-}" ]]; then
        usage
	exit 1
fi
if [[ -z "${panel-}" ]]; then
        usage
	exit 1
fi
if [[ -z "${capturedBed-}" ]]; then
        usage
	exit 1
fi

if [[ -z "${pathToControls-}" ]]; then
        pathToControls="/apps/data/Controls_Convading_XHMM/"
fi
if [[ -z "${indexFile-}" ]]; then
        indexFile="/apps/data/1000G/phase1/human_g1k_v37_phiX.fasta"
fi

module load ngs-utils
module load CoNVaDING/1.1.6
module load GATK


cd $bamsFolder

rm -rf ${workingDir}/inputBams/

mkdir -p ${workingDir}/inputBams/

for i in $(ls *)
do
	ln -s "$(readlink -f $i)" ${workingDir}/inputBams/$i
done

convadingInputBamsDir=${workingDir}/inputBams/
convadingStartWithBamDir=${workingDir}/StartWithBam/
convadingStartWithMatchScoreDir=${workingDir}/StartWithMatchScore/
convadingStartWithBestScoreDir=${workingDir}/StartWithBestScore/
convadingGenerateTargetQcListDir=${workingDir}/GenerateTargetQcList/
convadingCreateFinalListDir=${workingDir}/CreateFinalListDir/
controlsDir="${workingDir}/ControlsDir/"
kickedOutSamples=${workingDir}/KickedOutSamples/

startWithBamFinished="${workingDir}/step1_startWithBam.finished"
startWithMatchScoreFinished="${workingDir}/step2_startWithMatchScore.finished"
startWithBestScoreFinished="${workingDir}/step3_startWithBestScore.finished"
generateTargetQcListFinished="${workingDir}/step4_generateTargetQcList.finished"

if [ ! -f ${startWithBamFinished} ]
then
	echo "working on: s1_StartWithBam"
	perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-useSampleAsControl \
	-mode StartWithBam \
	-inputDir ${convadingInputBamsDir} \
	-outputDir ${convadingStartWithBamDir} \
	-controlsDir ${controlsDir} \
	-bed ${capturedBed} \
	-rmdup >> step1_StartWithBam.log
	
	touch ${startWithBamFinished}
	echo "startWithBamFinished created"
else
	echo "startWithBamFinished skipped"
fi


if [ ! -f ${startWithMatchScoreFinished} ]
then
	echo "working on: s2_startWithMatchScore"
	perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode StartWithMatchScore \
	-inputDir ${convadingStartWithBamDir} \
	-outputDir ${convadingStartWithMatchScoreDir} \
	-controlsDir ${controlsDir} >> step2_StartWithMatchScore.log

	touch ${startWithMatchScoreFinished}
        echo "startWithMatchScore created"
else
	echo "startWithMatchScore skipped"
fi

if [ ! -f ${startWithBestScoreFinished} ]
then
	echo "working on: s3_startWithBestScore"
	perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode StartWithBestScore \
	-inputDir ${convadingStartWithMatchScoreDir} \
	-outputDir ${convadingStartWithBestScoreDir} \
	-controlsDir ${controlsDir} >> step3_StartWithBestScore.log
	
	touch ${startWithBestScoreFinished}
	echo "startWithBestScore created"
else
	echo "startWithBestScore skipped"
fi

#
##Step 4: PICK OUT BAD SAMPLES
#
mkdir -p ${kickedOutSamples}
rm -f step4_removingSamplesFromControls.log 
echo "removing bad samples out of the controlsDir"
version=$(date +"%Y-%m")

for i in $(ls ${convadingStartWithBestScoreDir}/*.shortlist.txt)
do
##SHORTLIST (uit stap3)
        size=$(cat $i | wc -l)
        if [ $size != 1 ]
        then
            	T=$(basename ${i%%.*})
                if [ -f ${controlsDir}/${T}*.shortlist.txt ]
                then
                    	mv ${controlsDir}/${T}*.aligned.only.normalized.coverage.txt ${kickedOutSamples}/
                        printf "number of outliers: ${size}\t${controlsDir}/${T}*.aligned.only.normalized.coverage.txt moved to ${kickedOutSamples} folder \n" >> step4_removingSamplesFromControls.log
                        printf "You can check the outliers in: $i \n\n" | tee step4_removingSamplesFromControls.log
                fi
                rm ${convadingInputBamsDir}/${T}*

        fi
done

pathToFinalControls="${pathToControls}/${panel}/"
mkdir -p ${pathToFinalControls}/${version}/bams/
mkdir -p ${pathToFinalControls}/${version}/Convading/
mkdir -p ${pathToFinalControls}/${version}/XHMM/

echo "###COPYING Convading controls normalized coverage files to final destination"

cp ${controlsDir}/*.aligned.only.normalized.coverage.txt ${pathToFinalControls}/${version}/Convading
echo "copied ${controlsDir}/${T}*.aligned.only.normalized.coverage.txt to ${pathToFinalControls}/${version}/Convading/"

##Make symlinks to bams
echo "make symlinks to bams"
cp -a ${convadingInputBamsDir}/*.bam* ${pathToFinalControls}/${version}/bams/


if [ ! -f ${generateTargetQcListFinished} ]
then
	echo "working on: s4_generateTargetQcList with updated controls list"
	perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode GenerateTargetQcList \
	-inputDir ${pathToFinalControls}/${version}/Convading \
	-outputDir ${convadingGenerateTargetQcListDir} \
	-controlsDir ${pathToFinalControls}/${version}/Convading >> step5_generateTargetQcList.log
	
	touch ${generateTargetQcListFinished}
	echo "generateTargetQcList created"
else
	echo "GenerateTargetQcList skipped"
fi


mkdir -p ${workingDir}/XHMM
if [ ! -f ${workingDir}/XHMM.finished ]
then 

	for i in $(ls ${pathToFinalControls}/${version}/bams/*.bam)
	do
		name=$(basename ${i%%.*})
	  	echo "$i" > ${workingDir}/XHMM/${name}.READS.bam.list

	done
	
	for i in $(ls ${workingDir}/XHMM/*.READS.bam.list)
	do
	mkdir -p ${workingDir}/XHMM/scripts/
	bas=$(basename ${i%%.*})
	output=${workingDir}/XHMM/scripts/xhmm_${bas}.sh

	echo "#!/bin/bash" > ${output}
	echo "#SBATCH --job-name=xhmm_${bas}" >> ${output}
	echo "#SBATCH --output=${workingDir}/XHMM/scripts/xhmm_${bas}.out" >> ${output}
	echo "#SBATCH --error=${workingDir}/XHMM/scripts/xhmm_${bas}.err" >> ${output}
	echo "#SBATCH --time=05:59:00" >> ${output}
	echo "#SBATCH --cpus-per-task 1" >> ${output}
	echo "#SBATCH --mem 6gb" >> ${output}
	echo "#SBATCH --open-mode=append" >> ${output}
	echo "#SBATCH --export=NONE" >> ${output}
	echo "#SBATCH --get-user-env=30L" >> ${output}
	echo "set -e" >> ${output}
	echo "set -u" >> ${output}
	echo "function finish {">> ${output}
        echo "echo \"TRAPPED\"">> ${output}
        echo "touch ${workingDir}/XHMM/scripts/XHMM.failed">> ${output}
        echo "}">> ${output}
	echo "trap finish HUP INT QUIT TERM EXIT ERR" >> ${output}
	echo "module load GATK" >> ${output}
	echo "java -Xmx5g -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \\" >> ${output}
	echo "-T DepthOfCoverage \\">> ${output}
	echo "-I $i \\">> ${output}
	echo "-L ${capturedBed} \\">> ${output}
	echo "-R ${indexFile} \\">> ${output}
	echo "-dt BY_SAMPLE -dcov 5000 -l INFO --omitDepthOutputAtEachBase --omitLocusTable \\">> ${output}
	echo "--minBaseQuality 0 --minMappingQuality 20 --start 1 --stop 5000 --nBins 200 \\">> ${output}
	echo "--includeRefNSites \\">> ${output}
	echo "--countType COUNT_FRAGMENTS \\" >> ${output}
	echo "-o ${workingDir}/XHMM/${bas}" >> ${output}
	echo -e "\ntouch ${output}.finished" >> ${output}
	echo -e "\ntrap - EXIT">> ${output}
	echo "exit 0">> ${output}
	
	if [ ! -f ${output}.finished ]
	then
		sbatch $output
	else
		echo "${output} skipped"
	fi
	done

	touch ${workingDir}/XHMM.submitted
fi

while [[ ! -f ${workingDir}/XHMM.finished && ! -f ${workingDir}/XHMM/scripts/XHMM.failed ]]
do
	
	countSh=$(ls ${workingDir}/XHMM/scripts/*.sh | wc -l)
	countFinished=0
	if ls ${workingDir}/XHMM/scripts/*.sh.finished 1> /dev/null 2>&1
	then
		countFinished=$(ls ${workingDir}/XHMM/scripts/*.sh.finished | wc -l)
	fi

	if [ $countSh == $countFinished ]
	then
		echo "${countFinished} scripts finished out of the ${countSh}"
		echo "FINISHED!!!"
		touch ${workingDir}/XHMM.finished	
	else
		echo "${countFinished} scripts finished out of the ${countSh}"
		echo "XHMM is not finished yet, going to sleep for 1 minute"

		sleep 60
	fi
done

if [ -f ${workingDir}/XHMM/scripts/XHMM.failed ]
then
	echo "An error has occured, please check the .err files in ${workingDir}/XHMM/scripts/"
	exit 1
fi

if [ -f ${workingDir}/XHMM.finished ]
then
	echo "### COPYING XHMM controls to final destination"

	cp -r ${workingDir}/XHMM/*.sample_interval_summary ${pathToFinalControls}/${version}/XHMM/
	echo "xhmm results copied"
	
fi


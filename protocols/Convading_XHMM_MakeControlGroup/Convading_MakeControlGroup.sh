set -e 
set -u

function usage () {
echo "
Example
sh Convading_MakeControlGroup.sh -i /path/to/bams -w /path/to/workdir/ -p ONCO_v3 

Arguments
        Required:
	-i|--bamsfolder		path to where all bams are
	-w|--workdir		path to working directory
        -p|--panel	    	name of panel (e.g. CARDIO_v2, ONCO_v3)
	Optional:
	-b|--bedfile		full path to bedfile (e.g. /apps/data/Agilent/ONCO_v3/human_g1k_v37/captured.bed)
				default /apps/data/Agilent/\${panel}/human_g1k_v37/captured.bed
	-o|--controlsDir	Place where final controls will be, the name of the panel will be pasted as folder and MONTH 
				default: /apps/data/Controls_Convading_XHMM/\${panel}/\${MONTH}
	-a|--includeallruns	include all previous runs of this panel (true|false)
				default: false 
	-r|--reference		path to reference genome (e.g. /apps/data/1000G/phase1/human_g1k_v37_phiX.fasta)
				default: /apps/data/1000G/phase1/human_g1k_v37_phiX.fasta
	-g|--gender		file containing umcg-ids and gender (e.g. 123344,Male)
				default: (\${workingDir}/umcg-ids.txt)"
}


PARSED_OPTIONS=$(getopt -n "$0"  -o i:w:p:b:o:r:a:g: --long "bamsfolder:workdir:panel:bedfile:controlsDir:reference:includeallruns:gender:"  -- "$@")

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
	-a|--inludeallruns)
		case "$2" in
		*) includePrevRuns=$2 ; shift 2 ;;
	    esac ;;
	-g|--gender)
		case "$2" in
		*) genderFile=$2 ; shift 2 ;;
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
        capturedBed=/apps/data/Agilent/${panel}/human_g1k_v37/captured.bed
fi
if [[ -z "${pathToControls-}" ]]; then
        pathToControls="/apps/data/Controls_Convading_XHMM/"
fi
if [[ -z "${indexFile-}" ]]; then
        indexFile="/apps/data/1000G/phase1/human_g1k_v37_phiX.fasta"
fi
if [[ -z "${includePrevRuns-}" ]]; then
        includePrevRuns="false"
fi
if [[ -z "${genderFile-}" ]]; then
	genderFile="${workingDir}/umcg-ids.txt"
fi

module load NGS_DNA/3.3.0
module load ngs-utils
module load CoNVaDING/1.1.6
module load GATK


echo "bamsFolder=${bamsFolder}
workingDir=${workingDir}
panel=${panel}
capturedBed=${capturedBed}
pathToControls=${pathToControls}
indexFile=${indexFile}
includePrevRuns=${includePrevRuns}
pathToFinalControls=${pathToControls}/${panel}/" > ${workingDir}/config.cfg

convadingInputBamsDir=${workingDir}/inputBams/
convadingStartWithBamDir=${workingDir}/StartWithBam/
convadingStartWithMatchScoreDir=${workingDir}/StartWithMatchScore/
convadingStartWithBestScoreDir=${workingDir}/StartWithBestScore/
convadingGenerateTargetQcListDir=${workingDir}/GenerateTargetQcList/
convadingCreateFinalListDir=${workingDir}/CreateFinalListDir/
controlsDir=${workingDir}/ControlsDir/
kickedOutSamples=${workingDir}/KickedOutSamples/

startWithBamFinished="${workingDir}/step1_startWithBam.finished"
startWithMatchScoreFinished="${workingDir}/step2_startWithMatchScore.finished"
startWithBestScoreFinished="${workingDir}/step3_startWithBestScore.finished"
generateTargetQcListFinished="${workingDir}/step4b_generateTargetQcList.finished"

chmod ugo+x ${workingDir}/config.cfg

. ${workingDir}/config.cfg
if [ ! -f ${workingDir}/Convading_MakeControlGroup.finished ]
then
	if [ ! -f ${startWithBamFinished} ]
	then
		rm -rf ${workingDir}/inputBams/
	
		mkdir -p ${workingDir}/inputBams/
	
		cd $bamsFolder
	
		for i in $(ls *)
		do
			pad=$(readlink -f $i)
			if [[ "${pad}" == *"prm02"* ]]
			then
				echo "files cannot be on prm02, first copy data to tmp storage and try again"
				exit 1
			else
				ln -s "$(readlink -f $i)" ${workingDir}/inputBams/$i
			fi
		done
	fi
	#########
	#
	##
	### Start with Convading steps
	##
	#
	
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
		-rmdup 2>&1 >> ${workingDir}/step1_StartWithBam.log
		
		touch ${startWithBamFinished}
		echo "startWithBamFinished created"
	else
		echo "startWithBamFinished skipped"
	fi
	
	if [ ! -f ${startWithMatchScoreFinished} ]
	then
		if [ "${includePrevRuns}" == "true" ]
		then
			echo "start copying normalized coverage files from previous runs to ${convadingStartWithBamDir}"
			for i in $(ls ${pathToFinalControls}/*/Convading/*.aligned.only.normalized.coverage.txt)
			do
				cp $i ${controlsDir}
				cp $i ${convadingStartWithBamDir}
				if [ -f ${workingDir}/oldControls.txt ]
				then
					rm ${workingDir}/oldControls.txt
				fi 
				echo $(basename ${i%%.*}) >> ${workingDir}/oldControls.txt
			done	 		
		fi
	
		echo "working on: s2_startWithMatchScore"
		perl ${EBROOTCONVADING}/CoNVaDING.pl \
		-mode StartWithMatchScore \
		-inputDir ${convadingStartWithBamDir} \
		-outputDir ${convadingStartWithMatchScoreDir} \
		-controlsDir ${controlsDir}  2>&1 >> ${workingDir}/step2_StartWithMatchScore.log
	
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
		-controlsDir ${controlsDir}  2>&1 >> ${workingDir}/step3_StartWithBestScore.log
		
		touch ${startWithBestScoreFinished}
		echo "startWithBestScore created"
	else
		echo "startWithBestScore skipped"
	fi
	
	#########
	#
	##
	###Step 4: PICK OUT BAD SAMPLES
	##
	#
	
	mkdir -p ${kickedOutSamples}
	rm -f step4_removingSamplesFromControls.log 
	echo "removing bad samples out of the controlsDir"
	version="$(date +"%Y-%m")"
	rm -f ${workingDir}/RemovedFromOldControlsGroup.txt
	
	if [ ! -f ${workingDir}/step4a_removingSamplesFromControls.finished ]
	then
		rm -f ${workingDir}/step4a_removingSamplesFromControls.log
		for i in $(ls ${convadingStartWithBestScoreDir}/*.shortlist.txt)
		do
		##SHORTLIST (uit stap3)
	        	size=$(cat $i | wc -l)
       			if [ $size != 1 ]
        		then
        	    		sampleID=$(basename ${i%%.*})
				rm -f ${convadingInputBamsDir}/${sampleID}*
				echo $sampleID	
				##
				### Check if the control of the old controlgroup is still a control
				##
				oldControlGoesOut=""
				if [ -f ${workingDir}/oldControls.txt ]
				then
	
					if grep "$sampleID" ${workingDir}/oldControls.txt
					then
						oldControlGoesOut=$(grep "$sampleID" ${workingDir}/oldControls.txt)
					fi
				else
	
					oldControlGoesOut=""	
				fi
				echo "2"
				if [ ! -z "${oldControlGoesOut}" ]
				then
					echo "${sampleID}" >> ${workingDir}/RemovedFromOldControlsGroup.txt
				else
	       	        		#
					## The controlsGroup does not contain bams anymore, only bams of this new group can be removed 
					#
					echo "The controlsGroup does not contain bams anymore, only bams of this new group can be removed"		
				
				fi
				#
				## Removing samples from the controlsDir
				#
				mv ${controlsDir}/${sampleID}*.aligned.only.normalized.coverage.txt ${kickedOutSamples}/
				printf "number of outliers: ${size}\t${controlsDir}/${sampleID}*.aligned.only.normalized.coverage.txt moved to ${kickedOutSamples} folder \n" >> ${workingDir}/step4a_removingSamplesFromControls.log
        		fi
		
		done
		touch ${workingDir}/step4a_removingSamplesFromControls.finished
	
	fi
	#########
	#
	##
	### Generating TargetQC list
	##
	#
	
	if [ ! -f ${generateTargetQcListFinished} ]
	then
		echo "working on: s4b_generateTargetQcList with updated controls list"
		perl ${EBROOTCONVADING}/CoNVaDING.pl \
		-mode GenerateTargetQcList \
		-inputDir ${controlsDir}  \
		-outputDir ${convadingGenerateTargetQcListDir} \
		-controlsDir ${controlsDir} >> ${workingDir}/step4_generateTargetQcList.log
		
		touch ${generateTargetQcListFinished}
		echo "generateTargetQcList created"
	else
		echo "GenerateTargetQcList skipped"
	fi
	
	#########
	#
	##
	### Copy data to permanent storage --> ${pathToControls} (default: /apps/data/Controls_Convading_XHMM )
	##
	#
	mkdir -p ${pathToFinalControls}/${version}/Convading/
	mkdir -p ${pathToFinalControls}/${version}/XHMM/
	
	echo "Copying targetQcList.txt to ${pathToFinalControls}/${version}/Convading/"
	cp ${convadingGenerateTargetQcListDir}/targetQcList.txt ${pathToFinalControls}/${version}/Convading/
	
	echo "###COPYING Convading controls normalized coverage files to final destination"
	
	cp ${controlsDir}/*.aligned.only.normalized.coverage.txt ${pathToFinalControls}/${version}/Convading
	echo "copied ${controlsDir}/*.aligned.only.normalized.coverage.txt to ${pathToFinalControls}/${version}/Convading"
	
	
	#########
	#
	##
	### Start with XHMM step
	##
	#
	xhmmWorkingDir=${workingDir}/XHMM/
	
	
	if [ ! -f ${workingDir}/XHMM.finished ]
	then 
		rm -f ${workingDir}/XHMM.failed
		rm -f ${workingDir}/XHMM.submitted
	
	
		if [ -d ${workingDir}/XHMM ]
		then
			rm -rf ${xhmmWorkingDir}
	
		fi
		mkdir -p ${xhmmWorkingDir}
	
		for i in $(ls ${convadingInputBamsDir}/*.bam)
		do
			name=$(basename ${i%%.*})
	  		echo "$i" > ${xhmmWorkingDir}/${name}.READS.bam.list
	
		done
		
		for i in $(ls ${xhmmWorkingDir}/*.READS.bam.list)
		do
			mkdir -p ${xhmmWorkingDir}/scripts/
			bas=$(basename ${i%%.*})
			output=${xhmmWorkingDir}/scripts/xhmm_${bas}.sh
		
			echo "#!/bin/bash" > ${output}
			echo "#SBATCH --job-name=xhmm_${bas}" >> ${output}
			echo "#SBATCH --output=${xhmmWorkingDir}/scripts/xhmm_${bas}.out" >> ${output}
			echo "#SBATCH --error=${xhmmWorkingDir}/scripts/xhmm_${bas}.err" >> ${output}
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
        		echo "touch ${workingDir}/XHMM.failed">> ${output}
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
			echo "-o ${xhmmWorkingDir}/${bas}" >> ${output}
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
	
	#
	##
	### Because the files get submitted we want to know when XHMM is finished (or crashed)
	##
	#
	while [[ ! -f ${workingDir}/XHMM.finished && ! -f ${workingDir}/XHMM.failed ]]
	do
		
		countSh=$(ls ${xhmmWorkingDir}/scripts/*.sh | wc -l)
		countFinished=0
		if ls ${xhmmWorkingDir}/scripts/*.sh.finished 1> /dev/null 2>&1
		then
			countFinished=$(ls ${xhmmWorkingDir}/scripts/*.sh.finished | wc -l)
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
	
	if [ -f ${workingDir}/XHMM.failed ]
	then
		echo "An error has occured, please check the .err files in ${xhmmWorkingDir}/scripts/"
		exit 1
	fi
	echo "VERSION: $version"
	if [ -f ${workingDir}/XHMM.finished ]
	then
		if [ "${includePrevRuns}" == "true" ]
                then
                        ls -d ${pathToFinalControls}/*/ > ${xhmmWorkingDir}/versions.txt
                        while read line
                        do
                                B=$(basename $line)
                                if [ -d ${pathToFinalControls}/${B}/XHMM/PerSample/ ]
                                then
                                        cp ${pathToFinalControls}/${B}/XHMM//PerSample/*.sample_interval_summary ${xhmmWorkingDir}

                                fi
                        done<${xhmmWorkingDir}/versions.txt

                fi
	
		mkdir -p ${pathToFinalControls}/${version}/XHMM/PerSample/
	
        	if [ -f ${xhmmWorkingDir}/sample_interval_summary.Controls ]
        	then
            		rm ${xhmmWorkingDir}/sample_interval_summary.Controls
        	fi
	
		for i in $(ls ${pathToFinalControls}/${version}/XHMM//PerSample/*.sample_interval_summary )
        	do
          		echo "$i" >> ${xhmmWorkingDir}/sample_interval_summary.Controls
        	done
        	echo "### COPYING XHMM controls to final destination"
        	cp -r ${xhmmWorkingDir}/*.sample_interval_summary ${pathToFinalControls}/${version}/XHMM/PerSample/
	
		cp ${xhmmWorkingDir}/sample_interval_summary.Controls ${pathToFinalControls}/${version}/XHMM/Controls.sample_interval_summary
	
        	echo "xhmm results copied"
	
	fi
	
	########
	#
	##
	### Create extreme GC content files once per panel 
	##
	#
	if [ ! -f ${pathToFinalControls}/${panel}.extreme_gc_targets.txt ]
	then
		xhmmGcContent=${xhmmWorkingDir}/step3.DATA.locus_GC.txt
		xhmmExtremeGcContent=${xhmmWorkingDir}/step3.extreme_gc_targets.txt
	
		java -Xmx3072m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
		-T GCContentByInterval \
		-L ${capturedBed} \
		-R ${indexFile} \
		-o ${xhmmGcContent}.tmp
	
		printf "moving ${xhmmGcContent}.tmp to ${xhmmGcContent} .. "
		mv ${xhmmGcContent}.tmp ${xhmmGcContent}
		printf " .. done!"
	
		cat ${xhmmGcContent} | awk '{if ($2 < 0.1 || $2 > 0.9) print $1}' > ${xhmmExtremeGcContent}
	
		echo "Extreme GC content file created: ${xhmmExtremeGcContent}"
	
		cp ${xhmmGcContent} ${pathToFinalControls}/${panel}.DATA.locus_GC.txt
		cp ${xhmmExtremeGcContent} ${pathToFinalControls}/${panel}.extreme_gc_targets.txt
	fi
	if [ ! -f ${pathToFinalControls}/${panel}.locus_complexity.txt ]
	then
		module load xhmm
	
		module load plinkseq
	
		outputbase=${xhmmWorkingDir}/output.step4
		targets=${outputbase}.targets
		targetsLOCDB=${targets}.LOCDB
	
		seqDBhg19=/apps/data/XHMM/seqdb.hg19/hg19/seqdb.hg19
	
		$EBROOTXHMM/bin/interval_list_to_pseq_reg ${capturedBed} > ${targets}.reg
	
		$EBROOTPLINKSEQ/pseq . loc-load --locdb ${targetsLOCDB} --file ${targets}.reg --group targets --out ${targetsLOCDB}.loc-load
	
		$EBROOTPLINKSEQ/pseq . loc-stats --locdb ${targetsLOCDB} --group targets --seqdb ${seqDBhg19} | \
		awk '{if (NR > 1) print $_}' | sort -k1 -g | awk '{print $10}' | paste ${capturedBed} - | \
		awk '{print $1"\t"$2}' > ${outputbase}.locus_complexity.txt
	
		cat ${outputbase}.locus_complexity.txt | awk '{if ($2 > 0.25) print $1}' > ${outputbase}.low_complexity_targets.txt
	
		cp ${outputbase}.low_complexity_targets.txt ${pathToFinalControls}/${panel}.low_complexity_targets.txt 
		cp ${outputbase}.locus_complexity.txt  ${pathToFinalControls}/${panel}.locus_complexity.txt 
	fi
	touch  ${workingDir}/Convading_MakeControlGroup.finished
	
	echo "cleaning up and moving data"
	logsDir=${workingDir}/logs
	mkdir ${logsDir}

	echo "moving data to ${logsDir}"
	mv step* ${logsDir}
	mv XHMM.* ${logsDir}
	if [ -f ${workingDir}/oldControls.txt ]
	then
		mv ${workingDir}/oldControls.txt ${logsDir}
	fi
	
else
	echo "skipped Make Control group because it is already finished"	
fi



rm -f ${workingDir}/chrXRegions.txt
awk '{
	if ($1 == "X"){
		print $0
	}
}' ${capturedBed} > ${workingDir}/chrXRegions.txt

size=$(cat ${workingDir}/chrXRegions.txt | wc -l)

echo "SIZE:${capturedBed}"


#
## Execute chrX steps
#
if [ $size != 0 ]
then
	echo "the bedfile contains chrX regions, convading and xhmm will now be executed for male and female seperately"
	sh ${EBROOTNGS_DNA}/protocols/Convading_XHMM_MakeControlGroup/prepareMaleFemale.sh ${genderFile} ${workingDir}
else
	echo "There are no chrX regions, creating Controlsgroup is finished"
fi

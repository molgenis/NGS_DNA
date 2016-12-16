set -e 
set -u

module load ngs-utils
module load CoNVaDING/1.1.6
module load GATK
if [ -z ${1-} ]
then
	echo "script needs gender argument (Male/Female) and workingDirectory"
	exit 0
fi

gender=$1
workingDir=$2
. ${workingDir}/config.cfg

workingDir=${workingDir}/Gender/${gender}

cd ${workingDir}/$bamsFolder

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
controlsDir=${workingDir}/ControlsDir/
kickedOutSamples=${workingDir}/KickedOutSamples/

startWithBamFinished="${workingDir}/step1_startWithBam.finished"
startWithMatchScoreFinished="${workingDir}/step2_startWithMatchScore.finished"
startWithBestScoreFinished="${workingDir}/step3_startWithBestScore.finished"
generateTargetQcListFinished="${workingDir}/step4b_generateTargetQcList.finished"
pathToFinalControls="${pathToControls}/${panel}/"
if [ ! -f ${workingDir}/Convading_MakeControlGroup.finished ]
then
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
			rm -f ${workingDir}/oldControls.txt
			for i in $(ls -d ${pathToFinalControls}/*/)
                        do
                                echo "start copying normalized coverage files from previous runs to ${convadingStartWithBamDir}"
				if [ -d ${pathToFinalControls}/$(basename ${i})/Convading/${gender} ]
	                        then
				        cp ${pathToFinalControls}/$(basename ${i})/Convading/${gender}/*.aligned.only.normalized.coverage.txt ${convadingStartWithBamDir}
       	                        	cp ${pathToFinalControls}/$(basename ${i})/Convading/${gender}/*.aligned.only.normalized.coverage.txt ${controlsDir}
				fi
                                echo $(basename ${i%%.*}) >> ${workingDir}/oldControls.txt
                        done
		fi
	
		echo "working on: s2_startWithMatchScore"
		perl ${EBROOTCONVADING}/CoNVaDING.pl \
		-mode StartWithMatchScore \
		-inputDir ${convadingStartWithBamDir} \
		-outputDir ${convadingStartWithMatchScoreDir} \
		-sexChr \
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
		-sexChr \
		-controlsDir ${controlsDir}  2>&1 >> ${workingDir}/step3_StartWithBestScore.log
		
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
	version="$(date +"%Y-%m")"
	
	if [ ! -f ${workingDir}/step4a_removingSamplesFromControls.finished ]
	then
		for i in $(ls ${convadingStartWithBestScoreDir}/*.shortlist.txt)
		do
			
			sampleID=$(basename ${i%%.*})
			echo ${sampleID}
			##SHORTLIST (uit stap3)
			awk '{ 
				if ($1 == "X"){
					print $0
				}
			}' $i > ${sampleID}.chrX.shortlist 
			size=0

			if [ -f ${sampleID}.chrX.shortlist ]
			then	
                		size=$(cat ${sampleID}.chrX.shortlist | wc -l)
        		fi

	        	if [ ${size} != 0 ]
                	then
                        	rm -f ${convadingInputBamsDir}/${sampleID}*
			
                        	##
                        	### Check if the control of the old controlgroup is still a control
                        	##
                        	oldControlGoesOut=""
                        	if [ -f ${workingDir}/oldControls.txt ]
                        	then
					if grep $sampleID ${workingDir}/oldControls.txt 
					then
                            			oldControlGoesOut=$(grep $sampleID ${workingDir}/oldControls.txt)
					fi				
                        	else
                            		oldControlGoesOut=""
                        	fi
	
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
                        	printf "You can check the outliers in: $i \n\n" | tee ${workingDir}/step4a_removingSamplesFromControls.log
	
	
                	fi
	
        	done
		touch ${workingDir}/step4a_removingSamplesFromControls.finished
	
	fi
	
	if [ ! -d ${pathToFinalControls}/${version}/Convading/${gender}/ ]
	then
		echo "${pathToFinalControls}/${version}/Convading/${gender}/"	
		mkdir -p ${pathToFinalControls}/${version}/Convading/${gender}/
	fi
	if [ ! -d ${pathToFinalControls}/${version}/XHMM//${gender}/ ]
	then
		mkdir -p ${pathToFinalControls}/${version}/XHMM//${gender}/
	fi
		
	if [ ! -f ${generateTargetQcListFinished} ]
	then
		echo "working on: s4_generateTargetQcList with updated controls list"
		perl ${EBROOTCONVADING}/CoNVaDING.pl \
		-mode GenerateTargetQcList \
		-inputDir ${controlsDir} \
		-outputDir ${convadingGenerateTargetQcListDir} \
		-controlsDir ${controlsDir} >> ${workingDir}/step4_generateTargetQcList.log
		
		touch ${generateTargetQcListFinished}
		echo "generateTargetQcList created"
	else
		echo "GenerateTargetQcList skipped"
	fi
	
	echo "Copying targetQcList.txt to ${pathToFinalControls}/${version}/Convading/${gender}"
	cp ${convadingGenerateTargetQcListDir}/targetQcList.txt ${pathToFinalControls}/${version}/Convading/${gender}/
	
	echo "###COPYING Convading controls normalized coverage files to final destination"
	
	cp ${controlsDir}/*.aligned.only.normalized.coverage.txt ${pathToFinalControls}/${version}/Convading/${gender}/
	echo "copied ${controlsDir}/*.aligned.only.normalized.coverage.txt to ${pathToFinalControls}/${version}/Convading/${gender}/"
	
	#
	##
	### XHMM
	##
	#
	
	mkdir -p ${workingDir}/XHMM
	xhmmWorkingDir=${workingDir}/XHMM/
	
	rm -f ${xhmmWorkingDir}/scripts/XHMM.failed
	
	if [ ! -f ${workingDir}/XHMM.finished ]
	then 
	
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
        	echo "touch ${xhmmWorkingDir}/scripts/XHMM.failed">> ${output}
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
			sbatch $output --qos=dev
		else
			echo "${output} skipped"
		fi
		done
	
		touch ${workingDir}/XHMM.submitted
	fi
	
	while [[ ! -f ${workingDir}/XHMM.finished && ! -f ${xhmmWorkingDir}/scripts/XHMM.failed ]]
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
	
	if [ -f ${xhmmWorkingDir}/scripts/XHMM.failed ]
	then
		echo "An error has occured, please check the .err files in ${xhmmWorkingDir}/scripts/"
		exit 1
	fi
	
	if [ -f ${workingDir}/XHMM.finished ]
	then
	
		if [ "${includePrevRuns}" == "true" ]
		then
			ls -d ${pathToFinalControls}/*/ > ${xhmmWorkingDir}/versions.txt
			while read line 
			do 
				B=$(basename $line)
				if [ -d ${pathToFinalControls}/${B}/XHMM/${gender}/PerSample/ ]
				then
       	                        	cp ${pathToFinalControls}/${B}/XHMM/${gender}/PerSample/*.sample_interval_summary ${xhmmWorkingDir}

				fi
			done<${xhmmWorkingDir}/versions.txt 

		fi
	
		mkdir -p ${pathToFinalControls}/${version}/XHMM/${gender}/PerSample/
		
		echo "### COPYING XHMM controls to final destination"
        	cp -r ${xhmmWorkingDir}/*.sample_interval_summary ${pathToFinalControls}/${version}/XHMM/${gender}/PerSample/
	
		if [ -f ${xhmmWorkingDir}/${gender}_sample_interval_summary.Controls ]
		then
			rm ${xhmmWorkingDir}/${gender}_sample_interval_summary.Controls
		fi
 	
        	for i in $(ls ${pathToFinalControls}/${version}/XHMM/${gender}/PerSample/*.sample_interval_summary )
        	do
          		echo "$i" >> ${xhmmWorkingDir}/${gender}_sample_interval_summary.Controls
        	done
	
		cp ${xhmmWorkingDir}/${gender}_sample_interval_summary.Controls ${pathToFinalControls}/${version}/XHMM//${gender}/Controls.sample_interval_summary
	
        	echo "xhmm results copied"
	
	fi
	echo "cleaning up and moving data per Gender"
        logsDir=${workingDir}/logs
        mkdir -p ${logsDir}

	echo "moving data to ${logsDir}"
        mv ${workingDir}/step* ${logsDir}
        mv ${workingDir}/XHMM.* ${logsDir}
        if [ -f ${workingDir}/oldControls.txt ]
	then
		mv ${workingDir}/oldControls.txt ${logsDir}
		touch ${workingDir}/Convading_MakeControlGroup.finished
		
	fi
	echo "Making controlsgroup is completely finished"
else
	echo "MakeControlgroupGender is already created,skipped"
fi

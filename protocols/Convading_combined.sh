#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string convadingVersion
#string capturingKit
#string intermediateDir
#string capturedBed
#string dedupBam
#string convadingInputBamsDir
#string convadingStartWithBam
#string convadingStartWithMatchScore
#string convadingStartWithBestScore
#string convadingStartWithMatchScoreGender
#string convadingStartWithBestScoreGender
#string convadingCreateFinalList
#string cxControlsDir
#string ControlsVersioning
#string gender

convadingControlsDir=""

awk '{
      	if ($1 == "X"){
                print $0
        }
}' ${capturedBed} >> ${intermediateDir}/chrXRegions.txt

size=$(cat ${intermediateDir}/chrXRegions.txt | wc -l)


makeTmpDir ${convadingStartWithBam}
tmpConvadingStartWithBam=${MC_tmpFile}

makeTmpDir ${convadingStartWithMatchScore}
tmpConvadingStartWithMatchScore=${MC_tmpFile}

makeTmpDir ${convadingStartWithMatchScoreGender}
tmpConvadingStartWithMatchScoreGender=${MC_tmpFile}

makeTmpDir ${convadingStartWithBestScore}
tmpConvadingStartWithBestScore=${MC_tmpFile}

makeTmpDir ${convadingStartWithBestScoreGender}
tmpConvadingStartWithBestScoreGender=${MC_tmpFile}

makeTmpDir ${convadingCreateFinalList}
tmpConvadingCreateFinalList=${MC_tmpFile}


#
## Execute chrX steps
#

ChrXRun="false"
run=()
run+=("autosomal")
if [ $size != 0 ]
then
        echo "the bedfile contains chrX regions, convading now be executed with a male or female controlsgroup"
	chrXRun="true"
	run+=("$gender")
fi

mkdir -p ${intermediateDir}/Convading

for i in ${run[@]}
do
	echo $i
	cDir=$(awk '{if ($1 == "'${capturingKit}'"){print $2}}' $ControlsVersioning)

	convadingControlsDir=""
	workingDir=""
	if [ "${i}" == "autosomal" ]
	then
		convadingControlsDir=${cxControlsDir}/${cDir}/Convading/
	elif [[ "${i}" == "Male" || "${i}" == "Man" ]]
	then
		convadingControlsDir=${cxControlsDir}/${cDir}/Convading/Male/
	elif [[ "${i}" == "Female" || "${i}" == "Vrouw" ]]
	then
		convadingControlsDir=${cxControlsDir}/${cDir}/Convading/Female/
	else
		echo "THIS CANNOT BE TRUE, no Male, Female or autosomal!!"
	fi

	if [[ ! -f ${intermediateDir}/capt.txt || ! -f ${intermediateDir}/capt.txt.locked ]]
	then
		touch ${intermediateDir}/capt.txt.locked	
		## write capturingkit to file to make it easier to split
		echo $capturingKit > ${intermediateDir}/capt.txt 
	fi
		
	if [ -d ${convadingControlsDir} ]
	then
	
		CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)
		nameOfSample=$(basename ${dedupBam%%.*})
		
		module load ${convadingVersion}
		
		#Function to check if array contains value
		array_contains () {
    		local array="$1[@]"
    		local seeking=$2
    		local in=1
    		for element in "${!array-}"; do
        		if [[ "$element" == "$seeking" ]]; then
            		in=0
            		break
        		fi
    		done
    		return $in
		}
	
	##STEP 1
	if [ ! -f ${intermediateDir}/convading.${nameOfSample}.${i}.step1.finished ]
	then
	
		for bamFile in "${dedupBam[@]}"
		do
	        	array_contains INPUTS "$bamFile" || INPUTS+=("$bamFile")    # If bamFile does not exist in array add it
	        	array_contains INPUTBAMS "$bamFile" || INPUTBAMS+=("$bamFile")    # If bamFile does not exist in array add it
		done
	
		## Creating bams directory
		mkdir -p ${convadingStartWithBam}
		mkdir -p ${convadingInputBamsDir} 
		ln -sf ${dedupBam} ${convadingInputBamsDir}/
		ln -sf ${dedupBam}.bai ${convadingInputBamsDir}/
	
		echo $project
	
		for k in ${INPUTS[@]}
		do
			echo "$k" >> ${convadingInputBamsDir}/${CAPT}.READS.bam.list
		done
		
		perl ${EBROOTCONVADING}/CoNVaDING.pl \
		-mode StartWithBam \
		-inputDir ${convadingInputBamsDir} \
		-outputDir ${tmpConvadingStartWithBam} \
		-controlsDir ${convadingControlsDir} \
		-bed ${capturedBed} \
		-rmdup
	
		printf "moving ${tmpConvadingStartWithBam} to ${convadingStartWithBam} ... "
		mv ${tmpConvadingStartWithBam}/* ${convadingStartWithBam}
		printf " .. done \n"
		touch ${intermediateDir}/convading.${nameOfSample}.${i}.step1.finished
	fi
	
	##STEP 2
	if [ ! -f ${intermediateDir}/convading.${nameOfSample}.${i}.step2.finished ]
	then
	
		## Creating directory
		mkdir -p ${convadingStartWithMatchScore}/
		mkdir -p ${convadingStartWithMatchScoreGender}
		
		if [ "${i}" == "autosomal" ]
        	then
	            	perl ${EBROOTCONVADING}/CoNVaDING.pl \
        	        -mode StartWithMatchScore \
        	        -inputDir ${convadingStartWithBam} \
        	        -outputDir ${tmpConvadingStartWithMatchScore} \
        	        -controlsDir ${convadingControlsDir}
			printf "moving ${tmpConvadingStartWithMatchScore} to ${convadingStartWithMatchScore} .. "
			mv ${tmpConvadingStartWithMatchScore}/* ${convadingStartWithMatchScore}
			printf " .. done\n"

        	else
			perl ${EBROOTCONVADING}/CoNVaDING.pl \
                        -mode StartWithMatchScore \
                        -inputDir ${convadingStartWithBam} \
                        -outputDir ${tmpConvadingStartWithMatchScoreGender} \
			-sexChr \
                        -controlsDir ${convadingControlsDir}
			
			printf "moving ${tmpConvadingStartWithMatchScoreGender} to ${convadingStartWithMatchScoreGender} .. "
                	mv ${tmpConvadingStartWithMatchScoreGender}/* ${convadingStartWithMatchScoreGender}
                	printf " .. done\n"
        	fi
	
		
		touch ${intermediateDir}/convading.${nameOfSample}.${i}.step2.finished
	fi
	
	##STEP 3
	if [ ! -f ${intermediateDir}/convading.${nameOfSample}.${i}.step3.finished ]
	then
	
		## Creating directory
		mkdir -p ${convadingStartWithBestScore}
		mkdir -p ${convadingStartWithBestScoreGender}
		if [ "${i}" == "autosomal" ]
                then	
			perl ${EBROOTCONVADING}/CoNVaDING.pl \
			-mode StartWithBestScore \
			-inputDir ${convadingStartWithMatchScore} \
			-outputDir ${tmpConvadingStartWithBestScore} \
			-controlsDir ${convadingControlsDir}
			printf "moving ${tmpConvadingStartWithBestScore} to ${convadingStartWithBestScore} .. "
			mv ${tmpConvadingStartWithBestScore}/* ${convadingStartWithBestScore}
			printf " .. done\n"
		else
		
			perl ${EBROOTCONVADING}/CoNVaDING.pl \
                        -mode StartWithBestScore \
                        -inputDir ${convadingStartWithMatchScoreGender} \
                        -outputDir ${tmpConvadingStartWithBestScoreGender} \
			-sexChr \
                        -controlsDir ${convadingControlsDir}
		
			printf "moving ${tmpConvadingStartWithBestScoreGender} to ${convadingStartWithBestScoreGender} .. "
	                mv ${tmpConvadingStartWithBestScoreGender}/* ${convadingStartWithBestScoreGender}
	                printf " .. done\n"
	
		fi
		
		touch ${intermediateDir}/convading.${nameOfSample}.${i}.step3.finished
	fi
	if [ -d ${convadingStartWithBestScoreGender} ]
	then 

		for z in $(ls ${convadingStartWithBestScoreGender}/*.txt)
		do
			BEFORE=$(cat $z | wc -l)
			BAS=$(basename $z)
			awk '{
				if ($1 == "X"){
					print $0
				}
			}' $z >> ${convadingStartWithBestScore}/${BAS} 
			AFTER=$(cat ${convadingStartWithBestScore}/${BAS} | wc -l)
			if [ $BEFORE -eq $AFTER ]
			then
				echo "no calls on X for ${z}"
			else
				echo "writing all X calls from ${z} to ${convadingStartWithBestScore}/${BAS}"
			fi
		done
	fi	

	##STEP 5
	if [ ! -f ${intermediateDir}/convading.${nameOfSample}.${i}.step5.finished ]
	then
	
		## Creating directory
		mkdir -p ${convadingCreateFinalList}
	
		perl ${EBROOTCONVADING}/CoNVaDING.pl \
		-mode CreateFinalList \
		-inputDir ${convadingStartWithBestScore} \
		-outputDir ${tmpConvadingCreateFinalList} \
		-targetQcList ${convadingControlsDir}/targetQcList.txt
	
		printf "moving ${tmpConvadingCreateFinalList} to ${convadingCreateFinalList} .. "
		mv ${tmpConvadingCreateFinalList}/* ${convadingCreateFinalList}
		printf " .. done\n"
		
		touch ${intermediateDir}/convading.${nameOfSample}.${i}.step5.finished
	fi
	
	
	else
		echo "Convading step has been skipped since there are no controls for this group: ${cDir}/Convading/"
	
	fi

done

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
#string convadingCreateFinalList
#string cxControlsDir
#string ControlsVersioning
#string capturingKit

convadingControlsDir=""

if [[ ! -f ${intermediateDir}/capt.txt || ! -f ${intermediateDir}/capt.txt.locked ]]
then
	touch ${intermediateDir}/capt.txt.locked	
	## write capturingkit to file to make it easier to split
	echo $capturingKit > ${intermediateDir}/capt.txt 
fi

cDir=$(awk '{if ($1 == "'${capturingKit}'"){print $2}}' $ControlsVersioning)
	
convadingControlsDir=${cxControlsDir}/${cDir}/Convading/
echo "##"
echo "### convadingControlsDir=$convadingControlsDir"
echo "##"

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
if [ ! -f convading.${nameOfSample}.step1.finished ]
	then
	makeTmpDir ${convadingStartWithBam}
	tmpConvadingStartWithBam=${MC_tmpFile}

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

	for i in ${INPUTS[@]}
	do
		echo "$i" >> ${convadingInputBamsDir}/${CAPT}.READS.bam.list
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
	convading.${nameOfSample}.step1.finished
fi

##STEP 2
if [ ! -f convading.${nameOfSample}.step2.finished ]
then
	makeTmpDir ${convadingStartWithMatchScore}
	tmpConvadingStartWithMatchScore=${MC_tmpFile}

	## Creating directory
	mkdir -p ${convadingStartWithMatchScore}

	perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode StartWithMatchScore \
	-inputDir ${convadingStartWithBam} \
	-outputDir ${tmpConvadingStartWithMatchScore} \
	-controlsDir ${convadingControlsDir}

	printf "moving ${tmpConvadingStartWithMatchScore} to ${convadingStartWithMatchScore} .. "
	mv ${tmpConvadingStartWithMatchScore}/* ${convadingStartWithMatchScore}
	printf " .. done\n"
	
	touch convading.${nameOfSample}.step2.finished
fi

##STEP 3
if [ ! -f convading.${nameOfSample}.step3.finished ]
then
	makeTmpDir ${convadingStartWithBestScore}
	tmpConvadingStartWithBestScore=${MC_tmpFile}

	## Creating directory
	mkdir -p ${convadingStartWithBestScore}

	perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode StartWithBestScore \
	-inputDir ${convadingStartWithMatchScore} \
	-outputDir ${tmpConvadingStartWithBestScore} \
	-controlsDir ${convadingControlsDir}

	printf "moving ${tmpConvadingStartWithBestScore} to ${convadingStartWithBestScore} .. "
	mv ${tmpConvadingStartWithBestScore}/* ${convadingStartWithBestScore}
	printf " .. done\n"
	
	touch convading.${nameOfSample}.step3.finished
fi

##STEP 5
if [ ! -f convading.${nameOfSample}.step5.finished ]
then
	makeTmpDir ${convadingCreateFinalList}
	tmpConvadingCreateFinalList=${MC_tmpFile}

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
	
	touch convading.${nameOfSample}.step5.finished
fi

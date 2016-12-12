#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string gatkVersion
#string indexFile
#string capturedBed
#string capturingKit
#string dedupBam
#string intermediateDir
#string DepthOfCoveragePerSample
#string gatkVersion
#string xhmmMergedSample
#string xhmmMergedSampleGender
#string xhmmDataDir
#string xhmmDir
#string xhmmDepthOfCoverage
#string xhmmVersion
#string xhmmFilterSample
#string xhmmFilterSampleGender
#string xhmmPCAfile
#string xhmmPCAfileGender
#string xhmmPCANormalizedfile
#string xhmmPCANormalizedfileGender
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmPCANormalizedfileFilteredZscoresGender
#string xhmmSameFiltered
#string xhmmSameFilteredGender
#string xhmmXcnv
#string xhmmXcnvGender
#string xhmmAUXcnv
#string xhmmAUXcnvGender
#string xhmmPosterior
#string xhmmPosteriorGender
#string xhmmHighSenseParams
#string ControlsVersioning
#string cxControlsDir
#string Gender

nameOfSample=$(basename ${dedupBam%%.*})

if grep ${capturingKit} ${ControlsVersioning}
then
	
	xhmmControlsDir=""
	#
	## Check if chrX is in the bedfile
	#
	awk '{
      		if ($1 == "X"){
                	print $0
        	}
	}' ${capturedBed} >> ${intermediateDir}/chrXRegions.txt
	
	size=$(cat ${intermediateDir}/chrXRegions.txt | wc -l)
	#1
	makeTmpDir ${DepthOfCoveragePerSample}
	tmpDepthOfCoveragePerSample=${MC_tmpFile}
	#2
	makeTmpDir ${xhmmMergedSample}
	tmpXhmmMergedSample=${MC_tmpFile}
	makeTmpDir ${xhmmMergedSampleGender}
	tmpXhmmMergedSampleGender=${MC_tmpFile}
	#5
	makeTmpDir ${xhmmFilterSample}
	tmpXhmmFilterSample=${MC_tmpFile}
	makeTmpDir ${xhmmFilterSampleGender}
	tmpXhmmFilterSampleGender=${MC_tmpFile}
	#6
	makeTmpDir ${xhmmPCAfile}
	tmpXhmmPCAfile=${MC_tmpFile}
	makeTmpDir ${xhmmPCAfileGender}
	tmpXhmmPCAfileGender=${MC_tmpFile}
	#7
	makeTmpDir ${xhmmPCANormalizedfile}
	tmpXhmmPCANormalizedfile=${MC_tmpFile}
	makeTmpDir ${xhmmPCANormalizedfileGender}
	tmpXhmmPCANormalizedfileGender=${MC_tmpFile}
	#8
	makeTmpDir ${xhmmPCANormalizedfileFilteredZscores}
	tmpXhmmPCANormalizedfileFilteredZscores=${MC_tmpFile}
	makeTmpDir ${xhmmPCANormalizedfileFilteredZscoresGender}
	tmpXhmmPCANormalizedfileFilteredZscoresGender=${MC_tmpFile}
	#9
	makeTmpDir ${xhmmSameFiltered}
	tmpXhmmSameFiltered=${MC_tmpFile}
	makeTmpDir ${xhmmSameFilteredGender}
	tmpXhmmSameFilteredGender=${MC_tmpFile}
	#10
	makeTmpDir ${xhmmXcnv}
	tmpXhmmXcnv=${MC_tmpFile}
	makeTmpDir ${xhmmXcnvGender}
	tmpXhmmXcnvGender=${MC_tmpFile}
	
	makeTmpDir ${xhmmAUXcnv}
	tmpXhmmAUXcnv=${MC_tmpFile}
	makeTmpDir ${xhmmAUXcnvGender}
	tmpXhmmAUXcnvGender=${MC_tmpFile}
	
	makeTmpDir ${xhmmPosterior}
	tmpXhmmPosterior=${MC_tmpFile}
	makeTmpDir ${xhmmPosteriorGender}
	tmpXhmmPosteriorGender=${MC_tmpFile}
	
	ChrXRun="false"
	run=()
	run+=("autosomal")
	if [ $size != 0 ]
	then
    		echo "the bedfile contains chrX regions, convading now be executed with a male or female controlsgroup"
        	chrXRun="true"
        	run+=("$Gender")
	fi
	
	for i in ${run[@]}
	do
		module load ${xhmmVersion}
	
		cDir=$(awk '{if ($1 == "'${capturingKit}'"){print $2}}' $ControlsVersioning)
	
		if [ "${i}" == "autosomal" ]
        	then
        		xhmmControlsDir=${cxControlsDir}/${cDir}/XHMM/
        	elif [[ "${i}" == "Male" || "${i}" == "Man" ]]
        	then
        		xhmmControlsDir=${cxControlsDir}/${cDir}/XHMM/Male/
        	elif [[ "${i}" == "Female" || "${i}" == "Vrouw" ]]
        	then
        		xhmmControlsDir=${cxControlsDir}/${cDir}/XHMM/Female/
        	else
        		echo "THIS CANNOT BE TRUE, no Male, Female or autosomal!!"
        	fi
		
		if [ -d ${xhmmControlsDir} ]
		then
			if [[ ! -f ${intermediateDir}/capt.txt || ! -f ${intermediateDir}/capt.txt.locked ]]
			then
				## write capturingkit to file to make it easier to split
				echo $capturingKit > ${intermediateDir}/capt.txt
			fi
			module load ${gatkVersion}
			CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)  
		
		
			#Function to check if array contains value
			array_contains () {
				local array="$1[@]"
	    			local seeking=$2
	    			local in=1
	    			for element in "${!array-}" 
				do
	    				if [[ "$element" == "$seeking" ]] 
					then
	        				in=0
       	    					break
        				fi
    				done
    				return $in
			}
		
		
		
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.s1.finished ]
			then
				#
				## Step1
        			#
				for bamFile in "${dedupBam[@]}"
				do
		        		array_contains INPUTS "$bamFile" || INPUTS+=("$bamFile")    # If bamFile does not exist in array add it
		        		array_contains INPUTBAMS "$bamFile" || INPUTBAMS+=("$bamFile")    # If bamFile does not exist in array add it
				done
		
				## Creating bams directory
				mkdir -p ${xhmmDepthOfCoverage}
		
				rm -f ${xhmmDir}/${CAPT}.READS.bam.list
		
				for j in ${INPUTS[@]}
				do
		        		echo "$j" >> ${xhmmDir}/${CAPT}.READS.bam.list
				done
			
				sID=$(basename $dedupBam)
				sampleID=${sID%%.*}
		
				java -Xmx3072m -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
				-T DepthOfCoverage \
				-I ${xhmmDir}/${CAPT}.READS.bam.list \
				-L ${capturedBed} \
				-R ${indexFile} \
				-dt BY_SAMPLE -dcov 5000 -l INFO --omitDepthOutputAtEachBase --omitLocusTable \
				--minBaseQuality 0 --minMappingQuality 20 --start 1 --stop 5000 --nBins 200 \
				--includeRefNSites \
				--countType COUNT_FRAGMENTS \
				-o ${tmpDepthOfCoveragePerSample}.${CAPT}
		
				mv ${tmpDepthOfCoveragePerSample}.${CAPT}* ${xhmmDepthOfCoverage}
				echo "moved ${tmpDepthOfCoveragePerSample}.${CAPT}* ${xhmmDepthOfCoverage}"
	
				echo "s1 finished"
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.s1.finished
			fi
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s2.finished ]
			then
				#
				## Step2
				#		
				if [ "${i}" == "autosomal" ]
                		then
	
					$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
					-o ${tmpXhmmMergedSample} \
					--GATKdepths ${DepthOfCoveragePerSample}.${CAPT}.sample_interval_summary \
					--GATKdepthsList ${xhmmControlsDir}/Controls.sample_interval_summary
					
					echo "AAA"
					echo "${xhmmControlsDir}/Controls.sample_interval_summary"
				
					printf "moving ${tmpXhmmMergedSample} to ${xhmmMergedSample} .. "
					mv ${tmpXhmmMergedSample} ${xhmmMergedSample}
					printf " .. done!"
				
				else
					$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
                        		-o ${tmpXhmmMergedSampleGender} \
                        		--GATKdepths ${DepthOfCoveragePerSample}.${CAPT}.sample_interval_summary \
                        		--GATKdepthsList ${xhmmControlsDir}/Controls.sample_interval_summary
	
					echo "BBB"
					echo "${xhmmControlsDir}/Controls.sample_interval_summary"
	
					
					printf "moving ${tmpXhmmMergedSampleGender} to ${xhmmMergedSampleGender} .. "
        	        		mv ${tmpXhmmMergedSampleGender} ${xhmmMergedSampleGender}
        	        		printf " .. done!"
		
				fi
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s2.finished
				echo "s2 finished"
		
			fi
		
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s5.finished ]
			then
				#
				## Step 5
				#
				xhmmExtremeGcContent=${cxControlsDir}/${CAPT}/${CAPT}.extreme_gc_targets.txt
				if [ "${i}" == "autosomal" ]
                        	then
		
					$EBROOTXHMM/bin/xhmm --matrix \
					-r ${xhmmMergedSample} \
					--centerData \
					--centerType target \
					-o ${tmpXhmmFilterSample} \
					--outputExcludedTargets ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_targets.txt \
					--outputExcludedSamples ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_samples.txt \
					--excludeTargets ${xhmmExtremeGcContent} \
					--minTargetSize 10 \
					--maxTargetSize 10000 \
					--minMeanTargetRD 10 \
					--maxMeanTargetRD 1500 \
					--minMeanSampleRD 25 \
					--maxMeanSampleRD 1000 \
					--maxSdSampleRD 150
			
					printf "moving ${tmpXhmmFilterSample} to ${xhmmFilterSample} .. "
                        		mv ${tmpXhmmFilterSample} ${xhmmFilterSample}
				else
					$EBROOTXHMM/bin/xhmm --matrix \
                                	-r ${xhmmMergedSampleGender} \
                                	--centerData \
                                	--centerType target \
                                	-o ${tmpXhmmFilterSampleGender} \
                                	--outputExcludedTargets ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_targets.txt \
                                	--outputExcludedSamples ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_samples.txt \
                                	--excludeTargets ${xhmmExtremeGcContent} \
                                	--minTargetSize 10 \
                                	--maxTargetSize 10000 \
                                	--minMeanTargetRD 10 \
                                	--maxMeanTargetRD 1500 \
                                	--minMeanSampleRD 25 \
                                	--maxMeanSampleRD 1000 \
                                	--maxSdSampleRD 150
	
                                	printf "moving ${tmpXhmmFilterSampleGender} to ${xhmmFilterSampleGender} .. "
                                	mv ${tmpXhmmFilterSampleGender} ${xhmmFilterSampleGender}
				fi
				echo "s5 finished"
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s5.finished
			fi
		
		#--excludeTargets ${xhmmDir}/${CAPT}.step4.low_complexity_targets.txt \
		#maxMeanTarget changed from 500 (as in tutorial) to 1500 to keep al targets in the calculation
		#maxMeanSampleRD changed from 200 (as in tutorial) to 1000 to keep al targets in the calculation
		
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s6.finished ]
			then
				#
				## Step 6
				#
				if [ "${i}" == "autosomal" ]
                        	then
					$EBROOTXHMM/bin/xhmm --PCA \
					-r ${xhmmFilterSample} \
					--PCAfiles ${tmpXhmmPCAfile}
			
					mv ${tmpXhmmPCAfile}* $(dirname ${xhmmPCAfile})
					echo "moved ${tmpXhmmPCAfile}* ${xhmmPCAfile}"
				else
					$EBROOTXHMM/bin/xhmm --PCA \
                                	-r ${xhmmFilterSampleGender} \
                                	--PCAfiles ${tmpXhmmPCAfileGender}
	
                                	mv ${tmpXhmmPCAfileGender}* $(dirname ${xhmmPCAfileGender})
                                	echo "moved ${tmpXhmmPCAfileGender}* ${xhmmPCAfileGender}"
				fi
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s6.finished
				echo "s6 finished"
			fi
		
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s7.finished ]
			then
				#
				## Step 7
				#
				if [ "${i}" == "autosomal" ]
                        	then
	
					$EBROOTXHMM/bin/xhmm --normalize \
					-r ${xhmmFilterSample} \
					--PCAfiles ${xhmmPCAfile} \
					--normalizeOutput ${tmpXhmmPCANormalizedfile} \
					--PCnormalizeMethod PVE_mean \
					--PVE_mean_factor 0.7
		
					mv ${tmpXhmmPCANormalizedfile} ${xhmmPCANormalizedfile} 
					echo "moved ${tmpXhmmPCANormalizedfile} ${xhmmPCANormalizedfile}"
				else
					$EBROOTXHMM/bin/xhmm --normalize \
                                	-r ${xhmmFilterSampleGender} \
                                	--PCAfiles ${xhmmPCAfileGender} \
                                	--normalizeOutput ${tmpXhmmPCANormalizedfileGender} \
                                	--PCnormalizeMethod PVE_mean \
                                	--PVE_mean_factor 0.7
	
                                	mv ${tmpXhmmPCANormalizedfileGender} ${xhmmPCANormalizedfileGender}
                                	echo "moved ${tmpXhmmPCANormalizedfileGender} ${xhmmPCANormalizedfileGender}"
				fi
				echo "s7 finished"
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s7.finished
			fi
		
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s8.finished ]
			then
				#
				## Step 8
				#
				if [ "${i}" == "autosomal" ]
                        	then
					$EBROOTXHMM/bin/xhmm --matrix \
					-r ${xhmmPCANormalizedfile} \
					--centerData \
					--centerType sample \
					--zScoreData \
					-o ${tmpXhmmPCANormalizedfileFilteredZscores} \
					--outputExcludedTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
					--outputExcludedSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
					--maxSdTargetRD 30
					
					mv ${tmpXhmmPCANormalizedfileFilteredZscores} ${xhmmPCANormalizedfileFilteredZscores}
					echo "moved ${tmpXhmmPCANormalizedfileFilteredZscores} ${xhmmPCANormalizedfileFilteredZscores}"
				else
					$EBROOTXHMM/bin/xhmm --matrix \
                                	-r ${xhmmPCANormalizedfileGender} \
                                	--centerData \
                                	--centerType sample \
                                	--zScoreData \
                                	-o ${tmpXhmmPCANormalizedfileFilteredZscoresGender} \
                                	--outputExcludedTargets ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_targets.txt \
                                	--outputExcludedSamples ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_samples.txt \
                                	--maxSdTargetRD 30
	
                                	mv ${tmpXhmmPCANormalizedfileFilteredZscoresGender} ${xhmmPCANormalizedfileFilteredZscoresGender}
                                	echo "moved ${tmpXhmmPCANormalizedfileFilteredZscoresGender} ${xhmmPCANormalizedfileFilteredZscoresGender}"
				fi
				echo "s8 finished"
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s8.finished
			fi
		
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s9.finished ]
			then
				#
				## Step 9
				#
				if [ "${i}" == "autosomal" ]
                        	then
					$EBROOTXHMM/bin/xhmm --matrix \
					-r ${xhmmMergedSample} \
					--excludeTargets ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_targets.txt \
					--excludeTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
					--excludeSamples ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_samples.txt \
					--excludeSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
					-o ${tmpXhmmSameFiltered}
			
					mv ${tmpXhmmSameFiltered} ${xhmmSameFiltered}
					echo "moved ${tmpXhmmSameFiltered} ${xhmmSameFiltered}"
				else
					$EBROOTXHMM/bin/xhmm --matrix \
                                	-r ${xhmmMergedSampleGender} \
                                	--excludeTargets ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_targets.txt \
                                	--excludeTargets ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_targets.txt \
                                	--excludeSamples ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_samples.txt \
                                	--excludeSamples ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_samples.txt \
                                	-o ${tmpXhmmSameFilteredGender}
	
                                	mv ${tmpXhmmSameFilteredGender} ${xhmmSameFilteredGender}
                                	echo "moved ${tmpXhmmSameFilteredGender} ${xhmmSameFilteredGender}"
				fi
				echo "s9 finished"
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s9.finished
			fi
		
			if [ ! -f ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s10.finished ]
			then
				#
				## Step 10
				#
				if [ "${i}" == "autosomal" ]
                        	then
					$EBROOTXHMM/bin/xhmm --discover \
					--discoverSomeQualThresh 0 \
					-p ${xhmmHighSenseParams} \
					-r ${xhmmPCANormalizedfileFilteredZscores} \
					-R ${xhmmSameFiltered} \
					-c ${tmpXhmmXcnv} \
					-a ${tmpXhmmAUXcnv} \
					-s ${tmpXhmmPosterior}
		
					mv ${tmpXhmmXcnv} ${xhmmXcnv}			
					mv ${tmpXhmmAUXcnv} ${xhmmAUXcnv}
					mv ${tmpXhmmPosterior}.posteriors*.txt $(dirname ${xhmmPosterior})
					echo "moved ${tmpXhmmXcnv} ${xhmmXcnv}"
					echo "moved ${tmpXhmmAUXcnv} ${xhmmAUXcnv}"
					echo "moved ${tmpXhmmPosterior}* $(dirname ${xhmmPosterior})"
				else
					$EBROOTXHMM/bin/xhmm --discover \
                                	--discoverSomeQualThresh 0 \
                                	-p ${xhmmHighSenseParams} \
                                	-r ${xhmmPCANormalizedfileFilteredZscoresGender} \
                                	-R ${xhmmSameFilteredGender} \
                                	-c ${tmpXhmmXcnvGender} \
                                	-a ${tmpXhmmAUXcnvGender} \
                                	-s ${tmpXhmmPosteriorGender}
	
                                	mv ${tmpXhmmXcnvGender} ${xhmmXcnvGender}
                                	mv ${tmpXhmmAUXcnvGender} ${xhmmAUXcnvGender}
                                	mv ${tmpXhmmPosteriorGender}.posteriors*.txt $(dirname ${xhmmPosteriorGender})
                                	echo "moved ${tmpXhmmXcnvGender} ${xhmmXcnvGender}"
                                	echo "moved ${tmpXhmmAUXcnvGender} ${xhmmAUXcnvGender}"
                                	echo "moved ${tmpXhmmPosteriorGender}* $(dirname ${xhmmPosteriorGender})"
				fi
				
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s10.finished
				echo "s10 finished"
			fi
		else 
			echo "XHMM step skipped since there are no controls for this group: ${cDir}/XHMM/"
		fi
	done
	
	if [ -f ${xhmmXcnv} ]
	then
		awk '{
                	if ($3 !~ "X") 
                	{
                        	print $0
                	}			
        	}' ${xhmmXcnv} > ${xhmmXcnv}.withoutX
	
		echo "chrX is cut out of ${xhmmXcnv}"
	fi
	
	if [ -f ${xhmmXcnvGender} ]
	then
		awk '{
			if ($3 ~ "X")
			{
                		print $0
                	}
		}' ${xhmmXcnvGender} >  ${xhmmXcnvGender}.onlyX
		echo "only chrX is selected out of ${xhmmXcnv}"
	
		if [ -f ${xhmmXcnv}.withoutX ]
		then
			echo "pasting withoutX and onlyX together into ${xhmmXcnv}.tmp"
			cat ${xhmmXcnv}.withoutX ${xhmmXcnvGender}.onlyX >  ${xhmmXcnv}.tmp
			echo "moving ${xhmmXcnv}.tmp to ${xhmmXcnv}"
			mv ${xhmmXcnv}.tmp ${xhmmXcnv}
		fi
	fi 
	
	if [ -f ${xhmmAUXcnv} ]
	then
        	awk '{
              		if ($3 !~ "X")
                	{
                        	print $0
                	}    
    		}' ${xhmmAUXcnv} > ${xhmmAUXcnv}.withoutX
		echo "chrX is cut out of ${xhmmAUXcnv}"
	
	fi
	
	if [ -f ${xhmmAUXcnvGender} ]
	then
        	awk '{
                	if ($3 ~ "X") 
                	{
                        	print $0
                	}
        	}' ${xhmmAUXcnvGender} > ${xhmmAUXcnvGender}.onlyX
		echo "only chrX is selected out of ${xhmmAUXcnvGender} "
	
        	if [ -f	${xhmmAUXcnv}.withoutX ]
        	then
        		echo "pasting withoutX and onlyX together into ${xhmmAUXcnv}.tmp"
	
	        	cat ${xhmmAUXcnv}.withoutX ${xhmmAUXcnvGender}.onlyX >  ${xhmmAUXcnv}.tmp
                	echo "moving ${xhmmAUXcnv}.tmp to ${xhmmAUXcnv}"
                	mv ${xhmmAUXcnv}.tmp ${xhmmAUXcnv}
        	fi
	fi 
	if ls ${DepthOfCoveragePerSample}* 1> /dev/null 2>&1
	then
		mv ${DepthOfCoveragePerSample}*  ${intermediateDir}
		echo "moved all XHMM intermediate files from ${DepthOfCoveragePerSample}* to ${intermediateDir}"
	else
		echo "${DepthOfCoveragePerSample}* is already copied"
	fi
	
else
	echo "for this bedfile there is no Controlsgroup"
fi

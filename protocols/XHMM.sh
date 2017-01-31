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
#string DepthOfCoveragePerSampleGender
#string gatkVersion
#string xhmmMergedSample
#string xhmmMergedSampleGender
#string xhmmDataDir
#string xhmmDir
#string xhmmDepthOfCoverage
#string xhmmDepthOfCoverageGender
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
#string externalSampleID

basenameDedupBam==$(basename ${dedupBam})
nameOfSample=${basenameDedupBam%%.*}
chrXCalls="unset"
autosomalCalls="unset"

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

	makeTmpDir ${DepthOfCoveragePerSampleGender}
	tmpDepthOfCoveragePerSampleGender=${MC_tmpFile}

	tmpPrefix=${tmpDepthOfCoveragePerSample}
	tmpPrefixGender=${tmpDepthOfCoveragePerSampleGender}

	ChrXRun="false"
	run=()
	run+=("autosomal")
	if [ $size != 0 ]
	then
        	chrXRun="true"
        	run+=("$Gender")
	fi
	onlyHeader="false"
	onlyHeaderGender="false"

	echo 
	for i in ${run[@]}
	do
		echo "analyzing $i"
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
        		echo "THIS CANNOT BE TRUE, no Male, Female or autosomal!! --> Gender is $i"
			
			trap - EXIT
                	exit 0
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
		
				## Creating bams directory
				#mkdir -p ${xhmmDepthOfCoverage}/Gender/
		
				rm -f ${xhmmDir}/${CAPT}.READS.bam.list
		
	        		echo "$dedupBam" > ${dedupBam}.READS.bam.list
			
				sID=$(basename $dedupBam)
				sampleID=${sID%%.*}
		
				java -Xmx3072m -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
				-T DepthOfCoverage \
				-I ${dedupBam}.READS.bam.list \
				-L ${capturedBed} \
				-R ${indexFile} \
				-dt BY_SAMPLE -dcov 5000 -l INFO --omitDepthOutputAtEachBase --omitLocusTable \
				--minBaseQuality 0 --minMappingQuality 20 --start 1 --stop 5000 --nBins 200 \
				--includeRefNSites \
				--countType COUNT_FRAGMENTS \
				-o ${tmpPrefix}
		
				mv ${tmpPrefix}* ${xhmmDepthOfCoverage}/${externalSampleID}/
				echo "moved ${tmpPrefix}* ${xhmmDepthOfCoverage}/$externalSampleID"
				
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
					echo "${DepthOfCoveragePerSample}.sample_interval_summary" >  ${DepthOfCoveragePerSample}.sample_interval_summary.list
					cat ${DepthOfCoveragePerSample}.sample_interval_summary.list ${xhmmControlsDir}/Controls.sample_interval_summary > ${DepthOfCoveragePerSample}.sample_interval_summary.biglist

					$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
					-o ${tmpPrefix}.step2.DATA.RD.txt \
					--GATKdepthsList ${DepthOfCoveragePerSample}.sample_interval_summary.biglist 
					
					echo "${xhmmControlsDir}/Controls.sample_interval_summary"
				
					printf "moving ${tmpPrefix}.step2.DATA.RD.txt to ${xhmmMergedSample} .. "
					mv ${tmpPrefix}.step2.DATA.RD.txt ${xhmmMergedSample}
					printf " .. done!"
				
				else
					echo "${DepthOfCoveragePerSample}.sample_interval_summary" >  ${DepthOfCoveragePerSample}.sample_interval_summary.list
                                        cat ${DepthOfCoveragePerSample}.sample_interval_summary.list ${xhmmControlsDir}/Controls.sample_interval_summary > ${DepthOfCoveragePerSampleGender}.sample_interval_summary.biglist
					$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
                        		-o ${tmpPrefixGender}.step2.DATA.RD.txt \
                        		--GATKdepthsList ${DepthOfCoveragePerSampleGender}.sample_interval_summary.biglist
	
					echo "${xhmmControlsDir}/Controls.sample_interval_summary"
	
					
					printf "moving ${tmpPrefixGender}.step2.DATA.RD.txt to ${xhmmMergedSampleGender} .. "
        	        		mv ${tmpPrefixGender}.step2.DATA.RD.txt ${xhmmMergedSampleGender}
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
					-o ${tmpPrefix}_step5.filtered_centered.RD.txt \
					--outputExcludedTargets ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_targets.txt \
					--outputExcludedSamples ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_samples.txt \
					--excludeTargets ${xhmmExtremeGcContent} \
					--minTargetSize 10 \
					--maxTargetSize 10000 \
					--minMeanTargetRD 10 \
					--maxMeanTargetRD 1500 \
					--minMeanSampleRD 25 \
					--maxMeanSampleRD 1000 \
					--maxSdSampleRD 200
			
					printf "moving ${tmpPrefix}_step5.filtered_centered.RD.txt to ${xhmmFilterSample} .. "
                        		mv ${tmpPrefix}_step5.filtered_centered.RD.txt ${xhmmFilterSample}
				else
					$EBROOTXHMM/bin/xhmm --matrix \
                                	-r ${xhmmMergedSampleGender} \
                                	--centerData \
                                	--centerType target \
					-o ${tmpPrefixGender}_step5.filtered_centered.RD.txt \
                                	--outputExcludedTargets ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_targets.txt \
                                	--outputExcludedSamples ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_samples.txt \
                                	--excludeTargets ${xhmmExtremeGcContent} \
                                	--minTargetSize 10 \
                                	--maxTargetSize 10000 \
                                	--minMeanTargetRD 10 \
                                	--maxMeanTargetRD 1500 \
                                	--minMeanSampleRD 25 \
                                	--maxMeanSampleRD 1000 \
                                	--maxSdSampleRD 200
	
                                	printf "moving ${tmpPrefixGender}_step5.filtered_centered.RD.txt to ${xhmmFilterSampleGender} .. "
                                	mv ${tmpPrefixGender}_step5.filtered_centered.RD.txt ${xhmmFilterSampleGender}
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
					--PCAfiles ${tmpPrefix}_step6_RD.PCA
			
					mv ${tmpPrefix}_step6_RD.PCA* $(dirname ${xhmmPCAfile})
					echo "moved ${tmpPrefix}_step6_RD.PCA* ${xhmmPCAfile}"
				else
					$EBROOTXHMM/bin/xhmm --PCA \
                                	-r ${xhmmFilterSampleGender} \
                                	--PCAfiles ${tmpPrefixGender}_step6_RD.PCA
	
                                	mv  ${tmpPrefixGender}_step6_RD.PCA* $(dirname ${xhmmPCAfileGender})
                                	echo "moved  ${tmpPrefixGender}_step6_RD.PCA* ${xhmmPCAfileGender}"
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
					--normalizeOutput ${tmpPrefix}_step7.PCA_normalized.txt \
					--PCnormalizeMethod PVE_mean \
					--PVE_mean_factor 0.7
		
					mv ${tmpPrefix}_step7.PCA_normalized.txt ${xhmmPCANormalizedfile} 
					echo "moved ${tmpPrefix}_step7.PCA_normalized.txt ${xhmmPCANormalizedfile}"
				else
					$EBROOTXHMM/bin/xhmm --normalize \
                                	-r ${xhmmFilterSampleGender} \
                                	--PCAfiles ${xhmmPCAfileGender} \
                                	--normalizeOutput ${tmpPrefixGender}_step7.PCA_normalized.txt \
                                	--PCnormalizeMethod PVE_mean \
                                	--PVE_mean_factor 0.7
	
                                	mv ${tmpPrefixGender}_step7.PCA_normalized.txt ${xhmmPCANormalizedfileGender}
                                	echo "moved ${tmpPrefixGender}_step7.PCA_normalized.txt ${xhmmPCANormalizedfileGender}"
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
					-o ${tmpPrefix}_step8.PCA_normalized.filtered.sample_zscores.RD.txt \
					--outputExcludedTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
					--outputExcludedSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
					--maxSdTargetRD 30
					
					mv ${tmpPrefix}_step8.PCA_normalized.filtered.sample_zscores.RD.txt ${xhmmPCANormalizedfileFilteredZscores}
					echo "moved ${tmpPrefix}_step8.PCA_normalized.filtered.sample_zscores.RD.txt ${xhmmPCANormalizedfileFilteredZscores}"
				else
					$EBROOTXHMM/bin/xhmm --matrix \
                                	-r ${xhmmPCANormalizedfileGender} \
                                	--centerData \
                                	--centerType sample \
                                	--zScoreData \
                                	-o ${tmpPrefixGender}_step8.PCA_normalized.filtered.sample_zscores.RD.txt \
                                	--outputExcludedTargets ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_targets.txt \
                                	--outputExcludedSamples ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_samples.txt \
                                	--maxSdTargetRD 30
	
                                	mv ${tmpPrefixGender}_step8.PCA_normalized.filtered.sample_zscores.RD.txt ${xhmmPCANormalizedfileFilteredZscoresGender}
                                	echo "moved ${tmpPrefixGender}_step8.PCA_normalized.filtered.sample_zscores.RD.txt ${xhmmPCANormalizedfileFilteredZscoresGender}"
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
					-o ${tmpPrefix}_step9.same_filtered.RD.txt
			
					mv ${tmpPrefix}_step9.same_filtered.RD.txt ${xhmmSameFiltered}
					echo "moved ${tmpPrefix}_step9.same_filtered.RD.txt ${xhmmSameFiltered}"
				else
					$EBROOTXHMM/bin/xhmm --matrix \
                                	-r ${xhmmMergedSampleGender} \
                                	--excludeTargets ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_targets.txt \
                                	--excludeTargets ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_targets.txt \
                                	--excludeSamples ${xhmmMergedSampleGender}.filtered_centered.RD.txt.filtered_samples.txt \
                                	--excludeSamples ${xhmmPCANormalizedfileFilteredZscoresGender}.filtered_samples.txt \
                                	-o ${tmpPrefixGender}_step9.same_filtered.RD.txt
	
                                	mv ${tmpPrefixGender}_step9.same_filtered.RD.txt ${xhmmSameFilteredGender}
                                	echo "moved ${tmpPrefixGender}_step9.same_filtered.RD.txt ${xhmmSameFilteredGender}"
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
					-c ${tmpPrefix}_step10.xcnv \
					-a ${tmpPrefix}_step10.aux_cnv \
					-s ${tmpPrefix}_step10
				
                 			awk '{
						if (NR==1){
							print $0
						}else{
							if ($5 != "X")
                               				{
                                	       			print $0
                               				}
                        			}
					}' ${tmpPrefix}_step10.xcnv > ${xhmmXcnv}.withoutX
					cp ${tmpPrefix}_step10.xcnv ${xhmmXcnv}
							
			
				else
					$EBROOTXHMM/bin/xhmm --discover \
                                	--discoverSomeQualThresh 0 \
                                	-p ${xhmmHighSenseParams} \
                                	-r ${xhmmPCANormalizedfileFilteredZscoresGender} \
                                	-R ${xhmmSameFilteredGender} \
                                	-c ${tmpPrefixGender}_step10.xcnv \
                                	-a ${tmpPrefixGender}_step10.aux_cnv \
                                	-s ${tmpPrefixGender}_step10
	
					## Only keep the calls from this sample
					awk '{
                                                if (NR==1){
                                                        print $0
                                                }else{
                                                        if ($5 == "X")
                                                        {
                                                                print $0
                                                        }
                                                }
                                        }' ${tmpPrefixGender}_step10.xcnv > ${xhmmXcnvGender}.chrX
					cp ${tmpPrefixGender}_step10.xcnv ${xhmmXcnvGender}

				fi
				
				touch ${intermediateDir}/XHMM_combined.${nameOfSample}.${i}.s10.finished
				echo "s10 finished"
			fi
		else 
			echo "XHMM step skipped since there are no controls for this group: ${cDir}/XHMM/"
		fi
	done

	#
	##cleaning up xcnv with X only calls in genderfile and autosomal in normal file 
	#

	if grep ${nameOfSample} ${xhmmXcnv}.withoutX
	then
		## There is a call for this sample		
		echo "${nameOfSample} is in ${xhmmXcnv}.withoutX"	
		grep ${nameOfSample} ${xhmmXcnv}.withoutX > ${xhmmXcnv}.filtered.withoutX
		autosomalCalls="true"
	
	else
		autosomalCalls="false"
		## There is no call for this sample			
	fi

	if [ -f ${xhmmXcnvGender} ]
	then 
		if grep ${nameOfSample} ${xhmmXcnvGender}.chrX
		then
			echo "${nameOfSample} is in ${xhmmXcnvGender}.chrX"
			grep ${nameOfSample} ${xhmmXcnvGender}.chrX > ${xhmmXcnvGender}.filtered.chrX
			chrXCalls="true"
		else
			chrXCalls="false"
		fi
	else
		echo "panel does not contain X region"	
	fi
	echo "autosomalCalls:${autosomalCalls}"
	echo "chrXCalls:${chrXCalls}"
	
	

	if [ ${autosomalCalls} == "true" ]
	then	
		head -1 ${xhmmXcnv} > ${xhmmXcnv}.final
		if [ ${chrXCalls} == "true" ]
		then
			echo "pasting withoutX and onlyX together into ${xhmmXcnv}.tmp"
			echo "cat ${xhmmXcnv}.filtered.withoutX ${xhmmXcnvGender}.filtered.chrX >> ${xhmmXcnv}.final"

			cat ${xhmmXcnv}.filtered.withoutX ${xhmmXcnvGender}.filtered.chrX >> ${xhmmXcnv}.final

			echo "creating ${xhmmXcnv}.final it will contain autosomal and chrX calls"
	
		else
			## .xnv.final file will contain only autosomal calls ##
			echo -e "#without X \n# no onlyX\n\n## .xnv.final file will contain only autosomal calls ####"
			cat ${xhmmXcnv}.filtered.withoutX >> ${xhmmXcnv}.final
		fi
	elif [ ${chrXCalls} == "true" ]
	then	
		head -1 ${xhmmXcnvGender} > ${xhmmXcnv}.final
			
		## .xnv.final file will contain only chrX calls ##
		echo -e "# no without X \n#onlyX\n\n## .xnv.final file will contain only chrX calls ####"
		cat ${xhmmXcnvGender}.filtered.chrX >> ${xhmmXcnv}.final

	else
		if [ ${chrXCalls} == "unset" ]
		then
			echo "Panel does not contain chrX. No calls found in autosomal region, file will only contain a header"
		else
			echo -e "# no without X \n# no onlyX\n\n## .xnv.final file will only contain a header ###"
		fi
	
		head -1 ${xhmmXcnv} > ${xhmmXcnv}.final
	fi		
	if [ -f ${xhmmXcnv}.final ]
	then	
		cp ${xhmmXcnv}.final ${intermediateDir}
		echo "copied ${xhmmXcnv}.final to ${intermediateDir}/$(basename ${xhmmXcnv}.final)"
	fi	
	
else
	echo "for this bedfile there is no Controlsgroup"
fi

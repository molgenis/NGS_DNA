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
#string xhmmDataDir
#string xhmmDir
#string xhmmDepthOfCoverage
#string xhmmVersion
#string xhmmFilterSample
#string xhmmPCAfile
#string xhmmPCANormalizedfile
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmSameFiltered
#string xhmmXcnv
#string xhmmAUXcnv
#string xhmmPosterior
#string xhmmHighSenseParams
#string ControlsVersioning
#string cxControlsDir

nameOfSample=$(basename ${dedupBam%%.*})

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
makeTmpDir ${xhmmDir}
tmpXhmmDir=${MC_tmpFile}
#2
makeTmpDir ${xhmmMergedSample}
tmpXhmmMergedSample=${MC_tmpFile}
#5
makeTmpDir ${xhmmFilterSample}
tmpXhmmFilterSample=${MC_tmpFile}
#6
makeTmpDir ${xhmmPCAfile}
tmpXhmmPCAfile=${MC_tmpFile}
#7
makeTmpDir ${xhmmPCANormalizedfile}
tmpXhmmPCANormalizedfile=${MC_tmpFile}
#8
makeTmpDir ${xhmmPCANormalizedfileFilteredZscores}
tmpXhmmPCANormalizedfileFilteredZscores=${MC_tmpFile}
#9
makeTmpDir ${xhmmSameFiltered}
tmpXhmmSameFiltered=${MC_tmpFile}
#10
10
makeTmpDir ${xhmmXcnv}
tmpXhmmXcnv=${MC_tmpFile}

ChrXRun="false"
run=()
run+=("autosomal")
if [ $size != 0 ]
then
    	echo "the bedfile contains chrX regions, convading now be executed with a male or female controlsgroup"
        chrXRun="true"
        run+=("$gender")
fi

for i in ${run[@]}
do
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
	
	
	
		if [ ! -f XHMM_combined.${nameOfSample}.s1.finished ]
		then
			#
			## Step1
        		#
			makeTmpDir ${xhmmDir}
			tmpXhmmDir=${MC_tmpFile}
		
			for bamFile in "${dedupBam[@]}"
			do
		        	array_contains INPUTS "$bamFile" || INPUTS+=("$bamFile")    # If bamFile does not exist in array add it
		        	array_contains INPUTBAMS "$bamFile" || INPUTBAMS+=("$bamFile")    # If bamFile does not exist in array add it
			done
	
			## Creating bams directory
			mkdir -p ${xhmmDepthOfCoverage}
	
			rm -f ${xhmmDir}/${CAPT}.READS.bam.list
	
			for i in ${INPUTS[@]}
			do
		        	echo "$i" >> ${xhmmDir}/${CAPT}.READS.bam.list
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
			-o ${DepthOfCoveragePerSample}.${CAPT}
	
			echo "s1 finished"
			touch XHMM_combined.${nameOfSample}.s1.finished
		fi
		if [ ! -f XHMM_combined.${nameOfSample}.s2.finished ]
		then
		#
		## Step2
		#
			module load ${xhmmVersion}
		
			makeTmpDir ${xhmmMergedSample}
			tmpXhmmMergedSample=${MC_tmpFile}
		
			$EBROOTXHMM/bin/xhmm --mergeGATKdepths \
			-o ${tmpXhmmMergedSample} \
			--GATKdepths ${DepthOfCoveragePerSample}.${CAPT}.sample_interval_summary \
			--GATKdepthsList ${xhmmControlsDir}/Controls.sample_interval_summary
	
			printf "moving ${tmpXhmmMergedSample} to ${xhmmMergedSample} .. "
			mv ${tmpXhmmMergedSample} ${xhmmMergedSample}
			printf " .. done!"
	
			touch XHMM_combined.${nameOfSample}.s2.finished
			echo "s2 finished"
	
		fi
	
		if [ ! -f XHMM_combined.${nameOfSample}.s5.finished ]
		then
		#
		## Step 5
		#
			xhmmExtremeGcContent=${xhmmDataDir}/${CAPT}/step3.extreme_gc_targets.txt
	
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
			echo "s5 finished"
			touch XHMM_combined.${nameOfSample}.s5.finished
		fi
	
	#--excludeTargets ${xhmmDir}/${CAPT}.step4.low_complexity_targets.txt \
	#maxMeanTarget changed from 500 (as in tutorial) to 1500 to keep al targets in the calculation
	#maxMeanSampleRD changed from 200 (as in tutorial) to 1000 to keep al targets in the calculation
	
		if [ ! -f XHMM_combined.${nameOfSample}.s6.finished ]
		then
		#
		## Step 6
		#

			$EBROOTXHMM/bin/xhmm --PCA \
			-r ${xhmmFilterSample} \
			--PCAfiles ${tmpXhmmPCAfile}
	
			mv ${tmpXhmmPCAfile} ${xhmmPCAfile}
			echo "moved ${tmpXhmmPCAfile} ${xhmmPCAfile}"
		
			touch XHMM_combined.${nameOfSample}.s6.finished
			echo "s6 finished"
		fi
	
		if [ ! -f XHMM_combined.${nameOfSample}.s7.finished ]
		then
		#
		## Step 7
		#
			$EBROOTXHMM/bin/xhmm --normalize \
			-r ${xhmmFilterSample} \
			--PCAfiles ${xhmmPCAfile} \
			--normalizeOutput ${tmpXhmmPCANormalizedfile} \
			--PCnormalizeMethod PVE_mean \
			--PVE_mean_factor 0.7

			mv ${tmpXhmmPCANormalizedfile} ${xhmmPCANormalizedfile} 
			echo "moved ${tmpXhmmPCANormalizedfile} ${xhmmPCANormalizedfile}"
			echo "s7 finished"
			touch XHMM_combined.${nameOfSample}.s7.finished
		fi
	
		if [ ! -f XHMM_combined.${nameOfSample}.s8.finished ]
		then
		#
		## Step 8
		#
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
	
			echo "s8 finished"
			touch XHMM_combined.${nameOfSample}.s8.finished
		fi
	
		if [ ! -f XHMM_combined.${nameOfSample}.s9.finished ]
		then
		#
		## Step 9
		#
			$EBROOTXHMM/bin/xhmm --matrix \
			-r ${xhmmMergedSample} \
			--excludeTargets ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_targets.txt \
			--excludeTargets ${xhmmPCANormalizedfileFilteredZscores}.filtered_targets.txt \
			--excludeSamples ${xhmmMergedSample}.filtered_centered.RD.txt.filtered_samples.txt \
			--excludeSamples ${xhmmPCANormalizedfileFilteredZscores}.filtered_samples.txt \
			-o ${tmpXhmmSameFiltered}
	
			mv ${tmpXhmmSameFiltered} ${xhmmSameFiltered}
			echo "moved ${tmpXhmmSameFiltered} ${xhmmSameFiltered}"

			echo "s9 finished"
			touch XHMM_combined.${nameOfSample}.s9.finished
		fi
	
		if [ ! -f XHMM_combined.${nameOfSample}.s10.finished ]
		then
		#
		## Step 10
		#
			
			$EBROOTXHMM/bin/xhmm --discover \
			--discoverSomeQualThresh 0 \
			-p ${xhmmHighSenseParams} \
			-r ${xhmmPCANormalizedfileFilteredZscores} \
			-R ${xhmmSameFiltered} \
			-c ${tmpXhmmXcnv} \
			-a ${xhmmAUXcnv} \
			-s ${xhmmPosterior}
			touch XHMM_combined.${nameOfSample}.s10.finished
			echo "s10 finished"
		fi
	else 
		echo "XHMM step skipped since there are no controls for this group: ${cDir}/XHMM/"
	fi
done

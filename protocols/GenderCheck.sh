#string tmpName
#string dedupBamMetrics
#string dedupBam
#string capturedIntervals
#string capturedIntervals_nonAutoChrX
#string indexFileDictionary
#string projectResultsDir
#string intermediateDir
#string whichSex
#string Gender
#string tempDir
#string checkSexMeanCoverage
#string picardJar
#string hsMetricsNonAutosomalRegionChrX
^#string project
#string logsDir 
#string groupname
#string picardVersion

module load "${picardVersion}"

if [ -f "${dedupBamMetrics}.noChrX" ]
then
	printf "There is no chrX, a gender cannot be determined\n" > "${whichSex}"
	printf "Unknown\n" >> "${whichSex}"
else
	if [ -f "${checkSexMeanCoverage}" ]
	then
		rm "${checkSexMeanCoverage}"
	fi

	#select only the mean target coverage of the whole genome file
	awk '{
if ($0 ~ /^#/){

		}
		else if ($23 == ""){
		}else if ( $23 == "MEAN_TARGET_COVERAGE" ){

		}else{
			print $23
	}
	}' "${dedupBamMetrics}.hs_metrics" >> "${checkSexMeanCoverage}"


	avgCov=$(awk '{print $1}' "${checkSexMeanCoverage}")

	if [[ "${avgCov}" == .* ]]
        then
		printf "There is no autosomal region, a gender cannot be determined\n" > ${whichSex}
                printf "Unknown\n" >> ${whichSex}

        elif [[ "${avgCov}" < 1 ]]
        then
		echo "${avgCov} of autosomes is lower than 1, skipped"
                printf "There is no autosomal region, a gender cannot be determined\n" > "${whichSex}"
                printf "Unknown\n" >> "${whichSex}"
        else

		#select only the mean target coverage of chromosome X
		awk '{
		if ($0 ~ /^#/){

		}
		else if ($23 == ""){
			}else if ( $23 == "MEAN_TARGET_COVERAGE" ){

			}else{
				print $23
			}
		}' "${hsMetricsNonAutosomalRegionChrX}" >> "${checkSexMeanCoverage}"



		perl -pi -e 's/\n/\t/' "${checkSexMeanCoverage}"

		RESULT=$(awk '{
			if ( "NA" == $1 || "?" == $2 ){
				print "1) This is probably a whole genome sample, due to time saving there is no coverage calculated"
				print "Unknown"
			} else {
				printf "%.2f \n", $2/$1 
			}
		}' "${checkSexMeanCoverage}")

		echo "RESULT: $RESULT"
		echo "\$1 is the mean coverage of the autosomes"
		echo "\$2 is the mean coverage of non autosomal chrX"
		awk '{
			if ( length($1) == 0){
				print "${dedupBamMetrics}.hs_metrics has not a MEAN TARGET COVERAGE value"
				exit 0
			}
			else if ( length($2) == 0 ){
				print "${dedupBamMetrics}.nonAutosomalRegionChrX_hs_metrics has not a MEAN TARGET COVERAGE value"
				exit 0
			}
			else if ( "NA" == $1 || "?" == $2 ) {
				print "2) This is probably a whole genome sample, due to time saving there is no coverage calculated"
				print "Unknown"
			}
			else if ($2/$1 < 0.65 ){
				print $2," divided by ",$1," is "$2"/"$1", this is less than 0.65 and this means that the coverage on chromosome X is 0.65 times less than the average coverage of the entire genome, this will most likely be a male";
				print "Male"

			}else if ($2/$1 > 0.85 ){
				print $2," divided by ",$1," is "$2"/"$1", this is more than 0.85 and this means that the coverage on chromosome X is almost the same as the average coverage of the entire genome, this will most likely be a female";
				print "Female"
			}
			else{
				print $2," divided by ",$1," is "$2"/"$1", this is in between the 0.65 and 0.85, we are not sure what the sex is based on the coverage on chromosome X"
				print "Unknown" 
			}
		}' "${checkSexMeanCoverage}" >> "${whichSex}"
	fi
fi

sex=$(less "${whichSex}" | awk 'NR==2')

runNumber=$(basename "${intermediateDir}")

if [ "${sex}" != "${Gender}" ]
then
	echo "gender is different between samplesheet and calculated"
	if [[ "${sex}" == "Unknown" || "${Gender}" == "Unknown" ]]
	then
		if [ "${sex}" == "Unknown" ]
		then
			echo "calculated ($sex) was unknown, but in the samplesheet it was specified ($Gender), $whichSex file has been updated"
			cp "${whichSex}" "${whichSex}.tmp"
			rename chosenSex oldGender "${whichSex}"
			echo "the calculation of the sex cannot be determined, file has been moved from chosenSex name to oldGender name" > ${whichSex} 
			echo "$Gender" >> ${whichSex} 
		else
			echo "In the samplesheet the gender was not specified (thus Unknown), but it has been calculated"
		fi
	else
		echo "ALARM ALARM"
		echo "ALARM, ALARM, the calculated gender (${sex}) and the gender given in the samplesheet(${Gender}) are not the same!"
		sampleName=$(basename ${dedupBamMetrics})
		echo -e "ALARM!\nFor sample ${sampleName%%.*} the calculated gender (${sex}) and the gender given in the samplesheet(${Gender}) are not the same!" > "${logsDir}/${project}/${runNumber}.pipeline.gendercheckfailed"
	fi
fi
echo "moving ${whichSex} to ${projectResultsDir}/general/"
mv "${whichSex}" "${projectResultsDir}/general/"

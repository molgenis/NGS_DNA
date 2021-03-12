#Parameter mapping
#string tmpName
#string gatkVersion
#string gatkJar
#string intermediateDir
#string dedupBam
#string project
#string logsDir 
#string groupname
#string externalSampleID
#string indexFile
#string capturedIntervalsPerBase
#string capturedBed
#string sampleNameID
#string capturingKit
#string coveragePerBaseDir
#string coveragePerTargetDir
#string ngsUtilsVersion
#string Gender
#string projectResultsDir

module load "${gatkVersion}"
module load "${ngsUtilsVersion}"

### Per base bed files
bedfileRaw=$(basename "${capturingKit}")
if [[ "${bedfileRaw}" =~ "QXT" ]]
then
	bedfile=$(echo "${bedfileRaw}" | awk '{print substr($0,4)}')
elif [[ "${bedfileRaw}" =~ "XT-HS" ]]
then
	bedfile=$(echo "${bedfileRaw}" | awk '{print substr($0,6)}')
elif [[ "${bedfileRaw}" =~ "XT" ]]
then
	bedfile=$(echo "${bedfileRaw}" | awk '{print substr($0,3)}')
else
	bedfile="${bedfileRaw}"
fi

echo "MYBEDFILE is: ${bedfile} it was ${bedfileRaw}"
if [ -d "${coveragePerBaseDir}/${bedfile}" ]
then
	for i in $(ls -d "${coveragePerBaseDir}/${bedfile}"/*)
	do
		perBase=$(basename "${i}")
		perBaseDir=$(echo $(dirname "${i}")/${perBase}/human_g1k_v37/)
		echo "perBaseDir: ${perBaseDir}"
		java -Xmx7g -XX:ParallelGCThreads=1 -jar "${EBROOTGATK}/${gatkJar}" \
		-R "${indexFile}" \
		-T DepthOfCoverage \
		-o "${sampleNameID}.${perBase}.coveragePerBase" \
		--omitLocusTable \
		-mmq 20 \
		--includeRefNSites \
		-I "${dedupBam}" \
		-L "${perBaseDir}/${perBase}.interval_list"

		sed '1d' "${sampleNameID}.${perBase}.coveragePerBase" > "${sampleNameID}.${perBase}.coveragePerBase_withoutHeader"
		sort -V "${sampleNameID}.${perBase}.coveragePerBase_withoutHeader" > "${sampleNameID}.${perBase}.coveragePerBase_withoutHeader.sorted"
		tail -n+87 "${perBaseDir}/${perBase}.uniq.per_base.interval_list" > "${sampleNameID}.${perBase}.uniqperbase_chompedHeaders.txt"
		paste "${sampleNameID}.${perBase}.uniqperbase_chompedHeaders.txt" "${sampleNameID}.${perBase}.coveragePerBase_withoutHeader.sorted" > "${sampleNameID}.${perBase}.combined_bedfile_and_samtoolsoutput.txt"

		##Paste command produces ^M character
		perl -p -i -e "s/\r//g" "${sampleNameID}.${perBase}.combined_bedfile_and_samtoolsoutput.txt"

		echo -e "Index\tChr\tChr Position Start\tDescription\tMin Counts\tCDS\tContig" > "${sampleNameID}.${perBase}.coveragePerBase.txt"

		awk -v OFS='\t' '{print NR,$1,$2,$5,$7,"CDS","1"}' "${sampleNameID}.${perBase}.combined_bedfile_and_samtoolsoutput.txt" >> "${sampleNameID}.${perBase}.coveragePerBase.txt"

		#remove phiX
		grep -v "NC_001422.1" "${sampleNameID}.${perBase}.coveragePerBase.txt" > "${sampleNameID}.${perBase}.coveragePerBase.txt.tmp"
		mv "${sampleNameID}.${perBase}.coveragePerBase.txt.tmp" "${sampleNameID}.${perBase}.coveragePerBase.txt"
		echo "phiX is removed for ${sampleNameID}.${perBase} perBase" 
		rsync -a "${sampleNameID}.${perBase}.coveragePerBase.txt" "${projectResultsDir}/coverage/CoveragePerBase/${Gender,,}" 

	done
else
	echo "There are no CoveragePerBase calculations for this bedfile: ${bedfile}"

fi
## Per target bed files
if [ -d "${coveragePerTargetDir}/${bedfile}" ]
then
	for i in $(ls -d "${coveragePerTargetDir}/${bedfile}"/*)
	do
		perTarget=$(basename "${i}")
		perTargetDir=$(echo $(dirname "${i}")"/${perTarget}/human_g1k_v37/")

		java -Xmx7g -XX:ParallelGCThreads=1 -jar "${EBROOTGATK}/${gatkJar}" \
		-R "${indexFile}" \
		-T DepthOfCoverage \
		-o "${sampleNameID}.${perTarget}.coveragePerTarget" \
		-I "${dedupBam}" \
                -mmq 20 \
		--omitDepthOutputAtEachBase \
		-L "${perTargetDir}/${perTarget}.interval_list"

		awk -v OFS='\t' '{print $1,$3}' "${sampleNameID}.${perTarget}.coveragePerTarget.sample_interval_summary" | sed '1d' > "${sampleNameID}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp.tmp"
		sort -V "${sampleNameID}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp.tmp" > "${sampleNameID}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp"
		perl -p -e 's|-|\^|' "${perTargetDir}/${perTarget}.genesOnly" > "${sampleNameID}.${perTarget}.coveragePerTarget.genesOnly.tmp"
		paste "${sampleNameID}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp" "${sampleNameID}.${perTarget}.coveragePerTarget.genesOnly.tmp" > "${sampleNameID}.${perTarget}.coveragePerTarget_inclGenes.txt"
		##Paste command produces ^M character

		perl -p -i -e "s/\r//g" "${sampleNameID}.${perTarget}.coveragePerTarget_inclGenes.txt"

		awk 'BEGIN { OFS = "\t" } ; {split($1,a,":"); print a[1],a[2],$2,$3}' "${sampleNameID}.${perTarget}.coveragePerTarget_inclGenes.txt" | awk 'BEGIN { OFS = "\t" } ; {split($0,a,"-"); print a[1],a[2]}' > "${sampleNameID}.${perTarget}.coveragePerTarget_inclGenes_splitted.txt"
		perl -pi -e 's|\^|-|' "${sampleNameID}.${perTarget}.coveragePerTarget_inclGenes_splitted.txt"
		if [ -d "${sampleNameID}.${perTarget}.coveragePerTarget.txt" ]
		then
			rm "${sampleNameID}.${perTarget}.coveragePerTarget.txt"
		fi 

		echo -e "Index\tChr\tChr Position Start\tChr Position End\tAverage Counts\tDescription\tReference Length\tCDS\tContig" > "${sampleNameID}.${perTarget}.coveragePerTarget.txt"
		awk '{OFS="\t"} {len=$3-$2} {print NR,$0,len,"CDS","1"}' "${sampleNameID}.${perTarget}.coveragePerTarget_inclGenes_splitted.txt" >> "${sampleNameID}.${perTarget}.coveragePerTarget.txt"

		#Remove phiX
		grep -v "NC_001422.1" "${sampleNameID}.${perTarget}.coveragePerTarget.txt" > "${sampleNameID}.${perTarget}.coveragePerTarget.txt.tmp"
		mv "${sampleNameID}.${perTarget}.coveragePerTarget.txt.tmp" "${sampleNameID}.${perTarget}.coveragePerTarget.txt"
		echo "phiX is removed for ${sampleNameID}.${perTarget} perTarget"
		 

		if [ "${perTarget}" ==  "${bedfile}" ]
		then
			totalcount=$(($(cat "${sampleNameID}.${perTarget}.coveragePerTarget.txt" | wc -l)-1))
			count=0
			count=$(awk 'BEGIN{sum=0}{if($5 < 20){sum++}} END {print sum}' "${sampleNameID}.${perTarget}.coveragePerTarget.txt")

			if [ $count == 0 ]
			then
				percentage=0

			else
				percentage=$(echo $((count*100/totalcount)))
				if [ ${percentage%%.*} -gt 10 ]
				then
					echo "${sampleNameID}: percentage $percentage ($count/$totalcount) is more than 10 procent, skipped"
					echo "${sampleNameID}: percentage $percentage ($count/$totalcount) is more than 10 procent, skipped" >> "${projectResultsDir}/coverage/${sampleNameID}.rejected"
				else
					rsync -a "${sampleNameID}.${perTarget}.coveragePerTarget.txt" "${projectResultsDir}/coverage/CoveragePerBase/${Gender,,}"
				fi
			fi
		fi
	done
else
	echo "There are no CoveragePerTarget calculations for this bedfile: ${bedfile}"
fi

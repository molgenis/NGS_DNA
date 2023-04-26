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
#string samplePrefix
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
		-o "${samplePrefix}.${perBase}.coveragePerBase" \
		--omitLocusTable \
		-mmq 20 \
		--includeRefNSites \
		-I "${dedupBam}" \
		-L "${perBaseDir}/${perBase}.interval_list"

		sed '1d' "${samplePrefix}.${perBase}.coveragePerBase" > "${samplePrefix}.${perBase}.coveragePerBase_withoutHeader"
		sort -V "${samplePrefix}.${perBase}.coveragePerBase_withoutHeader" > "${samplePrefix}.${perBase}.coveragePerBase_withoutHeader.sorted"
		tail -n+87 "${perBaseDir}/${perBase}.uniq.per_base.interval_list" > "${samplePrefix}.${perBase}.uniqperbase_chompedHeaders.txt"
		paste "${samplePrefix}.${perBase}.uniqperbase_chompedHeaders.txt" "${samplePrefix}.${perBase}.coveragePerBase_withoutHeader.sorted" > "${samplePrefix}.${perBase}.combined_bedfile_and_samtoolsoutput.txt"

		##Paste command produces ^M character
		perl -p -i -e "s/\r//g" "${samplePrefix}.${perBase}.combined_bedfile_and_samtoolsoutput.txt"

		echo -e "Index\tChr\tChr Position Start\tDescription\tMin Counts\tCDS\tContig" > "${samplePrefix}.${perBase}.coveragePerBase.txt"

		awk -v OFS='\t' '{print NR,$1,$2,$5,$7,"CDS","1"}' "${samplePrefix}.${perBase}.combined_bedfile_and_samtoolsoutput.txt" >> "${samplePrefix}.${perBase}.coveragePerBase.txt"

		#remove phiX
		grep -v "NC_001422.1" "${samplePrefix}.${perBase}.coveragePerBase.txt" > "${samplePrefix}.${perBase}.coveragePerBase.txt.tmp"
		mv "${samplePrefix}.${perBase}.coveragePerBase.txt.tmp" "${samplePrefix}.${perBase}.coveragePerBase.txt"
		echo "phiX is removed for ${samplePrefix}.${perBase} perBase" 
		rsync -a "${samplePrefix}.${perBase}.coveragePerBase.txt" "${projectResultsDir}/coverage/CoveragePerBase/${Gender,,}/" 

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
		-o "${samplePrefix}.${perTarget}.coveragePerTarget" \
		-I "${dedupBam}" \
		-mmq 20 \
		--omitDepthOutputAtEachBase \
		-L "${perTargetDir}/${perTarget}.interval_list"

		awk -v OFS='\t' '{print $1,$3}' "${samplePrefix}.${perTarget}.coveragePerTarget.sample_interval_summary" | sed '1d' > "${samplePrefix}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp.tmp"
		sort -V "${samplePrefix}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp.tmp" > "${samplePrefix}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp"
		perl -p -e 's|-|\^|' "${perTargetDir}/${perTarget}.genesOnly" > "${samplePrefix}.${perTarget}.coveragePerTarget.genesOnly.tmp"
		paste "${samplePrefix}.${perTarget}.coveragePerTarget.coveragePerTarget.txt.tmp" "${samplePrefix}.${perTarget}.coveragePerTarget.genesOnly.tmp" > "${samplePrefix}.${perTarget}.coveragePerTarget_inclGenes.txt"
		##Paste command produces ^M character

		perl -p -i -e "s/\r//g" "${samplePrefix}.${perTarget}.coveragePerTarget_inclGenes.txt"

		awk 'BEGIN { OFS = "\t" } ; {split($1,a,":"); print a[1],a[2],$2,$3}' "${samplePrefix}.${perTarget}.coveragePerTarget_inclGenes.txt" | awk 'BEGIN { OFS = "\t" } ; {split($0,a,"-"); print a[1],a[2]}' > "${samplePrefix}.${perTarget}.coveragePerTarget_inclGenes_splitted.txt"
		perl -pi -e 's|\^|-|' "${samplePrefix}.${perTarget}.coveragePerTarget_inclGenes_splitted.txt"
		if [ -d "${samplePrefix}.${perTarget}.coveragePerTarget.txt" ]
		then
			rm "${samplePrefix}.${perTarget}.coveragePerTarget.txt"
		fi 

		echo -e "Index\tChr\tChr Position Start\tChr Position End\tAverage Counts\tDescription\tReference Length\tCDS\tContig" > "${samplePrefix}.${perTarget}.coveragePerTarget.txt"
		awk '{OFS="\t"} {len=$3-$2} {print NR,$0,len,"CDS","1"}' "${samplePrefix}.${perTarget}.coveragePerTarget_inclGenes_splitted.txt" >> "${samplePrefix}.${perTarget}.coveragePerTarget.txt"

		#Remove phiX
		grep -v "NC_001422.1" "${samplePrefix}.${perTarget}.coveragePerTarget.txt" > "${samplePrefix}.${perTarget}.coveragePerTarget.txt.tmp"
		mv "${samplePrefix}.${perTarget}.coveragePerTarget.txt.tmp" "${samplePrefix}.${perTarget}.coveragePerTarget.txt"
		echo "phiX is removed for ${samplePrefix}.${perTarget} perTarget"
		
		if [ "${perTarget}" ==  "${bedfile}" ]
		then
			totalcount=$(($(cat "${samplePrefix}.${perTarget}.coveragePerTarget.txt" | wc -l)-1))
			count=0
			count=$(awk 'BEGIN{sum=0}{if($5 < 20){sum++}} END {print sum}' "${samplePrefix}.${perTarget}.coveragePerTarget.txt")

			if [ $count == 0 ]
			then
				percentage=0
			else
				percentage=$(echo $((count*100/totalcount)))
				if [ ${percentage%%.*} -gt 10 ]
				then
					echo "WARNING: ${samplePrefix}: percentage $percentage ($count/$totalcount) is more than 10 procent"
					echo "WARNING: ${samplePrefix}: percentage $percentage ($count/$totalcount) is more than 10 procent" >> "${projectResultsDir}/coverage/${externalSampleID}.rejected"
				fi
			fi
		fi
		rsync -a "${samplePrefix}.${perTarget}.coveragePerTarget.txt" "${projectResultsDir}/coverage/CoveragePerTarget/${Gender,,}/"
	done
else
	echo "There are no CoveragePerTarget calculations for this bedfile: ${bedfile}"
fi

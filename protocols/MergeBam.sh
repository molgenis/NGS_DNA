#Parameter mapping
#string tmpName


#string sampleMergedBam
#string sampleMergedBai
#string sampleMergedBamIdx
#string tempDir
#list inputMergeBam,inputMergeBamIdx
#string tmpDataDir
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string sambambaVersion

#Function to check if array contains value
array_contains () {
	local array="$1[@]"
	local seeking="${2}"
	local in=1
	for element in "${!array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
			in=0
			break
		fi
	done
	return "${in}"
}

makeTmpDir "${sampleMergedBam}"
tmpSampleMergedBam="${MC_tmpFile}"

makeTmpDir "${sampleMergedBamIdx}"
tmpSampleMergedBamIdx="${MC_tmpFile}"

module load "${sambambaVersion}"
module list

#Create string with input BAM files for Picard
#This check needs to be performed because Compute generates duplicate values in array
INPUTS=()
INPUTBAMS=()

for bamFile in "${inputMergeBam[@]}"
do
	array_contains INPUTS "${bamFile}" || INPUTS+=("${bamFile}")    # If bamFile does not exist in array add it
	array_contains INPUTBAMS "${bamFile}" || INPUTBAMS+=("${bamFile}")    # If bamFile does not exist in array add it
done

if [ ${#INPUTS[@]} == 1 ]
then

	ln -sf "$(basename "${inputMergeBam[0]}")" "${sampleMergedBam}"

	#indexing because there is no index file coming out of the sorting step
	printf '%s' "indexing..."
	sambamba index \
	"${sampleMergedBam}" \
	"${inputMergeBamIdx[0]}"

	printf '%s' "..finished\n"

	ln -sf "$(basename "${inputMergeBamIdx[0]}")" "${sampleMergedBai}"

	echo "nothing to merge because there is only one sample"

else
	sambamba merge \
	"${tmpSampleMergedBam}" \
	"${INPUTS[@]}"

	mv "${tmpSampleMergedBam}" "${sampleMergedBam}"
	echo "moved ${tmpSampleMergedBam} ${sampleMergedBam}"

	mv "${tmpSampleMergedBamIdx}" "${sampleMergedBamIdx}"
	echo "moved ${tmpSampleMergedBamIdx} ${sampleMergedBamIdx}"

fi


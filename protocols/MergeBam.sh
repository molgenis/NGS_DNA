set -o pipefail
#Parameter mapping
#string tmpName
#string samtoolsVersion
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

#This check needs to be performed because Compute generates duplicate values in array
INPUTS=()
INPUTBAMS=()

for bamFile in "${inputMergeBam[@]}"
do
	array_contains INPUTS "${bamFile}" || INPUTS+=("${bamFile}")    # If bamFile does not exist in array add it
	array_contains INPUTBAMS "${bamFile}" || INPUTBAMS+=("${bamFile}")    # If bamFile does not exist in array add it
done

if [[ "${#INPUTS[@]}" -eq '1' ]]
then
	ln -sf "$(basename "${inputMergeBam[0]}")" "${sampleMergedBam}"

	#indexing because there is no index file coming out of the sorting step
	printf "indexing..."
	sambamba index \
	"${sampleMergedBam}" \
	"${inputMergeBamIdx[0]}"

	printf "..finished\n"

	echo "ln -sf basename ${inputMergeBamIdx[0]} ${sampleMergedBai}"
	ln -sf "$(basename "${inputMergeBamIdx[0]}")" "${sampleMergedBai}"

	echo "nothing to merge because there is only one sample"

else
	sambamba merge \
	"${tmpSampleMergedBam}" \
	"${INPUTS[@]}"

	mv -v "${tmpSampleMergedBam}" "${sampleMergedBam}"
	mv -v "${tmpSampleMergedBamIdx}" "${sampleMergedBamIdx}"

fi

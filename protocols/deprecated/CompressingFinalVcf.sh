#list externalSampleID
#string tmpName
#string htsLibVersion


#string logsDir 
#string groupname
#string project
#string finalVcf
#string intermediateDir

#Function to check if array contains value
array_contains () {
	local _array
	_array="$1[@]"
	local seeking="${2}"
	local in=1
	for element in "${!_array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
			in=0
			break
		fi
	done
	return "${in}"
}

#Load Tabix module
module load "${htsLibVersion}"
module list

INPUTS=()
for SampleID in "${externalSampleID}"
do
	array_contains INPUTS "$SampleID" || INPUTS+=("$SampleID")    # If bamFile does not exist in array add it
done

for i in ${INPUTS[@]}
do
	if [ -f "${i}" ]
        then
		printf "bgzipping ${i}"
		bgzip -c "${i}" > "${i}.gz"
		printf "..done\ntabix-ing ${i}.gz .."
		tabix -p vcf "${i}.gz"
		printf "..done\n"
		echo "done"
        fi
done

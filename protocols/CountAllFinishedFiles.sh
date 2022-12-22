#string tmpName
#string projectJobsDir
#string intermediateDir
#string project
#string logsDir 
#string groupname

cd "${projectJobsDir}" || exit

#shellcheck disable=SC2035
countShScripts=$(find *.sh ! -name '*Manta*.sh' ! -name 'sXX*.sh'  ! -name 'Autotest_0.sh' | wc -l)
#shellcheck disable=SC2035
countFinishedFiles=$(find *.sh.finished ! -name '*Manta*.sh.finished' ! -name 'sXX*.sh.finished' | wc -l)

#remove 3, because there are 3 sh scripts that cannot have (already) a finished file, those are the following:
#
## CountAllFinishedFiles.sh, CopyToResultsDir.sh and submit.sh

countShScripts=$((${countShScripts}-3))

rm -f "${projectJobsDir}/${taskId}_INCORRECT"

if [[ "${countShScripts}" -eq "${countFinishedFiles}" ]]
then	
	echo "all files are finished" > "${projectJobsDir}/${taskId}_CORRECT"
else
	echo "These files are not finished: " > "${projectJobsDir}/${taskId}_INCORRECT"
	#shellcheck disable=SC2035
	mapfile -t getShs < <(find *.sh)
	for getSh in "${getShs[@]}"
	do
		if [[ ! -f "${getSh}.finished" ]]
		then
			echo "${getSh}" >> "${projectJobsDir}/${taskId}_INCORRECT"
		fi
	done
	trap - EXIT
	exit 0

fi


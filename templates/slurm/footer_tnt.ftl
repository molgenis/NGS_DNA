<#noparse>
mydate_finished=$(date +"%Y-%m-%dT%H:%M:%S+0200")


if CURLRESPONSE="$(curl -s -S -H "Content-Type: application/json" -X POST -d "{"username"="${USERNAME}", "password"="${PASSWORD}"}" "https://${MOLGENISSERVER}/api/v1/login" 2>&1)" 
then
	TOKEN=$(echo "${CURLRESPONSE}" | awk 'BEGIN {FS=":"} $1 ~ /token/ {print $2}' | awk 'BEGIN {FS="\""}{print $2}')
	echo "INFO: login to T&T server ${MOLGENISSERVER} successful and retrieved token"
	
	if CURLRESPONSE="$(curl -s -S -H "Content-Type:application/json" -H "x-molgenis-token:${TOKEN}" -X PUT -d "finished" https://${MOLGENISSERVER}/api/v1/status_jobs/${MC_project}_${MC_jobName}/status 2>&1)"	
	then
		echo "INFO: T&T set status to 'finished'."
	else
		echo "ERROR: ${CURLRESPONSE:-unknown error}."
	fi
	if CURLRESPONSE="$(curl -s -S -H "Content-Type:application/json" -H "x-molgenis-token:${TOKEN}" -X PUT -d "'${mydate_finished}'" https://${MOLGENISSERVER}/api/v1/status_jobs/${MC_project}_${MC_jobName}/finished_date 2>&1)"
	then
		echo "INFO: T&T set finished date to '${mydate_finished}'."
	else
		echo "ERROR: ${CURLRESPONSE:-unknown error}."
	fi
else
	echo "ERROR: ${CURLRESPONSE:-unknown error}."
fi

#
# Cleanup 
#
if [ -d ${MC_tmpFolder:-} ]; then
	echo -n "INFO: Removing MC_tmpFolder ${MC_tmpFolder} ..."
	rm -rf ${MC_tmpFolder}
	echo 'done.'
fi

tS=${SECONDS:-0}
tM=$((SECONDS / 60 ))
tH=$((SECONDS / 3600))
echo "On $(date +"%Y-%m-%d %T") ${MC_jobScript} finished successfully after ${tM} minutes." >> molgenis.bookkeeping.log
printf '%s:\t%d seconds\t%d minutes\t%d hours\n' "${MC_jobScript}" "${tS}" "${tM}" "${tH}" >> molgenis.bookkeeping.walltime

#
# Request OS to flush IO buffers/caches to disk.
#
sync

#
# Signal success.
#
mv "${MC_jobScript}.started" "${MC_jobScript}.finished"
if [[ "${lastStep:-false}" == 'true' && -n "${workflowControlFileBase:-}" ]]
then
	rm -f "${workflowControlFileBase}.failed"
	printf 'finished: %s\n' "$(date +%FT%T%z)" >> "${workflowControlFileBase}.totalRuntime"
	printf '%s\n' "Creating ${workflowControlFileBase}.finished ..."
	#
	# NO MORE LOGGING AFTER THIS LINE: finished == finished!
	#
	if [[ -f "${workflowControlFileBase}.started" ]]
	then
		mv "${workflowControlFileBase}".{started,finished}
	else
		touch "${workflowControlFileBase}.finished"
	fi
fi
</#noparse>
trap - EXIT
exit 0


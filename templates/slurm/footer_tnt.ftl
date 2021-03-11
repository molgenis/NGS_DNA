mydate_finished=$(date +"%Y-%m-%dT%H:%M:%S+0200")

<#noparse>
if curl -f -s -H "Content-Type: application/json" -X POST -d "{"username"="${USERNAME}", "password"="${PASSWORD}"}" https://${MOLGENISSERVER}/api/v1/login
then
	if CURLRESPONSE=$(curl -H "Content-Type: application/json" -X POST -d "{"username"="${USERNAME}", "password"="${PASSWORD}"}" https://${MOLGENISSERVER}/api/v1/login)
	then
		TOKEN=$(echo "${CURLRESPONSE}" | awk 'BEGIN {FS=":"} $1 ~ /token/ {print $2}' | awk 'BEGIN {FS="\""}{print $2}')
		if curl -f -s -H "Content-Type:application/json" -H "x-molgenis-token:${TOKEN}" -X PUT -d "finished" https://${MOLGENISSERVER}/api/v1/status_jobs/</#noparse>${project}_${taskId}/status
		then
			echo "set"
		else
			echo "not set"
		fi

		<#noparse>
		sleep 1
		if curl -f -s -H "Content-Type:application/json" -H "x-molgenis-token:${TOKEN}" -X PUT -d "'${mydate_finished}'" https://${MOLGENISSERVER}/api/v1/status_jobs/</#noparse>${project}_${taskId}/finished_date
		then
			echo "set"
		else
			echo "not set"
		fi
	else
		echo "FATAL: ${CURLRESPONSE}."
		exit 1
	fi
fi
<#noparse>

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

mv "${MC_jobScript}.started" "${MC_jobScript}.finished"


</#noparse>
step=$(echo "${taskId}" | awk -F'_' '{print $1"_"$2}')

trap - EXIT
exit 0


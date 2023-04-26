#string intermediateDir
#string project
#string logsDir
#string runid

set -e
set -u
set -o pipefail

# Touch log file for GAP_Automated for starting copying project data to PRM

if [[ -f "${logsDir}//${project}/${runid}.pipeline.started" ]]
then
	mv "${logsDir}/${project}/${runid}.pipeline".{started,finished}
else
	touch "${logsDir}/${project}/${runid}.pipeline.finished"
fi

rm -f "${logsDir}/${project}/${runid}.pipeline.failed"

echo "${logsDir}/${project}/${runid}.pipeline.finished is created"

touch pipeline.finished
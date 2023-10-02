#string intermediateDir
#string project
#string logsDir
#string runid
#string projectJobsDir
#string projectResultsDir

set -e
set -u
set -o pipefail

# copy samplesheet to results directory
rsync -av "${projectJobsDir}/${project}.csv" "${projectResultsDir}"
mkdir -p "${projectResultsDir}/concordanceCheckSnps/"
rsync -av "${intermediateDir}/"*".concordanceCheckCalls.vcf" "${projectResultsDir}/concordanceCheckSnps/"

if [[ -f "${logsDir}//${project}/${runid}.pipeline.started" ]]
then
	mv "${logsDir}/${project}/${runid}.pipeline".{started,finished}
else
	touch "${logsDir}/${project}/${runid}.pipeline.finished"
fi

rm -f "${logsDir}/${project}/${runid}.pipeline.failed"

echo "${logsDir}/${project}/${runid}.pipeline.finished is created"

touch 'pipeline.finished'
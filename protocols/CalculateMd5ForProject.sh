#string tmpName
#string	project
#string logsDir 
#string groupname
#string intermediateDir
#string hashdeepVersion
#string projectDir
#string runid

module load ${hashdeepVersion}

thisFolder=$(pwd)
cd "${projectDir}/"
cd ..

echo "starting to checksum"
md5deep -r -j0 -o f -l "results/" > "${intermediateDir}/results.md5"
echo "finished, moving ${intermediateDir}/${runid}.results.md5 to final location => ${projectDir}/results.md5"
mv "${intermediateDir}/results.md5" "${projectDir}/results.md5"

cd "${thisFolder}"

echo "pipeline is finished"

#touch ${logsDir}/${project}/${project}.pipeline.finished
if [ -f "${logsDir}/${project}/${runid}.pipeline.started" ]
then
        mv "${logsDir}/${project}/${runid}.pipeline".{started,finished}
else
        touch "${logsDir}/${project}/${runid}.pipeline.finished"
fi
rm -f "${logsDir}/${project}/${runid}.pipeline.failed"
echo "${logsDir}/${project}/${runid}.pipeline.finished is created"


touch pipeline.finished

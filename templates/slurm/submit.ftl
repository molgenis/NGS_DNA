<#noparse>#!/bin/bash

#
# Bash sanity.
#
set -e
set -u

#
##
### Functions.
##
#

stop () {
	
	while (IFS=':' read -r col1 col2); do
		scancel -Q $col2
	done <$1

}

#
##
### Main.
##
#

#
# First cd to the directory with the *.sh and *.finished scripts
#
MOLGENIS_scriptsDir=$( cd -P "$( dirname "$0" )" && pwd )
echo "cd $MOLGENIS_scriptsDir"
cd $MOLGENIS_scriptsDir
runnumber=$(basename $(dirname $MOLGENIS_scriptsDir))
echo "$runnumber"

cd ../..
project=$(pwd)
projectName=$(basename $project)
cd $MOLGENIS_scriptsDir

HOST=$(hostname)
myTmp=""
myGroup=""
if [ "${HOST}" == "zinc-finger.gcc.rug.nl" ]
then
	myTmp="tmp05"
	myGroup="umcg-gd"
elif [ "${HOST}" == "leucine-zipper.gcc.rug.nl" ]
then
	myTmp="tmp06"
	myGroup="umcg-gd"
elif [ "${HOST}" == "calculon" ]
then
	myTmp="tmp04"
		myGroup="umcg-gaf"
elif [[ "${HOST}" == *"molgenis"* ]]
then
	myTmp="tmpTest01"
		myGroup="umcg-testgroup"
else
	echo "unknown server, please contact helpdesk.gcc.groningen@gmail.com"
	exit 0
fi

failedFile="/groups/${myGroup}/${myTmp}/logs/${projectName}.pipeline.failed"

if [ -f ${failedFile} ]
then
	rm ${failedFile}
	if [ -f ${failedFile}.mailed ]
	then
		rm ${failedFile}.mailed
	fi
fi

if [ -f submitted_jobIDs.txt ]
then
	stop submitted_jobIDs.txt
fi

</#noparse>

touch molgenis.submit.started

# Use this to indicate that we skip a step
skip(){
echo "0: Skipped --- TASK '$1' --- ON $(date +"%Y-%m-%d %T")" >> molgenis.skipped.log
}

<#foreach t in tasks>
#
##${t.name}
#

# Skip this step if step finished already successfully
if [ -f ${t.name}.sh.finished ]; then
	skip ${t.name}.sh
	echo "Skipped ${t.name}.sh"
else
	# Build dependency string
	dependenciesExist=false
	dependencies="--dependency=afterok"
	<#foreach d in t.previousTasks>
		if [[ -n "$${d}" ]]; then
			dependenciesExist=true
			dependencies+=":$${d}"
		fi
	</#foreach>
	if ! $dependenciesExist; then
		dependencies=''
	fi
	output=$(sbatch $dependencies ${t.name}.sh)
	id=${t.name}
	${t.name}=<#noparse>${output##"Submitted batch job "}</#noparse> 
	echo "$id:$${t.name}"
	echo "$id:$${t.name}" >> submitted_jobIDs.txt
fi



</#foreach>
chmod g+w submitted_jobIDs.txt
touch molgenis.submit.finished

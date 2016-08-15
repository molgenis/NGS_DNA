#!/bin/bash
#SBATCH --job-name=${project}_${taskId}
#SBATCH --output=${taskId}.out
#SBATCH --error=${taskId}.err
#SBATCH --partition=${queue}
#SBATCH --time=${walltime}
#SBATCH --cpus-per-task ${ppn}
#SBATCH --mem ${mem}
#SBATCH --nodes ${nodes}
#SBATCH --open-mode=append
#SBATCH --export=NONE
#SBATCH --get-user-env=L

ENVIRONMENT_DIR="."
set -e
set -u
#-%j

function errorExitandCleanUp()
{
        echo "TRAPPED"
	failedFile="/groups/${groupname}/${tmpName}/logs/${project}.pipeline.failed"
	printf "${taskId}\n" > <#noparse>${failedFile}</#noparse>
	if [ -f ${taskId}.err ]
	then
		printf "Last 50 lines of ${taskId}.err :\n" >> <#noparse>${failedFile}</#noparse>
		tail -50 ${taskId}.err >> <#noparse>${failedFile}</#noparse>
		printf "\nLast 50 lines of ${taskId}.out: \n" >> <#noparse>${failedFile}</#noparse>
		tail -50 ${taskId}.out >> <#noparse>${failedFile}</#noparse>
	fi
	rm -rf /groups/${groupname}/${tmpName}/tmp/${project}/*/tmp_${taskId}*
}

declare MC_tmpFolder="tmpFolder"
declare MC_tmpFile="tmpFile"

function makeTmpDir {
	# call with file/dirname and use the declared/new MC_tmpFile as a temporarly dir/file
        # This can run on a interactive terminal with which
	myMD5=$(md5sum $0 2>/dev/null || md5sum $(which $0))
	myMD5=$(echo $myMD5| cut -d' ' -f1,1)
	MC_tmpSubFolder="tmp_${taskId}_$myMD5"
        if [[ -d $1 ]]
        then
            	dir="$1"
            	base=""
        else
        	base=$(basename $1)
        	dir=$(dirname $1)
        fi
       	MC_tmpFolder="$dir/$MC_tmpSubFolder/"
       	MC_tmpFile="$MC_tmpFolder/$base"

        echo "[INFO $0::makeTmpDir] dir='$dir';base='$base';MC_tmpFile='$MC_tmpFile'"

        mkdir -p $MC_tmpFolder
}

trap "errorExitandCleanUp" HUP INT QUIT TERM EXIT ERR

# For bookkeeping how long your task takes
MOLGENIS_START=$(date +%s)

touch ${taskId}.sh.started
if [ -f Timesheet.txt ]
then
DATE=`date +%Y-%m-%d`
	printf "\n\n${DATE}" >> Timesheet.txt
fi
SECONDS=0

#!/bin/bash
#SBATCH --job-name=${project}_${taskId}
#SBATCH --output=${taskId}.out
#SBATCH --error=${taskId}.err
#SBATCH --time=${walltime}
#SBATCH --cpus-per-task ${ppn}
#SBATCH --mem ${mem}
#SBATCH --open-mode=append
#SBATCH --export=NONE
#SBATCH --get-user-env=60L

set -e
set -u

ENVIRONMENT_DIR='.'

#
# Variables declared in MOLGENIS Compute headers/footers always start with a MC_ prefix.
#
declare MC_jobScript="${taskId}.sh"
declare MC_jobScriptSTDERR="${taskId}.err"
declare MC_jobScriptSTDOUT="${taskId}.out"

#
# File to indicate failure of a complete workflow in
# a central location for log files for all projects.
#

logsDirectory="${logsDir}/${project}/"

<#noparse>
runName=$(basename $(cd ../ && pwd ))
MC_failedFile="${logsDirectory}/${runName}.pipeline.failed"

declare MC_singleSeperatorLine=$(head -c 120 /dev/zero | tr '\0' '-')
declare MC_doubleSeperatorLine=$(head -c 120 /dev/zero | tr '\0' '=')
declare MC_tmpFolder='tmpFolder'
declare MC_tmpFile='tmpFile'

#
##
### Header functions.
##
#

function errorExitAndCleanUp() {
	local signal=${1}
	local problematicLine=${2}
	local exitStatus=${3:-$?}
	local executionHost=${SLURMD_NODENAME:-$(hostname)}
	local errorMessage="FATAL: Trapped ${signal} signal in ${MC_jobScript} running on ${executionHost}. Exit status code was ${exitStatus}."
	if [ $signal == 'ERR' ]; then
		local errorMessage="FATAL: Trapped ${signal} signal on line ${problematicLine} in ${MC_jobScript} running on ${executionHost}. Exit status code was ${exitStatus}."
	fi
	local errorMessage=${4:-"${errorMessage}"} # Optionally use custom error message as third argument.
	local format='INFO: Last 50 lines or less of %s:\n'
	echo "${errorMessage}"
	echo "${MC_doubleSeperatorLine}"                > ${MC_failedFile}
	echo "${errorMessage}"                         >> ${MC_failedFile}

	if [ -f "${MC_jobScriptSTDERR}" ]; then
		echo "${MC_singleSeperatorLine}"           >> ${MC_failedFile}
		printf "${format}" "${MC_jobScriptSTDERR}" >> ${MC_failedFile}
		echo "${MC_singleSeperatorLine}"           >> ${MC_failedFile}
		tail -50 "${MC_jobScriptSTDERR}"           >> ${MC_failedFile}
		
	fi
	if [ -f "${MC_jobScriptSTDOUT}" ]; then
		echo "${MC_singleSeperatorLine}"           >> ${MC_failedFile}
		printf "${format}" "${MC_jobScriptSTDOUT}" >> ${MC_failedFile}
		echo "${MC_singleSeperatorLine}"           >> ${MC_failedFile}
		tail -50 "${MC_jobScriptSTDOUT}"           >> ${MC_failedFile}
	fi
	echo "${MC_doubleSeperatorLine}"               >> ${MC_failedFile}
	if [ -d ${MC_tmpFolder} ]; then
		rm -rf ${MC_tmpFolder}
	fi
}

#
# Create tmp dir per script/job.
# To be called with with either a file or folder as first and only argument.
# Defines two globally set variables:
#  1. MC_tmpFolder: a tmp dir for this job/script. When function is called multiple times MC_tmpFolder will always be the same.
#  2. MC_tmpFile:   when the first argument was a folder, MC_tmpFile == MC_tmpFolder
#                   when the first argument was a file, MC_tmpFile will be a path to a tmp file inside MC_tmpFolder.
#
function makeTmpDir {
	local originalPath=$1
	local myMD5=$(md5sum ${MC_jobScript})
	myMD5=${myMD5%% *} # remove everything after the first space character to keep only the MD5 checksum itself.
	local tmpSubFolder="tmp_${MC_jobScript}_${myMD5}"
	local dir
	local base
	if [[ -d "${originalPath}" ]]; then
		dir="${originalPath}"
		base=''
	else
		base=$(basename "${originalPath}")
		dir=$(dirname "${originalPath}")
	fi
	MC_tmpFolder="${dir}/${tmpSubFolder}/"
	MC_tmpFile="$MC_tmpFolder/${base}"
	echo "DEBUG ${MC_jobScript}::makeTmpDir: dir='${dir}';base='${base}';MC_tmpFile='${MC_tmpFile}'"
	mkdir -p ${MC_tmpFolder}
}

trap 'errorExitAndCleanUp HUP  NA $?' HUP
trap 'errorExitAndCleanUp INT  NA $?' INT
trap 'errorExitAndCleanUp QUIT NA $?' QUIT
trap 'errorExitAndCleanUp TERM NA $?' TERM
trap 'errorExitAndCleanUp EXIT NA $?' EXIT
trap 'errorExitAndCleanUp ERR  $LINENO $?' ERR

touch ${MC_jobScript}.started

</#noparse>

#
# When dealing with timing / synchronization issues of large parallel file systems,
# you can uncomment the sleep statement below to allow for flushing of IO buffers/caches.
#
#sleep 10

#
## Header for 'local' backend
#

#highly recommended to use
#set -e # exit if any subcommand or pipeline returns a non-zero status
#set -u # exit if any uninitialised variable is used

# Set location of *.env and *.log files
ENVIRONMENT_DIR="."
set -e
set -u
#-%j

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

# For bookkeeping how long your task takes
MOLGENIS_START=$(date +%s)

touch ${taskId}.sh.started

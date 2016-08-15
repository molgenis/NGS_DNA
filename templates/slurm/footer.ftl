touch ${taskId}.sh.finished

echo "On $(date +"%Y-%m-%d %T"), after $(( ($(date +%s) - $MOLGENIS_START) / 60 )) minutes, task ${taskId} finished successfully" >> molgenis.bookkeeping.log
<#noparse>
if [ -d ${MC_tmpFolder:-} ];
        then
	echo "removed tmpFolder $MC_tmpFolder"
        rm -r $MC_tmpFolder
fi

tS=$SECONDS
tM=$((SECONDS / 60 ))
tH=$((SECONDS / 3600))
printf "</#noparse>${taskId}<#noparse>:\t${tS} seconds\t${tM} minutes\t${tH} hours \n" >> Timesheet.txt
trap - EXIT
exit 0
</#noparse>

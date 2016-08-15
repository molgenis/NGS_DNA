touch ${taskId}.sh.finished

echo "On $(date +"%Y-%m-%d %T"), after $(( ($(date +%s) - $MOLGENIS_START) / 60 )) minutes, task ${taskId} finished successfully" >> molgenis.bookkeeping.log

if [ -d <#noparse>${MC_tmpFolder:-}</#noparse> ];
        then
	echo "removed tmpFolder $MC_tmpFolder"
        rm -r $MC_tmpFolder
fi

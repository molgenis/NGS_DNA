set -e 
set -u

function preparePipeline(){

	local _workflowType="${1}"

	local _projectName="PlatinumSubset${_workflowType}"
	rm -f ${tmpfolder}/logs/${_projectName}/run01.pipeline.finished
	echo "TMPFOLDER: ${tmpfolder}"
	pwd
	rsync -r --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials ${pipelinefolder}/test/rawdata/MY_TEST_BAM_PROJECT${_workflowType} ${tmpfolder}/rawdata/ngs/

	if [ -d "${tmpfolder}/generatedscripts/${_projectName}" ] 
	then
		rm -rf "${tmpfolder}/generatedscripts/${_projectName}/"
	fi

	if [ -d "${tmpfolder}/projects/${_projectName}" ]
	then
		rm -rf "${tmpfolder}/projects/${_projectName}/"
	fi

	if [ -d "${tmpfolder}/tmp/${_projectName}" ]
	then
		rm -rf "${tmpfolder}/tmp/${_projectName}/"
	fi
	mkdir "${tmpfolder}/generatedscripts/${_projectName}/"

	cp "${pipelinefolder}/templates/generate_template.sh" "${tmpfolder}/generatedscripts/${_projectName}/generate_template.sh"
	fgrep "computeVersion," "${pipelinefolder}/parameters.csv" > "${tmpfolder}/generatedscripts/${_projectName}/mcVersion.txt"

##############
	perl -pi -e "s|module load NGS_DNA|module load NGS_DNA/betaAutotest|" ${tmpfolder}/generatedscripts/${_projectName}/generate_template.sh
	###### Load a version of molgenis compute
sudo -u umcg-envsync bash -l << EOF

id
export SOURCE_HPC_ENV="True"
. ~/.bashrc
module load depad-utils
#module list 
hpc-environment-sync.bash -m NGS_DNA/betaAutotest
exit

EOF

	module load NGS_DNA/betaAutotest

	if [ "${_workflowType}" == "ExternalSamples" ]
	then
		perl -pi -e 's|create_in-house_ngs_projects_workflow.csv|create_external_samples_ngs_projects_workflow.csv|' ${tmpfolder}/generatedscripts/${_projectName}/generate_template.sh
	fi

	## Grep used version of molgenis compute out of the parameters file

	cp "${pipelinefolder}/test/${_projectName}.csv" "${tmpfolder}/generatedscripts/${_projectName}/"
	perl -pi -e "s|/groups/umcg-atd/tmp03/|${tmpfolder}/|g" "${tmpfolder}/generatedscripts/${_projectName}/${_projectName}.csv"
	cd "${tmpfolder}/generatedscripts/${_projectName}/"
	perl -pi -e 's|workflow=\${EBROOTNGS_DNA}/workflow.csv|workflow=\${EBROOTNGS_DNA}/test_workflow.csv|' "${tmpfolder}/generatedscripts/${_projectName}/generate_template.sh"
	sh generate_template.sh
	cd scripts

	sh submit.sh

	cd "${tmpfolder}/projects/${_projectName}/run01/jobs/"
	perl -pi -e 's|--runDir ${tmpMantaDir}|--region 2:100000-500000 \\\n --runDir ${tmpMantaDir}|' s*_Manta_0.sh
	perl -pi -e 's|module load \"test\"||' s*_Manta_0.sh

	for i in $(ls s*_Manta_1.sh); do touch $i.finished ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done

	## "gender cannot be determined for Male NA12891"
	for i in $(ls s*_GenderCheck_1.sh); do touch $i.finished ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done
	for i in $(ls s*_GenderCalculate_1.sh); do touch $i.finished ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done
	printf "This is a male\n" > "${tmpfolder}//tmp//${_projectName}/run01//PlatinumSample_NA12891.chosenSex.txt"
	printf "Male\n" >> "${tmpfolder}/tmp//${_projectName}/run01//PlatinumSample_NA12891.chosenSex.txt"
	perl -pi -e 's|--time=16:00:00|--time=05:59:00|' *.sh
	perl -pi -e 's|--time=23:59:00|--time=05:59:00|' *.sh
	if [ "${_workflowType}" == "ExternalSamples" ]
	then
		cd "${tmpfolder}/projects/${_projectName}/run01/jobs/"
		perl -pi -e 's|ExternalSamples|InhouseSamples|g' s01*_0.sh
		var=$(diff s01*_0.sh ${tmpfolder}/projects/PlatinumSubsetInhouseSamples/run01/jobs/s01*_0.sh | wc -l)
		if [[ "${var}" == 0 ]]
		then
			echo "ExternalSamples is correct"
		else
			echo "PlatinumSubsetExternalSamples is not creating the same scripts as the PlatinumSubsetInhouseSamples (compared s01*_1.sh "
			exit 1
		fi
	else

		sh submit.sh --qos=dev
	fi


}
function checkIfFinished(){
	local _projectName="PlatinumSubset${1}"
	count=0
	minutes=0
	while [ ! -f "${tmpfolder}/projects/${_projectName}/run01/jobs/Autotest_0.sh.finished" ]
	do

		echo "${_projectName} is not finished in $minutes minutes, sleeping for 2 minutes"
		sleep 120
		minutes=$((minutes+2))

		count=$((count+2))
		if [ "${count}" -eq 60 ]
		then
			echo "the test was not finished within 60 minutes, let's kill it"
			echo -e "\n"
			for i in $(ls "${tmpfolder}/projects/${_projectName}/run01/jobs/"*.sh)
			do
				if [ ! -f "${i}.finished" ]
				then
					echo "$(basename ${i}) is not finished"
				fi
			done
			exit 1
		fi
	done
	echo ""
	echo "${_projectName} test succeeded!"
	echo ""
}
tmpdirectory="tmp03"
groupName="umcg-atd"

if [ $(hostname) == "calculon" ]
then
	tmpdirectory="tmp04"
fi

pipelinefolder="/apps/software/NGS_DNA/betaAutotest/"
tmpfolder="/groups/${groupName}/${tmpdirectory}"

if [ -d "${pipelinefolder}" ]
then
	rm -rf "${pipelinefolder}"
	echo "removed ${pipelinefolder}"
	mkdir "${pipelinefolder}"
fi
cd "${pipelinefolder}"

echo "pr number: $1"

PULLREQUEST="${1}"
#NGS_DNA_VERSION=NGS_DNA/3.5.2

git clone https://github.com/molgenis/NGS_DNA.git
cd NGS_DNA
git fetch --tags --progress https://github.com/molgenis/NGS_DNA/ +refs/pull/*:refs/remotes/origin/pr/*
COMMIT=$(git rev-parse refs/remotes/origin/pr/$PULLREQUEST/merge^{commit})
echo "checkout commit: COMMIT"
git checkout -f ${COMMIT}

mv * ../
cd ..
rm -rf NGS_DNA/

### create testworkflow
cp workflow.csv test_workflow.csv
tail -1 workflow.csv | perl -p -e 's|,|\t|g' | awk '{print "Autotest,test/protocols/Autotest.sh,"$1}' >> test_workflow.csv

cp test/results/*_True.final.vcf.gz /home/umcg-molgenis/NGS_DNA/
cp test/results/*_True.txt /home/umcg-molgenis/NGS_DNA/
cp test/results/PlatinumSample_NA12878.Manta.diploidSV_True.vcf.gz /home/umcg-molgenis/NGS_DNA/
cp test/results/PlatinumSample_NA12878.GAVIN.rlv.vcf /home/umcg-molgenis/NGS_DNA/

preparePipeline "InhouseSamples"
preparePipeline "ExternalSamples"

checkIfFinished "InhouseSamples"

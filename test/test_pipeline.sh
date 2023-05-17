set -e 
set -u

function preparePipeline(){

	local _workflowType="${1}"

	local _projectName="PlatinumSubset${_workflowType}"
	local _generatedScriptsFolder="${tmpfolder}/generatedscripts/NGS_DNA/${_projectName}/"
	rm -f ${tmpfolder}/logs/${_projectName}/run01.pipeline.finished
	echo "TMPFOLDER: ${tmpfolder}"
	pwd
	rsync -r --verbose --recursive --links --no-perms --times --group --no-owner --devices --specials ${pipelinefolder}/test/rawdata/MY_TEST_BAM_PROJECT${_workflowType} ${tmpfolder}/rawdata/ngs/

	rm -rf ${tmpfolder}/{generatedscripts,projects,tmp}/NGS_DNA/${_projectName}/
	mkdir "${_generatedScriptsFolder}"

	cp ${pipelinefolder}/templates/generate_template.sh "${_generatedScriptsFolder}/generate_template.sh"
	fgrep "computeVersion," "${pipelinefolder}/parameters.csv" > "${_generatedScriptsFolder}/mcVersion.txt"

##############
	perl -p -e "s|if module list|module load NGS_DNA/betaAutotest\nif module list|" "${_generatedScriptsFolder}/generate_template.sh" > "${_generatedScriptsFolder}/generate_template.sh.tmp"
	mv -v "${_generatedScriptsFolder}/generate_template.sh"{.tmp,}
	###### Load a version of molgenis compute


	if [[ "${_workflowType}" == "ExternalSamples" ]]
	then
		perl -p -e 's|create_in-house_ngs_projects_workflow.csv|create_external_samples_ngs_projects_workflow.csv|' "${_generatedScriptsFolder}/generate_template.sh" > "${_generatedScriptsFolder}/generate_template.sh.tmp"
		mv "${_generatedScriptsFolder}/generate_template.sh"{.tmp,}
	fi

	## Grep used version of molgenis compute out of the parameters file

	cp "${pipelinefolder}/test/${_projectName}.csv" "${_generatedScriptsFolder}"
	perl -p -e "s|/groups/umcg-atd/tmp09/|${tmpfolder}/|g" "${_generatedScriptsFolder}/${_projectName}.csv" > "${_generatedScriptsFolder}/${_projectName}.csv.tmp"

	mv -v "${_generatedScriptsFolder}/${_projectName}.csv"{.tmp,} 

	cd "${_generatedScriptsFolder}"

	perl -pi -e 's|workflow=\${EBROOTNGS_DNA}/workflow.csv|workflow=\${EBROOTNGS_DNA}/test_workflow.csv|' "${_generatedScriptsFolder}/generate_template.sh"
	bash generate_template.sh
	cd scripts

	bash submit.sh
	sleep 15
	if [[ "${_workflowType}" == "InhouseSamples" ]]
	then	
		if [[ ! -f "${_generatedScriptsFolder}/scripts/CheckRawDataOnTmp_0.sh.finished" ]]
		then
			echo "${_generatedScriptsFolder}/scripts/CheckRawDataOnTmp_0.sh.finished is not there, EXIT!"
			exit 1
		else 
			sleep 20
		fi
	fi

	jobsFolder="${tmpfolder}/projects/NGS_DNA/${_projectName}/run01/jobs/"
	cd "${jobsFolder}"
	perl -pi -e 's|--runDir ${tmpMantaDir}|--region 2:100000-500000 \\\n --runDir ${tmpMantaDir}|' s*_Manta_0.sh
	perl -pi -e 's|module load \"test\"||' s*_Manta_0.sh

	for i in s*_Manta_1.sh; do touch "${i}.finished" ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done

	## "gender cannot be determined for Male NA12891"
	for i in s*_GenderCheck_1.sh; do touch "${i}.finished" ; touch "${i%.*}.env"; chmod 755 "${i%.*}.env" ;done
	for i in $(ls s*_GenderCalculate_1.sh); do touch "${i}.finished" ; touch "${i%.*}.env"; chmod 755 "${i%.*}.env" ;done
	printf "This is a male\nMale\n" > "${tmpfolder}/tmp/NGS_DNA/${_projectName}/run01//PlatinumSample_NA12891.chosenSex.txt"
	perl -pi -e 's|--time=16:00:00|--time=05:59:00|' *.sh
	perl -pi -e 's|--time=23:59:00|--time=05:59:00|' *.sh
	if [[ "${_workflowType}" == "ExternalSamples" ]]
	then
		cd "${tmpfolder}/projects/NGS_DNA/${_projectName}/run01/jobs/"
		perl -pi -e 's|ExternalSamples|InhouseSamples|g' "s01"*"_0.sh"
		var=$(diff s01*_0.sh "${jobsFolder}/s01"*"_0.sh" | wc -l)
		if [[ "${var}" -eq '0' ]]
		then
			echo "ExternalSamples is correct"
		else
			echo "PlatinumSubsetExternalSamples is not creating the same scripts as the PlatinumSubsetInhouseSamples (compared s01*_1.sh "
			exit 1
		fi
	else

		bash submit.sh
	fi
	

}
function checkIfFinished(){
	local _projectName="PlatinumSubset${1}"
	count=0
	minutes=0
	while [[ ! -f "${tmpfolder}/projects/NGS_DNA/${_projectName}/run01/jobs/Autotest_0.sh.finished" ]]
	do
		echo "${_projectName} is not finished in ${minutes} minutes, sleeping for 2 minutes"
		sleep 120
		minutes=$((minutes+2))

		count=$((count+2))
		if [[ "${count}" -eq '60' ]]
		then
			echo "the test was not finished within 60 minutes, let's kill it"
			echo -e "\n"
			for i in "${tmpfolder}/projects/NGS_DNA/${_projectName}/run01/jobs/"*".sh"
			do
				if [[ ! -f "${i}.finished" ]]
				then
					echo "$(basename $i) is not finished"
				fi
			done
			exit 1
		fi
	done

	echo -e "\n${_projectName} test succeeded!\n"

}
tmpdirectory='tmp09'
groupName='umcg-atd'

pipelinefolder="/groups/${groupName}/${tmpdirectory}/tmp/NGS_DNA/betaAutotest/"
tmpfolder="/groups/${groupName}/${tmpdirectory}"

rm -vrf "${pipelinefolder}"
mkdir -p "${pipelinefolder}"

cd "${pipelinefolder}"

echo "pr number: ${1}"

PULLREQUEST="${1}"

git clone 'https://github.com/molgenis/NGS_DNA.git'
cd NGS_DNA
git fetch --tags --progress 'https://github.com/molgenis/NGS_DNA/' +refs/pull/*:refs/remotes/origin/pr/*
COMMIT=$(git rev-parse refs/remotes/origin/pr/${PULLREQUEST}/merge^{commit})
echo "checkout commit: COMMIT"
git checkout -f "${COMMIT}"

mv * ../
cd ..
rm -rf 'NGS_DNA'

### create testworkflow
cp 'workflow.csv' 'test_workflow.csv'
tail -1 'workflow.csv' | perl -p -e 's|,|\t|g' | awk '{print "Autotest,test/protocols/Autotest.sh,"$1}' >> 'test_workflow.csv'

rsync -v 'test/results/'*'_True.final.vcf.gz' '/home/umcg-molgenis/NGS_DNA/'
rsync -v 'test/results/'*'_True.txt' '/home/umcg-molgenis/NGS_DNA/'
rsync -v 'test/results/PlatinumSample_NA12878.Manta.diploidSV_True.vcf.gz' '/home/umcg-molgenis/NGS_DNA/'
rsync -v 'test/results/PlatinumSample_NA12878.GAVIN.rlv.vcf.gz' '/home/umcg-molgenis/NGS_DNA/'

preparePipeline 'InhouseSamples'
preparePipeline 'ExternalSamples'

checkIfFinished 'InhouseSamples'

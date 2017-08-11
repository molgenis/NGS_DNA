set -e 
set -u

function preparePipeline(){

	local _workflowType="${1}"
	local _projectName="PlatinumSubset${_workflowType}"
	rm -f ${workfolder}/logs/${_projectName}/run01.pipeline.finished

	cp -r ${workfolder}/tmp/NGS_DNA/test/rawdata/MY_TEST_BAM_PROJECT${_workflowType} ${workfolder}/rawdata/ngs/

	if [ -d ${workfolder}/generatedscripts/${_projectName} ] 
	then
		rm -rf ${workfolder}/generatedscripts/${_projectName}/
	fi

	if [ -d ${workfolder}/projects/${_projectName} ] 
	then
		rm -rf ${workfolder}/projects/${_projectName}/
	fi

	if [ -d ${workfolder}/tmp/${_projectName} ] 
	then
		rm -rf ${workfolder}/tmp/${_projectName}/
	fi
	mkdir ${workfolder}/generatedscripts/${_projectName}/

	cp ${workfolder}/tmp/NGS_DNA/generate_template.sh ${workfolder}/generatedscripts/${_projectName}/generate_template.sh
	fgrep "computeVersion," ${workfolder}/tmp/NGS_DNA/parameters.csv > ${workfolder}/generatedscripts/${_projectName}/mcVersion.txt

	module load ${NGS_DNA_VERSION}
	EBROOTNGS_DNA="${workfolder}/tmp/NGS_DNA/"

	if [ "${_workflowType}" == "ExternalSamples" ]
	then
		perl -pi -e 's|create_in-house_ngs_projects_workflow.csv|create_external_samples_ngs_projects_workflow.csv|' ${workfolder}/generatedscripts/${_projectName}/generate_template.sh
	fi

	## Grep used version of molgenis compute out of the parameters file
	perl -pi -e "s|module load ${NGS_DNA_VERSION}|EBROOTNGS_DNA=${workfolder}/tmp/NGS_DNA/|" ${workfolder}/generatedscripts/${_projectName}/generate_template.sh
	perl -pi -e 's|ngsversion=.*|ngsversion="test";\\|' ${workfolder}/generatedscripts/${_projectName}/generate_template.sh
	perl -pi -e 's|sh \$EBROOTMOLGENISMINCOMPUTE/molgenis_compute.sh|module load Molgenis-Compute/dummy\nsh \$EBROOTMOLGENISMINCOMPUTE/molgenis_compute.sh|' ${workfolder}/generatedscripts/${_projectName}/generate_template.sh
	perl -pi -e "s|module load Molgenis-Compute/dummy|module load Molgenis-Compute/\$mcVersion|" ${workfolder}/generatedscripts/${_projectName}/generate_template.sh

	perl -pi -e 's|workflow=\${EBROOTNGS_DNA}/workflow.csv|workflow=\${EBROOTNGS_DNA}/test_workflow.csv|' ${workfolder}/generatedscripts/${_projectName}/generate_template.sh
	cp ${workfolder}/tmp/NGS_DNA/test/${_projectName}.csv ${workfolder}/generatedscripts/${_projectName}/

	cd ${workfolder}/generatedscripts/${_projectName}/

	sh generate_template.sh
	cd scripts
	###### Load a version of molgenis compute
	perl -pi -e "s|module load test| module load ${NGS_DNA_VERSION}|" *.sh
	######
	perl -pi -e "s|/apps/software/${NGS_DNA_VERSION}/|${workfolder}/tmp/NGS_DNA/|g" *.sh

	sh submit.sh

	cd ${workfolder}/projects/${_projectName}/run01/jobs/

	perl -pi -e 's|--runDir ${tmpMantaDir}|--region 2:100000-500000 \\\n --runDir ${tmpMantaDir}|' s*_Manta_0.sh

	for i in $(ls s*_CoverageCalculations*.sh); do touch $i.finished ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done
	for i in $(ls s*_Manta_1.sh); do touch $i.finished ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done

	## "gender cannot be determined for Male NA12891"
	for i in $(ls s*_GenderCheck_1.sh); do touch $i.finished ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done
	for i in $(ls s*_GenderCalculate_1.sh); do touch $i.finished ; touch ${i%.*}.env; chmod 755 ${i%.*}.env ;done
	printf "This is a male\n" > ${workfolder}//tmp//${_projectName}/run01//PlatinumSample_NA12891.chosenSex.txt
	printf "Male\n" >> ${workfolder}/tmp//${_projectName}/run01//PlatinumSample_NA12891.chosenSex.txt
	perl -pi -e "s|module load test|EBROOTNGS_DNA=${workfolder}/tmp/NGS_DNA/|" s*_QCStats_*.sh
	perl -pi -e "s|module load test|EBROOTNGS_DNA=${workfolder}/tmp/NGS_DNA/|" s*_DecisionTree_*.sh
	perl -pi -e 's|module load test|#|' s*_QCReport_0.sh
	perl -pi -e 's|--time=16:00:00|--time=05:59:00|' *.sh
	perl -pi -e 's|--time=23:59:00|--time=05:59:00|' *.sh

	sh submit.sh --qos=dev



}
function checkIfFinished(){
	local _projectName="PlatinumSubset${1}"
	count=0
	minutes=0
	while [ ! -f ${workfolder}/projects/${_projectName}/run01/jobs/Autotest_0.sh.finished ]
	do

		echo "${_projectName} is not finished in $minutes minutes, sleeping for 1 minute"
		sleep 60
		minutes=$((minutes+1))

		count=$((count+1))
		if [ $count -eq 60 ]
		then
			echo "the test was not finished within 1 hour, let's kill it"
			echo -e "\n"
			for i in $(ls ${workfolder}/projects/${_projectName}/run01/jobs/*.sh)
			do
				if [ ! -f $i.finished ]
				then
					echo "$(basename $i) is not finished"
				fi
			done
			exit 1
		fi
	done
	echo ""
	echo "${_projectName} test succeeded!"
	echo ""
}

groupName="umcg-atd"
workfolder="/groups/${groupName}/tmp03/"

cd ${workfolder}/tmp/
if [ -d ${workfolder}/tmp/NGS_DNA ]
then
	rm -rf ${workfolder}/tmp/NGS_DNA/
	echo "removed ${workfolder}/tmp/NGS_DNA/"
fi

echo "pr number: $1"

PULLREQUEST=$1
NGS_DNA_VERSION=NGS_DNA/3.4.2

git clone https://github.com/molgenis/NGS_DNA.git
cd ${workfolder}/tmp/NGS_DNA

git fetch --tags --progress https://github.com/molgenis/NGS_DNA/ +refs/pull/*:refs/remotes/origin/pr/*
COMMIT=$(git rev-parse refs/remotes/origin/pr/$PULLREQUEST/merge^{commit})
echo "checkout commit: COMMIT"
git checkout -f ${COMMIT}

### create testworkflow
cd ${workfolder}/tmp/NGS_DNA/
cp ${workfolder}/tmp/NGS_DNA/workflow.csv ${workfolder}/tmp/NGS_DNA/test_workflow.csv 
tail -1 ${workfolder}/tmp/NGS_DNA/workflow.csv | perl -p -e 's|,|\t|g' | awk '{print "Autotest,test/protocols/Autotest.sh,"$1}' >> ${workfolder}/tmp/NGS_DNA/test_workflow.csv

cp ${workfolder}/tmp/NGS_DNA/test/results/PlatinumSubset_True.final.vcf.gz /home/umcg-molgenis/NGS_DNA/PlatinumSubset_True.final.vcf.gz
cp ${workfolder}/tmp/NGS_DNA/test/results/PlatinumSample_NA12878_True.final.vcf.gz /home/umcg-molgenis/NGS_DNA/PlatinumSample_NA12878_True.final.vcf.gz
cp ${workfolder}/tmp/NGS_DNA/test/results/PlatinumSample_NA12891_True.final.vcf.gz /home/umcg-molgenis/NGS_DNA/PlatinumSample_NA12891_True.final.vcf.gz

preparePipeline "InhouseSamples"
preparePipeline "ExternalSamples"

checkIfFinished "InhouseSamples"
checkIfFinished "ExternalSamples"

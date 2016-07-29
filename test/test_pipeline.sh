workfolder="/groups/umcg-gaf/tmp04/"

cd ${workfolder}/tmp/
if [ -d ${workfolder}/tmp/NGS_DNA ]
then
	rm -rf ${workfolder}/tmp/NGS_DNA/
fi

git clone https://github.com/roankanninga/NGS_DNA.git
cd ${workfolder}/tmp/NGS_DNA

if [ ! -d ${workfolder}/rawdata/ngs/MY_TEST_BAM_PROJECT/ ] 
then
	cp -r test/rawdata/MY_TEST_BAM_PROJECT/ ${workfolder}/rawdata/ngs/
fi

if [ -d ${workfolder}/generatedscripts/PlatinumSubset ] 
then
	rm -rf ${workfolder}/generatedscripts/PlatinumSubset/
fi

mkdir ${workfolder}/generatedscripts/PlatinumSubset/

rm -f ${workfolder}/logs/PlatinumSubset.pipeline.finished
cp test/results/PlatinumSample.final.vcf /home/umcg-molgenis/PlatinumSample.final.vcf
cp test/autotest_generate_template.sh ${workfolder}/generatedscripts/PlatinumSubset/generate_template.sh
cp test/PlatinumSubset.csv ${workfolder}/generatedscripts/PlatinumSubset/

cd ${workfolder}/generatedscripts/PlatinumSubset/

sh generate_template.sh 

cd scripts

sh submit.sh

cd ${workfolder}/projects/PlatinumSubset/run01/jobs/

sh submit.sh

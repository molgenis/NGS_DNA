#  Installing NGS_DNA pipeline

This is the Quickstart tutorial. When there are any problems, please first go to the detailed [install page](ngs-install), or when there are problems [running the pipeline](ngs-run)

We first have to load EasyBuild, this can be done using the following command:
```bash
module load EasyBuild
eb NGS_DNA-3.5.2.eb --robot -–robot-paths=${pathToMYeasybuild}/easybuild-easyconfigs/easybuild/easyconfigs/:
```
**_Note:_** Some software cannot be downloaded automagically due to for example licensing or technical issues and the build will fail initially.
In these cases you will have to manually download and copy the sources to
${HPC_ENV_PREFIX}/sources/[a-z]/NameOfTheSoftwarePackage/. For further details, please check [install page](ngs-install)

Run the script NGS_resources to install the required resources and create the directory structure. You can download the scripts [here](attachments/scripts.tar.gz).
```bash
bash makestructure.sh
bash NGS_DNA-resources.sh
```
**_Note:_** Sometimes the GATK ftp server can be down/instable, try it a couple of times


#  Preparing and running NGS_DNA pipeline

```bash
scp –r 198210_SEQ_RUNTEST_FLOWCELLXX username@yourcluster:${root}/groups/$groupname/${tmpDir}/rawdata/ngs/

mkdir ${root}/groups/$groupname/${tmpDir}/generatedscripts/TestRun

scp –r TestRun username@yourcluster:/groups/$groupname/${tmpDir}/generatedscripts/

module load NGS_DNA
cd ${root}/groups/$groupname/${tmpDir}/generatedscripts/TestRun
cp $EBROOTNGS_DNA/generate_template.sh .
bash generate_template.sh
cd scripts
```
**_Note:_** If you want to run the pipeline locally, you should change the backend in the CreateInhouseProjects.sh script (this can be done almost at the end of the script where you have something like:
sh ${EBROOTMOLGENISMINCOMPUTE}/molgenis_compute.sh
<u>search for –b slurm and change it into –b localhost</u>
```bash
bash submit.sh
```

navigate to jobs folder (this will be outputted at the step before this one).
```bash
bash submit.sh
```

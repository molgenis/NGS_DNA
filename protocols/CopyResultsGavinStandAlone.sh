#MOLGENIS walltime=01:59:00 mem=1gb
#string tmpName
#Parameter mapping
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string project
#string logsDir
#string groupname
#string tmpDataDir
#string inputVcf

cp ${intermediateDir}/*.GAVIN.rlv.vcf ${tmpDataDir}/GavinStandAlone/output/
echo "copied ${intermediateDir}/*.GAVIN.rlv.vcf ${tmpDataDir}/GavinStandAlone/output/"

name=$(basename ${inputVcf})
mv ${tmpDataDir}/GavinStandAlone/input/${name}.{started,finished}
mv ${tmpDataDir}/GavinStandAlone/input/processing/${name} ${tmpDataDir}/GavinStandAlone/input/done/

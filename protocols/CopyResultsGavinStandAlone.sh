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

cp "${intermediateDir}/"*.GAVIN.rlv.vcf "${tmpDataDir}/GavinStandAlone/output/"
echo "copied ${intermediateDir}/*.GAVIN.rlv.vcf ${tmpDataDir}/GavinStandAlone/output/"

name=$(basename "${inputVcf}")
choppedOfName=${name%.splitted.vcf}.vcf
mv "${tmpDataDir}/GavinStandAlone/input/${choppedOfName}".{started,finished}
mv "${tmpDataDir}/GavinStandAlone/input/processing/${choppedOfName}" "${tmpDataDir}/GavinStandAlone/input/done/"


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

cp ${intermediateDir}/*.GAVIN.rlv.vcf ${tmpDataDir}/GavinSA/output/
echo "copied ${intermediateDir}/*.GAVIN.rlv.vcf ${tmpDataDir}/GavinSA/output/"

name=$(basename "${inputVcf}" ".vcf")
mv ${tmpDataDir}/GavinSA/input/${name}.{started,finished}


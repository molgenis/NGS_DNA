#string tmpName
#Parameter mapping


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
choppedOfName=${name%.stripped.vcf}.vcf
mv -v "${tmpDataDir}/GavinStandAlone/input/${choppedOfName}".{started,finished}
mv -v "${tmpDataDir}/GavinStandAlone/input/processing/${choppedOfName}" "${tmpDataDir}/GavinStandAlone/input/done/"

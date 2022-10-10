genderFile=$1
workingDir=$2

. ${workingDir}/config.cfg

mkdir -p ${workingDir}/Gender/

maleSamples=${workingDir}/Gender/Male_samples.txt
femaleSamples=${workingDir}/Gender/Female_samples.txt
maleSampleNames=${workingDir}/Gender/Male_sampleNames.txt
femaleSampleNames=${workingDir}/Gender/Female_sampleNames.txt
mybamsDir=${workingDir}/${bamsFolder}

rm -f ${maleSamples}
rm -f ${FemaleSamples}
rm -f ${maleSampleNames}
rm -f ${femaleSampleNames}

awk -v var="${workingDir}" 'BEGIN{FS=","}{print $1 > var"/Gender/"$2"_samples.txt"
}' ${genderFile}

ARR=()

if [ -f ${maleSamples} ]
then
	while read line 
	do
		ls -1 ${mybamsDir}/*${line}*.bam* >> ${maleSampleNames}
	done<${maleSamples}
	
	mkdir -p ${workingDir}/Gender/Male/${bamsFolder}
	
	cd ${workingDir}/Gender/Male/${bamsFolder}
	
	while read line
	do
		ln -sf $line $(basename $line) 
	done<${maleSampleNames}
		
	ARR+=("Male")
else
	echo "there are no male samples"
fi
if [ -f ${femaleSamples} ]
then
	while read line 
	do
		ls -1 ${mybamsDir}/*${line}*.bam* >> ${femaleSampleNames}
	done<${femaleSamples}
	
	mkdir -p ${workingDir}/Gender/Female/${bamsFolder}
	
	
	cd ${workingDir}/Gender/Female/${bamsFolder}
	
	while read line
	do
		ln -sf $line $(basename $line)
	done<${femaleSampleNames}
	ARR+=("Female")
else
	echo "there are no female samples"
fi

	
for gender in ${ARR[@]}
do
	echo "executing Convading_MakeControlGroup_Gender.sh for ${gender}"
	sh ${EBROOTNGS_DNA}/protocols/Convading_XHMM_MakeControlGroup/Convading_MakeControlGroup_Gender.sh ${gender} ${workingDir}
done

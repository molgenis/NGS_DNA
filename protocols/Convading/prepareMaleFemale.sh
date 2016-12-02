genderFile=$1
workingDir=$2

##. ${workingDir}/config.cfg

mkdir -p ${workingDir}/Gender/

maleSamples=${workingDir}/Gender/Male_samples.txt
femaleSamples=${workingDir}/Gender/Female_samples.txt
maleSampleNames=${workingDir}/Gender/Male_sampleNames.txt
femaleSampleNames=${workingDir}/Gender/Female_sampleNames.txt
mybamsDir=${workingDir}/mybams

mybams="mybams"

rm -f ${maleSamples}
rm -f ${FemaleSamples}
rm -f ${maleSampleNames}
rm -f ${femaleSampleNames}

perl -p -e 's|Man|Male|g' ${genderFile} >> ${genderFile}.translated
perl -p -e 's|Vrouw|Female|g' ${genderFile} >> ${genderFile}.translated

awk -v var="${workingDir}" 'BEGIN{FS=","}{print $1 > var"/Gender/"$2"_samples.txt"
}' ${genderFile}.translated

while read line 
do
	ls -1 ${mybamsDir}/*${line}*.bam* >> ${maleSampleNames}
done<${maleSamples}

while read line 
do
	ls -1 ${mybamsDir}/*${line}*.bam* >> ${femaleSampleNames}
done<${femaleSamples}

mkdir -p ${workingDir}/Gender/Male/${mybams}
mkdir -p ${workingDir}/Gender/Female/${mybams}

cd ${workingDir}/Gender/Male/${mybams}

while read line
do
	ln -sf $line $(basename $line) 
done<${maleSampleNames}

cd ${workingDir}/Gender/Female/${mybams}

while read line
do
	ln -sf $line $(basename $line)
done<${femaleSampleNames}

for gender in Male Female
do
	echo "executing Convading_MakeControlGroup_Gender.sh for ${gender}"
	sh ${workingDir}/Convading_MakeControlGroup_Gender.sh ${gender} ${workingDir}
done

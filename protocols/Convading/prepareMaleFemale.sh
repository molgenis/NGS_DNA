Gender/Man_sampleNames.txt
manSamples=/groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/Gender/Man_samples.txt
vrouwSamples=/groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/Gender/Vrouw_samples.txt
manSampleNames=/groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/Gender/Man_sampleNames.txt
vrouwSampleNames=/groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/Gender/Vrouw_sampleNames.txt
mybamsDir=/groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/mybams/


rm -f ${manSamples}
rm -f ${vrouwSamples}
rm -f ${manSampleNames}
rm -f ${vrouwSampleNames}

awk 'BEGIN{FS=","} 
	{print $1 >> "/groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/Gender/"$2"_samples.txt"
}' /groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/UMCG_IDs_Convading_Initial_Gender.txt


while read line 
do
	ls -1 ${mybamsDir}/*${line}*.bam* >> ${manSampleNames}
done<${manSamples}

while read line 
do
	ls -1 ${mybamsDir}/*${line}*.bam* >> ${vrouwSampleNames}
done<${vrouwSamples}

cd /groups/umcg-gaf/tmp04/umcg-rkanninga/Convading_Initial/Gender/

while read line
do
	ln -sf $line Male/$(basename $line) 
done<${manSampleNames}

while read line
do
	ln -sf $line Female/$(basename $line)
done<${vrouwSampleNames}


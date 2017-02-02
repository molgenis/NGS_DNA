#MOLGENIS walltime=16:00:00 mem=30gb ppn=21
#string tmpName
#string project
#string logsDir
#string groupname
#string indexFile
#string intermediateDir
#string mantaVersion
#string dedupBam
#string mantaDir
#string mantaVersion
#string pythonVersion
#string capturingKit
#string capturedBed
#string bedToolsVersion
#string htsLibVersion

makeTmpDir ${mantaDir}
tmpMantaDir=${MC_tmpFile}


bedfile=$(basename $capturingKit)

if [[ "${bedfile}" == *"CARDIO_v"* || "${bedfile}" == *"DER_v"* || "${bedfile}" == *"DYS_v"* || "${bedfile}" == *"EPI_v"* \
|| "${bedfile}" == *"FH_v"*|| "${bedfile}" == *"LEVER_v"* || "${bedfile}" == *"MYO_v"* || "${bedfile}" == *"NEURO_v"* \
|| "${bedfile}" == *"ONCO_v"* || "${bedfile}" == *"PCS_v"* || "${bedfile}" == *"TID_v"* ]]
then
    	echo "Manta is skipped"
else
	module load ${mantaVersion}
	module load ${pythonVersion}
	module load ${bedToolsVersion}
	module load ${htsLibVersion}
	rm -rf ${mantaDir}

	mkdir ${mantaDir}

	python ${EBROOTMANTA}/bin/configManta.py \
	--bam ${dedupBam} \
	--referenceFasta ${indexFile} \
	--exome \
	--runDir ${tmpMantaDir}

	python ${tmpMantaDir}/runWorkflow.py -m local -j 20

	mv ${tmpMantaDir}/* ${mantaDir} 

	if [[ $capturingKit != *"wgs"* ]]
	then
		mkdir ${mantaDir}/results/variants/real/	
		
		#
		## 3 files has been created by Manta, they all should be limited only on the bedfile
		#
	
		bedtools intersect -a ${mantaDir}/results/variants/candidateSmallIndels.vcf.gz -b ${capturedBed} >> ${mantaDir}/results/variants/real/candidateSmallIndels.vcf
		if [ -f ${mantaDir}/results/variants/real/candidateSmallIndels.vcf ]
                then
			bgzip -c ${mantaDir}/results/variants/real/candidateSmallIndels.vcf > ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz
			printf "..done\ntabix-ing ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz .."
			tabix -p vcf ${mantaDir}/results/variants/real/candidateSmallIndels.vcf.gz
			printf "${mantaDir}/results/variants/real/candidateSmallIndels.vcf ..done\n"
		else
			echo "no candidateSmallIndels's left after filtering with the bedfile"
                        touch ${mantaDir}/results/variants/real/NO_candidateSmallIndels 
		fi
		bedtools intersect -a ${mantaDir}/results/variants/candidateSV.vcf.gz -b ${capturedBed} >> ${mantaDir}/results/variants/real/candidateSV.vcf
		if [ -f ${mantaDir}/results/variants/real/candidateSV.vcf ]
		then
			bgzip -c ${mantaDir}/results/variants/real/candidateSV.vcf > ${mantaDir}/results/variants/real/candidateSV.vcf.gz
        		printf "..done\ntabix-ing ${mantaDir}/results/variants/real/candidateSV.vcf.gz .."
       			tabix -p vcf ${mantaDir}/results/variants/real/candidateSV.vcf.gz
			printf "${mantaDir}/results/variants/real/candidateSV.vcf ..done\n"
		else
			echo "no candidateSV's left after filtering with the bedfile"
			touch ${mantaDir}/results/variants/real/NO_candidateSV
		fi
		
		bedtools intersect -a ${mantaDir}/results/variants/diploidSV.vcf.gz -b ${capturedBed} >> ${mantaDir}/results/variants/real/diploidSV.vcf
		if [ -f ${mantaDir}/results/variants/real/diploidSV.vcf ]
                then
			bgzip -c ${mantaDir}/results/variants/real/diploidSV.vcf > ${mantaDir}/results/variants/real/diploidSV.vcf.gz
		        printf "..done\ntabix-ing ${mantaDir}/results/variants/real/diploidSV.vcf.gz .."
		        tabix -p vcf ${mantaDir}/results/variants/real/diploidSV.vcf.gz
			printf "${mantaDir}/results/variants/real/diploidSV.vcf ..done\n"
		else
			echo "no diploidSV's left after filtering with the bedfile"
                        touch ${mantaDir}/results/variants/real/NO_diploidSV
		fi
	fi
	
fi



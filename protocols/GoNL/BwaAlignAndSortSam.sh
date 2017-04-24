#MOLGENIS walltime=23:59:00 nodes=1 ppn=8 mem=30gb

set -o pipefail

#Parameter mapping
#string tmpName
#string tempDir
#string stage
#string checkStage
#string seqType
#string bwaVersion
#string indexFile
#string bwaAlignCores
#string peEnd1BarcodeTrimmedPhiXRecodedFqGz
#string peEnd2BarcodeTrimmedPhiXRecodedFqGz
#string srBarcodeFqGz
#string alignedSam
#string lane
#string externalSampleID
#string tmpDataDir
#string project
#string logsDir 
#string groupname
#string intermediateDir
#string filePrefix
#string alignedSortedBam
#string picardVersion
#string picardJar
#string cutadaptVersion
#string Library

makeTmpDir ${alignedSam} 
tmpAlignedSam=${MC_tmpFile}

makeTmpDir ${alignedSortedBam}
tmpAlignedSortedBam=${MC_tmpFile}

#Load module BWA
${stage} ${bwaVersion}
${stage} ${picardVersion}
${checkStage}
READGROUPLINE=""
if [ "${Library}" == "" ]
then
	READGROUPLINE="@RG\tID:${filePrefix}_${lane}\tPL:illumina\tLB:${filePrefix}\tSM:${externalSampleID}"
else
	READGROUPLINE="@RG\tID:${filePrefix}_${lane}\tPL:illumina\tLB:${Library}\tSM:${externalSampleID}"	
fi
rm -f  ${tmpAlignedSam}

mkfifo -m 0644 ${tmpAlignedSam}

#If paired-end use two fq files as input, else only one
if [ "${seqType}" == "PE" ]
then
	#Run BWA for paired-end

    	bwa mem \
    	-M \
    	-R $READGROUPLINE \
    	-t ${bwaAlignCores} \
    	${indexFile} \
    	${peEnd1BarcodeTrimmedPhiXRecodedFqGz} \
    	${peEnd2BarcodeTrimmedPhiXRecodedFqGz} \
    	> ${tmpAlignedSam} &

	java -Djava.io.tmpdir=${tempDir} -Xmx29G -XX:ParallelGCThreads=4 -jar ${EBROOTPICARD}/${picardJar} SortSam \
        INPUT=${tmpAlignedSam} \
        OUTPUT=${tmpAlignedSortedBam}  \
        SORT_ORDER=coordinate \
        CREATE_INDEX=true 

	mv ${tmpAlignedSortedBam} ${alignedSortedBam}

else
    	#Run BWA for single-read
   	bwa mem \
	-M \
    	-R $READGROUPLINE \
    	-t ${bwaAlignCores} \
    	${indexFile} \
    	${srBarcodePhiXFqGz} \
    	> ${tmpAlignedSam} &
	
	java -Djava.io.tmpdir=${tempDir} -Xmx29G -XX:ParallelGCThreads=4 -jar ${EBROOTPICARD}/${picardJar} SortSam \
        INPUT=${tmpAlignedSam} \
        OUTPUT=${tmpAlignedSortedBam}  \
        SORT_ORDER=coordinate \
        CREATE_INDEX=true

	mv ${tmpAlignedSortedBam} ${alignedSortedBam}


fi


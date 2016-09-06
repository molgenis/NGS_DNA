#MOLGENIS walltime=23:59:00 nodes=1 ppn=8 mem=10gb

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string seqType
#string bwaVersion
#string indexFile
#string bwaAlignCores
#string peEnd1BarcodePhiXFqGz
#string peEnd2BarcodePhiXFqGz
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

makeTmpDir ${alignedSam} 
tmpAlignedSam=${MC_tmpFile}

#Load module BWA
${stage} ${bwaVersion}
${checkStage}

READGROUPLINE="@RG\tID:${lane}\tPL:illumina\tLB:${filePrefix}\tSM:${externalSampleID}"

#If paired-end use two fq files as input, else only one
if [ "${seqType}" == "PE" ]
then
	#Run BWA for paired-end
    	bwa mem \
    	-M \
    	-R $READGROUPLINE \
    	-t ${bwaAlignCores} \
    	${indexFile} \
    	${peEnd1BarcodePhiXFqGz} \
    	${peEnd2BarcodePhiXFqGz} \
    	> ${tmpAlignedSam}

	echo -e "\nBWA sampe finished succesfull. Moving temp files to final.\n\n"
	mv ${tmpAlignedSam} ${alignedSam}
	echo "removing FastQ files with PhiX reads, run SpikePhiX step to get a FastQ file with PhiX reads"
	rm ${peEnd1BarcodePhiXFqGz}
	rm ${peEnd2BarcodePhiXFqGz}

	echo "phiX appended fastq files are deleted"

else
    	#Run BWA for single-read
   	bwa mem \
	-M \
    	-R $READGROUPLINE \
    	-t ${bwaAlignCores} \
    	${indexFile} \
    	${srBarcodePhiXFqGz} \
    	> ${tmpAlignedSam}
	
	echo -e "\nBWA sampe finished succesfull. Moving temp files to final.\n\n"
	mv ${tmpAlignedSam} ${alignedSam}


fi


#MOLGENIS walltime=23:59:00 nodes=1 ppn=4 mem=13gb

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
#string fastq1
#string fastq2
#string srBarcodeRecodedFqGz
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

makeTmpDir "${alignedSam}"
tmpAlignedSam="${MC_tmpFile}"

makeTmpDir "${alignedSortedBam}"
tmpAlignedSortedBam="${MC_tmpFile}"

#Load module BWA
${stage} "${bwaVersion}"
${stage} "${picardVersion}"
${checkStage}

READGROUPLINE="@RG\tID:${filePrefix}\tPL:illumina\tLB:${externalSampleID}\tSM:${externalSampleID}"
rm -f "${tmpAlignedSam}"

mkfifo -m 0644 "${tmpAlignedSam}"

#If paired-end use two fq files as input, else only one
if [ "${seqType}" == "PE" ]
then
	#Run BWA for paired-end

	bwa mem \
	-M \
	-R "${READGROUPLINE}" \
	-t 4 \
	"${indexFile}" \
	"${fastq1}" \
	"${fastq2}" \
	> "${tmpAlignedSam}" &

	java -Djava.io.tmpdir="${tempDir}" -Xmx12G -XX:ParallelGCThreads=2 -jar "${EBROOTPICARD}/${picardJar}" SortSam \
        INPUT="${tmpAlignedSam}" \
        OUTPUT="${tmpAlignedSortedBam}"  \
        SORT_ORDER=coordinate \
        CREATE_INDEX=true 

	echo "moving ${tmpAlignedSortedBam} ${alignedSortedBam}"
	mv "${tmpAlignedSortedBam}" "${alignedSortedBam}"

#	echo "moving prepared FastQ to intermediateDir"
#	mv "${fastq1}" "${intermediateDir}"
#	mv "${fastq2}" "${intermediateDir}"


else
	#Run BWA for single-read
	bwa mem \
	-M \
	-R "${READGROUPLINE}" \
	-t 4 \
	"${indexFile}" \
	"${srBarcodeRecodedFqGz}" \
	> "${tmpAlignedSam}" &

	java -Djava.io.tmpdir="${tempDir}" -Xmx12G -XX:ParallelGCThreads=2 -jar "${EBROOTPICARD}/${picardJar}" SortSam \
        INPUT="${tmpAlignedSam}" \
        OUTPUT="${tmpAlignedSortedBam}"  \
        SORT_ORDER=coordinate \
        CREATE_INDEX=true

	echo "moving ${tmpAlignedSortedBam} ${alignedSortedBam}"
	mv "${tmpAlignedSortedBam}" "${alignedSortedBam}"

#	echo "moving prepared FastQ to intermediateDir"
#        mv "${srBarcodeRecodedFqGz}" "${intermediateDir}"

fi


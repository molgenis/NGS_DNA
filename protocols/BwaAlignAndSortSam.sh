set -o pipefail

#Parameter mapping
#string tmpName
#string tempDir


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
#string gatkVersion

makeTmpDir "${alignedSam}"
tmpAlignedSam="${MC_tmpFile}"

makeTmpDir "${alignedSortedBam}"
tmpAlignedSortedBam="${MC_tmpFile}"

#Load module BWA
module load "${bwaVersion}"
module load "${gatkVersion}"
module list

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

	gatk --java-options "-Djava.io.tmpdir=${tempDir} -Xmx12G -XX:ParallelGCThreads=2" SortSam \
        --INPUT="${tmpAlignedSam}" \
        --OUTPUT="${tmpAlignedSortedBam}"  \
        --SORT_ORDER coordinate \
        --CREATE_INDEX=true

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

	gatk --java-options "-Djava.io.tmpdir=${tempDir} -Xmx12G -XX:ParallelGCThreads=2" SortSam \
        --INPUT="${tmpAlignedSam}" \
        --OUTPUT="${tmpAlignedSortedBam}"  \
        --SORT_ORDER coordinate \
        --CREATE_INDEX=true

	echo "moving ${tmpAlignedSortedBam} ${alignedSortedBam}"
	mv "${tmpAlignedSortedBam}" "${alignedSortedBam}"

#	echo "moving prepared FastQ to intermediateDir"
#        mv "${srBarcodeRecodedFqGz}" "${intermediateDir}"

fi


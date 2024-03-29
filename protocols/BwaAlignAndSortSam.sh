set -o pipefail
set -o pipefail

#Parameter mapping
#string gatkVersion
#string bwaVersion
#string tmpName
#string tempDir
#string seqType
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
if [[ "${seqType}" == "PE" ]]
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
	-I "${tmpAlignedSam}" \
	-O "${tmpAlignedSortedBam}"  \
	--SORT_ORDER coordinate \
	--CREATE_INDEX true

	mv -v "${tmpAlignedSortedBam}" "${alignedSortedBam}"

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
	-I "${tmpAlignedSam}" \
	-O "${tmpAlignedSortedBam}"  \
	--SORT_ORDER coordinate \
	--CREATE_INDEX true

	mv -v "${tmpAlignedSortedBam}" "${alignedSortedBam}"

fi


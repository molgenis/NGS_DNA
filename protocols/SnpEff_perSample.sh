set -o pipefail
#Parameter mapping
#string tmpName
#string tempDir
#string intermediateDir
#string sampleVariantCallsSnpEff_Annotated
#string sampleVariantCallsSnpEff_SummaryHtml
#string sampleGenotypedAnnotatedVariantCalls
#string project
#string logsDir
#string groupname
#string tmpDataDir
#string snpEffVersion
#string javaVersion

makeTmpDir "${sampleVariantCallsSnpEff_Annotated}"
tmpSampleVariantCallsSnpEff_Annotated="${MC_tmpFile}"

module load "${snpEffVersion}"
module list

if [ -f "${sampleGenotypedAnnotatedVariantCalls}" ]
then
	#Run snpEff
	java -XX:ParallelGCThreads=1 -Djava.io.tmpdir="${tempDir}" -Xmx3g -jar \
	"${EBROOTSNPEFF}/snpEff.jar" \
	-v hg19 \
	-csvStats "${tmpSampleVariantCallsSnpEff_Annotated}.csvStats.csv" \
	-noLog \
	-lof \
	-stats "${sampleVariantCallsSnpEff_SummaryHtml}" \
	-canon \
	-ud 0 \
	-c "${EBROOTSNPEFF}/snpEff.config" \
	"${sampleGenotypedAnnotatedVariantCalls}" \
	> "${tmpSampleVariantCallsSnpEff_Annotated}"

	mv -v "${tmpSampleVariantCallsSnpEff_Annotated}" "${sampleVariantCallsSnpEff_Annotated}"
	mv -v "${tmpSampleVariantCallsSnpEff_Annotated}.csvStats.csv" "${sampleVariantCallsSnpEff_Annotated}.csvStats.csv"

else
	echo "${sampleGenotypedAnnotatedVariantCalls} does not exist, skipped"
fi

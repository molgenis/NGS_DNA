#Parameter mapping
#string tmpName
#string tempDir
#string intermediateDir
#string projectVariantCallsSnpEff_Annotated
#string projectVariantCallsSnpEff_SummaryHtml
#string projectBatchGenotypedAnnotatedVariantCalls
#string project
#string logsDir
#string groupname
#string tmpDataDir
#string snpEffVersion
#string javaVersion

makeTmpDir "${projectVariantCallsSnpEff_Annotated}"
tmpProjectVariantCallsSnpEff_Annotated="${MC_tmpFile}"

module load "${snpEffVersion}"
module list

if [ -f "${projectBatchGenotypedAnnotatedVariantCalls}" ]
then
	#Run snpEff
	java -XX:ParallelGCThreads=1 -Djava.io.tmpdir="${tempDir}" -Xmx3g -jar \
	"${EBROOTSNPEFF}/snpEff.jar" \
	-v hg19 \
	-csvStats "${tmpProjectVariantCallsSnpEff_Annotated}.csvStats.csv" \
	-noLog \
	-lof \
	-stats "${projectVariantCallsSnpEff_SummaryHtml}" \
	-canon \
	-ud 0 \
	-c "${EBROOTSNPEFF}/snpEff.config" \
	"${projectBatchGenotypedAnnotatedVariantCalls}" \
	> "${tmpProjectVariantCallsSnpEff_Annotated}"

	mv -v "${tmpProjectVariantCallsSnpEff_Annotated}" "${projectVariantCallsSnpEff_Annotated}"
	mv -v "${tmpProjectVariantCallsSnpEff_Annotated}.csvStats.csv" "${projectVariantCallsSnpEff_Annotated}.csvStats.csv"

else
	echo "skipped"
fi

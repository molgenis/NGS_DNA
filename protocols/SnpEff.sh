#MOLGENIS walltime=23:59:00 mem=5gb ppn=2

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string projectVariantCallsSnpEff_Annotated
#string projectVariantCallsSnpEff_SummaryHtml
#string projectBatchGenotypedVariantCalls
#string project
#string logsDir
#string groupname
#string tmpDataDir
#string snpEffVersion
#string javaVersion

makeTmpDir "${projectVariantCallsSnpEff_Annotated}"
tmpProjectVariantCallsSnpEff_Annotated="${MC_tmpFile}"

"${stage}" "${snpEffVersion}"
"${checkStage}"

if [ -f "${projectBatchGenotypedVariantCalls}" ]
then
	#
	##
	###Annotate with SnpEff
        ##
	#
	#Run snpEff
	java -XX:ParallelGCThreads=2 -Djava.io.tmpdir="${tempDir}" -Xmx4g -jar \
	"${EBROOTSNPEFF}/snpEff.jar" \
	-v hg19 \
	-csvStats "${tmpProjectVariantCallsSnpEff_Annotated}.csvStats.csv" \
	-noLog \
	-lof \
	-stats "${projectVariantCallsSnpEff_SummaryHtml}" \
	-canon \
	-ud 0 \
	-c "${EBROOTSNPEFF}/snpEff.config" \
	"${projectBatchGenotypedVariantCalls}" \
	> "${tmpProjectVariantCallsSnpEff_Annotated}"

	mv "${tmpProjectVariantCallsSnpEff_Annotated}" "${projectVariantCallsSnpEff_Annotated}"
	mv "${tmpProjectVariantCallsSnpEff_Annotated}.csvStats.csv" "${projectVariantCallsSnpEff_Annotated}.csvStats.csv 
	echo "mv ${tmpProjectVariantCallsSnpEff_Annotated} ${projectVariantCallsSnpEff_Annotated}"

else
	echo "skipped"
fi

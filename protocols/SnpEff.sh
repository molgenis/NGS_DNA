#MOLGENIS walltime=23:59:00 mem=6gb ppn=8

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string projectVariantCallsSnpEff_Annotated
#string projectBatchGenotypedVariantCalls
#string project
#string logsDir 
#string groupname
#string tmpDataDir
#string snpEffVersion
#string javaVersion

sleep 5

makeTmpDir ${projectVariantCallsSnpEff_Annotated}
tmpProjectVariantCallsSnpEff_Annotated=${MC_tmpFile}

${stage} ${snpEffVersion}
${checkStage}

if [ -f ${projectBatchGenotypedVariantCalls} ]
then
    	#
	##
	###Annotate with SnpEff
        ##
	#
	#Run snpEff
	java -XX:ParallelGCThreads=4 -Djava.io.tmpdir=${tempDir} -Xmx4g -jar \
	$EBROOTSNPEFF/snpEff.jar \
	-v hg19 \
	-noStats \
	-noLog \
	-lof \
	-canon \
	-ud 0 \
	-c $EBROOTSNPEFF/snpEff.config \
	${projectBatchGenotypedVariantCalls} \
	> ${tmpProjectVariantCallsSnpEff_Annotated}

	mv ${tmpProjectVariantCallsSnpEff_Annotated} ${projectVariantCallsSnpEff_Annotated}
	echo "mv ${tmpProjectVariantCallsSnpEff_Annotated} ${projectVariantCallsSnpEff_Annotated}"

else
	echo "skipped"
fi

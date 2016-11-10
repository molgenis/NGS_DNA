#MOLGENIS walltime=05:59:00 mem=12gb ppn=2
#string tmpName
#Parameter mapping
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string project
#string logsDir 
#string groupname

#string javaVersion
#string molgenisAnnotatorVersion
#string molgenisAnnotatorJar
#string projectBatchGenotypedVariantCalls
#string projectVariantCallsSnpEff_Annotated
#string projectVariantCallsSnpEff_ExAC_Annotated
#string projectVariantCallsSnpEff_ExAC_GoNL_Annotated
#string projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated
#string caddAnnotation
#string gonlAnnotation
#string exacAnnotation

sleep 3

makeTmpDir ${projectVariantCallsSnpEff_ExAC_Annotated}
tmpProjectVariantCallsSnpEff_ExAC_Annotated=${MC_tmpFile}

makeTmpDir ${projectVariantCallsSnpEff_ExAC_GoNL_Annotated}
tmpProjectVariantCallsSnpEff_ExAC_GoNL_Annotated=${MC_tmpFile}

makeTmpDir ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated}
tmpProjectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated=${MC_tmpFile}

${stage} ${javaVersion}
${stage} ${molgenisAnnotatorVersion}

${checkStage}
if [ -f ${projectVariantCallsSnpEff_Annotated} ]
then
	#
	##
	###Annotate with ExAC
	##
	#
	java -Xmx10g -jar -Djava.io.tmpdir=${tempDir} ${EBROOTCMDLINEANNOTATOR}/${molgenisAnnotatorJar} \
	-a exac \
	-s ${exacAnnotation} \
	-i ${projectVariantCallsSnpEff_Annotated} \
	-o ${tmpProjectVariantCallsSnpEff_ExAC_Annotated}

	mv ${tmpProjectVariantCallsSnpEff_ExAC_Annotated} ${projectVariantCallsSnpEff_ExAC_Annotated} 
	echo "Finished Exac annotation"

	#
	##
	###Annotate with GoNL
	##
	#
	java -Xmx10g -jar -Djava.io.tmpdir=${tempDir} ${EBROOTCMDLINEANNOTATOR}/${molgenisAnnotatorJar} \
	-a gonl \
	-s ${gonlAnnotation} \
	-i ${projectVariantCallsSnpEff_ExAC_Annotated} \
	-o ${tmpProjectVariantCallsSnpEff_ExAC_GoNL_Annotated}

	mv ${tmpProjectVariantCallsSnpEff_ExAC_GoNL_Annotated} ${projectVariantCallsSnpEff_ExAC_GoNL_Annotated} 
	echo "Finished GoNL annotation"

	#
	##
	###Annotate with CADD-SNVs
	##
	#
	java -Xmx10g -jar -Djava.io.tmpdir=${tempDir} ${EBROOTCMDLINEANNOTATOR}/${molgenisAnnotatorJar} \
	-a cadd \
	-s ${caddAnnotation} \
	-i ${projectVariantCallsSnpEff_ExAC_GoNL_Annotated} \
	-o ${tmpProjectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated}
	
	mv ${tmpProjectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated} ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated} 
	echo "Finished CADD-SNVs annotation"

	echo "annotation step done, the fully annotated vcf file is: ${projectVariantCallsSnpEff_ExAC_GoNL_CADD_Annotated}"
else
	echo "skipped, ${projectBatchGenotypedVariantCalls} is not existing"
fi


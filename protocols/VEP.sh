#MOLGENIS walltime=23:59:00 mem=6gb ppn=8

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string projectVariantCallsVEP_Annotated
#string projectBatchGenotypedVariantCalls
#string project
#string logsDir 
#string groupname
#string tmpDataDir
#string snpEffVersion
#string javaVersion
#string vepDBVersion
#string vepDataDir
#string vepVersion
sleep 5

makeTmpDir ${projectVariantCallsVEP_Annotated}
tmpProjectVariantCallsVEP_Annotated=${MC_tmpFile}

${stage} ${vepVersion}
${checkStage}
if [ -f ${projectBatchGenotypedVariantCalls} ]
then 
	${EBROOTVEP}/variant_effect_predictor.pl \
	-i ${projectBatchGenotypedVariantCalls} \
	--offline \
	--cache \
	--dir ${vepDataDir} \
	--db_version=${vepDBVersion} \
	--buffer 1000 \
	--most_severe \
	--species homo_sapiens \
	--vcf \
	-o ${tmpProjectVariantCallsVEP_Annotated}  
	
	mv ${tmpProjectVariantCallsVEP_Annotated} ${projectVariantCallsVEP_Annotated}
       	echo "mv ${tmpProjectVariantCallsVEP_Annotated} ${projectVariantCallsVEP_Annotated}"
	
else
	echo "skipped"
fi

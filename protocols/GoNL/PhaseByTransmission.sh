#MOLGENIS ppn=2 mem=12gb walltime=03:00:00

#string project
#string logsDir 
#string groupname
#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string projectBatchGenotypedVariantCalls

ml $gatkVersion
echo "round 1, abc samples" 
if [ -f "${projectBatchGenotypedVariantCalls}" ]
then
java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar ${EBROOTGATK}/${gatkJar} \
   -T PhaseByTransmission \
   -R ${indexFile} \
   -V "${projectBatchGenotypedVariantCalls}" \
   -mvf "${projectBatchGenotypedVariantCalls}.mvf" \
   -ped ${intermediateDir}/children.ped \
   -o "${projectBatchGenotypedVariantCalls}.PBToutput.abc.vcf"
fi

echo "round 1, exclude d samples" 

##exclude d samples
java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar ${EBROOTGATK}/${gatkJar} \
-T SelectVariants \
-R ${indexFile} \
--variant ${projectBatchGenotypedVariantCalls}.PBToutput.abc.vcf \
-o ${projectBatchGenotypedVariantCalls}.PBToutput.vcf.abcFiltered.vcf \
-xl_se 'gonl-.+d'

echo "round 2, abd samples"
if [ -f "${projectBatchGenotypedVariantCalls}" ]
then
java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar ${EBROOTGATK}/${gatkJar} \
   -T PhaseByTransmission \
   -R ${indexFile} \
   -V "${projectBatchGenotypedVariantCalls}" \
   -mvf "${projectBatchGenotypedVariantCalls}.abd.mvf" \
   -ped ${intermediateDir}/children_d.ped \
   -o "${projectBatchGenotypedVariantCalls}.PBToutput.abd.vcf"
fi

echo "round 2, include d samples"
##include only d samples
java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar ${EBROOTGATK}/${gatkJar} \
-T SelectVariants \
-R ${indexFile} \
--variant ${projectBatchGenotypedVariantCalls}.PBToutput.abd.vcf \
-o ${projectBatchGenotypedVariantCalls}.PBToutput.vcf.dFiltered.vcf \
-se 'gonl-.+d'

echo "make one big vcf containing abc and d samples" 
## make one big vcf containing abc and d samples
java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar ${EBROOTGATK}/${gatkJar} \
-T CombineVariants \
-R ${indexFile}  \
   --variant ${projectBatchGenotypedVariantCalls}.PBToutput.vcf.abcFiltered.vcf \
   --variant ${projectBatchGenotypedVariantCalls}.PBToutput.vcf.dFiltered.vcf \
   -o ${projectBatchGenotypedVariantCalls}.PBToutput.vcf \
   -genotypeMergeOptions UNIQUIFY



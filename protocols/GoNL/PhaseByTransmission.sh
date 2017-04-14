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
 
if [ -f "${projectBatchGenotypedVariantCalls}" ]
then
java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx12g -jar ${EBROOTGATK}/${gatkJar} \
   -T PhaseByTransmission \
   -R ${indexFile} \
   -V "${projectBatchGenotypedVariantCalls}" \
   -mvf "${projectBatchGenotypedVariantCalls}.mvf" \
   -ped ${intermediateDir}/children.ped \
   -o "${projectBatchGenotypedVariantCalls}.PBToutput.vcf"

fi

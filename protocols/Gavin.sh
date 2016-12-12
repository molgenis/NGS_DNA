#MOLGENIS walltime=05:59:00 mem=6gb 
#string tmpName
#Parameter mapping
#string stage
#string checkStage
#string tempDir
#string intermediateDir
#string project
#string logsDir 
#string groupname
#string snpEffVersion
#string javaVersion

#string projectVariantsMerged
#string gavinClinVar
#string gavinCGD
#string gavinFDR
#string gavinCalibrations
#string gavinOutputFirstPass
#string gavinOutputFinal
#string gavinToCADD
#string gavinFromCADD
#string gavinToCADDgz
#string gavinFromCADDgz
#string tabixVersion

#string gavinToolPackVersion
#string gavinJar
#string gavinSplitRlvToolJar
#string gavinMergeBackToolJar
#string gavinOutputFinalMerged
#string gavinOutputFinalMergedRLV

sleep 3

makeTmpDir ${gavinOutputFirstPass}
tmpGavinOutputFirstPass=${MC_tmpFile}

makeTmpDir ${gavinToCADDgz}
tmpGavinToCADDgz=${MC_tmpFile}

makeTmpDir ${gavinToCADD}
tmpGavinToCADD=${MC_tmpFile}

makeTmpDir ${gavinOutputFinal}
tmpGavinOutputFinal=${MC_tmpFile}

makeTmpDir ${gavinFromCADDgz}
tmpGavinFromCADDgz=${MC_tmpFile}

${stage} ${tabixVersion}
${stage}  PerlPlus/5.22.0-foss-2015b-v16.11.1
${stage}  HTSlib/1.3.2-foss-2015b
${stage}  SAMtools/1.3.1-foss-2015b
${stage}  PythonPlus/2.7.10-foss-2015b-v16.11.1

${stage} ${gavinToolPackVersion}

${checkStage}
java -Xmx4g -jar ${EBROOTGAVINMINTOOLPACK}/${gavinJar} \
-i ${projectVariantsMerged} \
-o ${tmpGavinOutputFirstPass} \
-m CREATEFILEFORCADD \
-a ${tmpGavinToCADD} \
-c ${gavinClinVar} \
-d ${gavinCGD} \
-f ${gavinFDR} \
-g ${gavinCalibrations}

mv ${tmpGavinOutputFirstPass} ${gavinOutputFirstPass}
echo "moved ${tmpGavinOutputFirstPass} to ${gavinOutputFirstPass}"

mv ${tmpGavinToCADD} ${gavinToCADD}
echo "moved ${tmpGavinToCADD} to ${gavinToCADD}"

echo "GAVIN round 1 is finished, uploading to CADD..."


echo "navigate to /groups/umcg-gaf/tmp04/umcg-pneerincx/CADD_v1.3.manual/"
cd /groups/umcg-gaf/tmp04/umcg-pneerincx/CADD_v1.3.manual/
echo "starting to get CADD annotations locally for ${gavinToCADD}"

bgzip -c ${gavinToCADD} > ${gavinToCADDgz}
tabix -p vcf ${gavinToCADDgz} 

bin/score.sh ${gavinToCADDgz} ${tmpGavinFromCADDgz}

cd -

mv ${tmpGavinFromCADDgz} ${gavinFromCADDgz}
echo "moved ${tmpGavinFromCADDgz} ${gavinFromCADDgz}"

java -Xmx4g -jar ${EBROOTGAVINMINTOOLPACK}/${gavinJar} \
-i ${projectVariantsMerged} \
-o ${tmpGavinOutputFinal} \
-m ANALYSIS \
-a ${gavinFromCADDgz} \
-c ${gavinClinVar} \
-d ${gavinCGD} \
-f ${gavinFDR} \
-g ${gavinCalibrations}

mv ${tmpGavinOutputFinal} ${gavinOutputFinal}
echo "mv ${tmpGavinOutputFinal} ${gavinOutputFinal}"

#echo 'GAVIN round 2 finished, too see how many results are left do : grep -v "#" ${gavinOutputFinal} | wc -l'

echo "Merging ${projectVariantsMerged} and ${gavinOutputFinal}"

java -jar -Xmx4g ${EBROOTGAVINMINTOOLPACK}/${gavinMergeBackToolJar} \
-i ${projectVariantsMerged} \
-v ${gavinOutputFinal} \
-o ${gavinOutputFinalMerged}


#gavinSplitRlvToolJar
java -jar -Xmx4g ${EBROOTGAVINMINTOOLPACK}/${gavinSplitRlvToolJar} \
-i ${gavinOutputFinalMerged} \
-o ${gavinOutputFinalMergedRLV}
#perl -pi -e 's|ID=RLV_PRESENT,Number=1,Type=String,|ID=RLV_PRESENT,Number=1,Type=Float,|' ${gavinOutputFinalMergedRLV}
#perl -pi -e 's|RLV_VARIANTSIGNIFICANCE,Number=1,Type=String,|RLV_VARIANTSIGNIFICANCE,Number=1,Type=Float,|' ${gavinOutputFinalMergedRLV}

echo "output: ${gavinOutputFinalMergedRLV}"

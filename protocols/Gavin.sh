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

#string gavinToolPackVersion
#string gavinJar
#string gavinSplitRlvToolJar
#string gavinMergeBackToolJar
#string gavinOutputFirstPassMerged
#string gavinOutputFirstPassMergedRLV

sleep 3

makeTmpDir ${gavinOutputFirstPass}
tmpGavinOutputFirstPass=${MC_tmpFile}

makeTmpDir ${gavinToCADD}
tmpGavinToCADD=${MC_tmpFile}

makeTmpDir ${gavinOutputFinal}
tmpGavinOutputFinal=${MC_tmpFile}

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


##UPLOADING TO CADD
### 
###
# INPUT: ${gavinToCADD}
# OUTPUT: ${gavinFromCADD}


#java -Xmx4g -jar ${EBROOTGAVINMINTOOLPACK}/${gavinJar} \
#-i ${projectVariantsMerged} \
#-o ${tmpGavinOutputFinal} \
#-m ANALYSIS \
#-a ${gavinFromCADD} \
#-c ${gavinClinVar} \
#-d ${gavinCGD} \
#-f ${gavinFDR} \
#-g ${gavinCalibrations}

#mv ${tmpGavinOutputFinal} ${gavinOutputFinal}
#echo "mv ${tmpGavinOutputFinal} ${gavinOutputFinal}"

#echo 'GAVIN round 2 finished, too see how many results are left do : grep -v "#" ${gavinOutputFinal} | wc -l'

echo "Merging ${projectVariantsMerged} and ${gavinOutputFirstPass}"

java -jar -Xmx4g ${EBROOTGAVINMINTOOLPACK}/${gavinMergeBackToolJar} \
-i ${projectVariantsMerged} \
-v ${gavinOutputFirstPass} \
-o ${gavinOutputFirstPassMerged}


#gavinSplitRlvToolJar
java -jar -Xmx4g ${EBROOTGAVINMINTOOLPACK}/${gavinSplitRlvToolJar} \
-i ${gavinOutputFirstPassMerged} \
-o ${gavinOutputFirstPassMergedRLV}
perl -pi -e 's|ID=RLV_PRESENT,Number=1,Type=String,|ID=RLV_PRESENT,Number=1,Type=Float,|' ${gavinOutputFirstPassMergedRLV}
perl -pi -e 's|RLV_VARIANTSIGNIFICANCE,Number=1,Type=String,|RLV_VARIANTSIGNIFICANCE,Number=1,Type=Float,|' ${gavinOutputFirstPassMergedRLV}

echo "output: ${gavinOutputFirstPassMergedRLV}"

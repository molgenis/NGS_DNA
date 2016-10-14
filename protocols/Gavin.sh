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

#string projectVariantsMergedSorted
#string gavinClinVar
#string gavinCGD
#string gavinFDR
#string gavinCalibrations
#string gavinJar
#string gavinVersion
#string gavinOutputFirstPass
#string gavinOutputFinal
#string gavinToCADD
#string gavinFromCADD

#string gavinMergeBackToolVersion
#string gavinMergeBackToolJar
#string gavinOutputFirstPassMerged

sleep 3

makeTmpDir ${gavinOutputFirstPass}
tmpGavinOutputFirstPass=${MC_tmpFile}

makeTmpDir ${gavinToCADD}
tmpGavinToCADD=${MC_tmpFile}

makeTmpDir ${gavinOutputFinal}
tmpGavinOutputFinal=${MC_tmpFile}

${stage} ${gavinVersion}
${stage} ${gavinMergeBackToolVersion}

${checkStage}
java -Xmx4g -jar ${EBROOTGAVIN}/${gavinJar} \
-i ${projectVariantsMergedSorted} \
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


#java -Xmx4g -jar ${EBROOTGAVIN}/${gavinJar} \
#-i ${projectVariantsMergedSorted} \
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

echo "Merging ${projectVariantsMergedSorted} and ${gavinOutputFirstPass}"

java -jar -Xmx4g ${EBROOTGAVINMERGEBACKTOOL}/${gavinMergeBackToolJar} \
-i ${projectVariantsMergedSorted} \
-v ${gavinOutputFirstPass} \
-o ${gavinOutputFirstPassMerged}

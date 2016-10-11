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
#string gavinToCADD

sleep 3

makeTmpDir ${gavinOutputFirstPass}
tmpGavinOutputFirstPass=${MC_tmpFile}

makeTmpDir ${gavinToCADD}
tmpGavinToCADD=${MC_tmpFile}

${stage} ${gavinVersion}

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

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
#string htsLibVersion

#string gavinToolPackVersion
#string gavinJar
#string gavinSplitRlvToolJar
#string gavinMergeBackToolJar
#string gavinOutputFinalMerged
#string gavinOutputFinalMergedRLV
#string sampleFinalVcf

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

${stage} ${htsLibVersion}
${stage} ${gavinToolPackVersion}

${checkStage}
java -Xmx4g -jar ${EBROOTGAVINMINTOOLPACK}/${gavinJar} \
-i ${sampleFinalVcf} \
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

echo "starting to get CADD annotations locally for ${gavinToCADD}"

bgzip -c ${gavinToCADD} > ${gavinToCADDgz}
tabix -p vcf ${gavinToCADDgz} 

score.sh ${gavinToCADDgz} ${tmpGavinFromCADDgz}

mv ${tmpGavinFromCADDgz} ${gavinFromCADDgz}
echo "moved ${tmpGavinFromCADDgz} ${gavinFromCADDgz}"

java -Xmx4g -jar ${EBROOTGAVINMINTOOLPACK}/${gavinJar} \
-i ${sampleFinalVcf} \
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

echo "Merging ${sampleVariantsMergedGavin} and ${gavinOutputFinal}"

java -jar -Xmx4g ${EBROOTGAVINMINTOOLPACK}/${gavinMergeBackToolJar} \
-i ${sampleFinalVcf} \
-r \
-v ${gavinOutputFinal} \
-o ${gavinOutputFinalMerged}


#gavinSplitRlvToolJar
java -jar -Xmx4g ${EBROOTGAVINMINTOOLPACK}/${gavinSplitRlvToolJar} \
-i ${gavinOutputFinalMerged} \
-r \
-o ${gavinOutputFinalMergedRLV}

perl -pi -e 's|INFO=<ID=EXAC_AF,Number=.,Type=String|INFO=<ID=EXAC_AF,Number=.,Type=Float|' ${gavinOutputFinalMergedRLV}
perl -pi -e 's|INFO=<ID=EXAC_AC_HOM,Number=.,Type=String|INFO=<ID=EXAC_AC_HOM,Number=.,Type=Integer|' ${gavinOutputFinalMergedRLV}
perl -pi -e 's|INFO=<ID=EXAC_AC_HET,Number=.,Type=String|INFO=<ID=EXAC_AC_HET,Number=.,Type=Integer|' ${gavinOutputFinalMergedRLV}


echo "output: ${gavinOutputFinalMergedRLV}"

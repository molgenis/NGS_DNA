#MOLGENIS walltime=05:59:00 mem=10gb ppn=10

#Parameter mapping
#string project
#string logsDir 
#string groupname
#string tmpName
#string stage
#string checkStage

#string intermediateDir
#string externalSampleID
#string manVarListMVL_LB_B
#string manVarListMVL_VUS_LP_P
#string manVarListVKGL_consensus_VUS_LP_P
#string gatkJar
#string indexFile
#string gavinOutputFinalMergedRLV
### SHARED STEPS (USED MULTIPLE TIMES)

####################
##
## ManVar (V/LP/P) (inputfile,outputfile)
function manVarCheck(){
input="${1}"
outputOverlap="${2}"
outputNoOverlap="${3}"
manVarList="${4}"

#continue to next step
bedtools intersect -header -v -a "${input}" -b "${manVarList}" > "${outputNoOverlap}" 

##found back in ManVar = continue to specific tree
bedtools intersect -header -a "${input}" -b "${manVarList}" > "${outputOverlap}" 

}

function gnomADpopFreqCheck(){
input="${1}"
outputOverlap="${2}"
outputNoOverlap="${3}"
freq="${4}"
##overlap
java -Xmx2g -jar "${EBROOTGATK}/GenomeAnalysisTK.jar" \
   -R "//apps//data//1000G/phase1/human_g1k_v37_phiX.fasta" \
   -T SelectVariants \
   -V "${input}" \
   -o "${outputOverlap}" \
   -sn '${externalSampleID}' \
   -select "gnomAD_AF_MAX < ${freq}"

##no overlap
java -Xmx2g -jar "${EBROOTGATK}/GenomeAnalysisTK.jar" \
   -R "//apps//data//1000G/phase1/human_g1k_v37_phiX.fasta" \
   -T SelectVariants \
   -V "${input}" \
   -o "${outputNoOverlap}" \
   -sn '${externalSampleID}' \
   -select "gnomAD_AF_MAX >= ${freq}"
}
##
###################
####################
##
### STEP HGMD 2.2.2 / 8.1.1 / 8.2.1 (inputfile,outputfile)
##
####################

###################
##
### STEP Coding effect 2.2.1 / 8.2.2 (inputfile,outputfile,coding effects)
##
####################

###################
##
### STEP Pop Freq 8.1.3 / 8.2.4 (inputfile,outputfile,freq)
##
####################
################# EOF SHARED SHARED STEPS #########

i="${externalSampleID}"
ml BEDTools



### 1. Pass
	### 1.1 yes
	### 1.2 Genesfilter (set of genes that always should be included)
### 2. Read Depth
	### 2.1 >20x
	### 2.2 >10x ####
		### 2.2.1 ManVar (V/LP/P)
		### 2.2.2 HGMD (DM)
		### 2.2.1 Coding effect
### 3. No HLA
### 4. No MT
### 5. MVL LB/B Cartegenia--> 6
### 6. MVL VUS/LP/P Cartegenia--> 7
### 7. VKGL Consensus Cartegenia--> 8
### 8. RLV Present Cartegenia--> 5
	### 8.1 RLV_True
		### 8.1.1 HGMD
		### 8.1.2 ClinVar
		### 8.1.3 Pop freq <1% (GnomAD) annotate Homozygous/Hemizygous
	### 8.2 RLV_False
		### 8.2.1 HGMD
		### 8.2.2 Coding effect (frameshift, startloss, stopgain, in-frame
		### 8.2.3 Splice site (-2 / +2)
		### 8.2.4 Pop freq <0.5% (GnomAD) annotate Homozygous/Hemizygous
### 9. Merge all continue to spec tree together
### 10. Annotate AR/AD/X-Linked with OMIM/HPO
### 11. Continue to specific tree
input=${gavinOutputFinalMergedRLV}
name=${gavinOutputFinalMergedRLV%.GAVIN.rlv.vcf}

stepCount_0=$(cat ${input} | wc -l)

outputStep1_next="${name}.step1_next.vcf"
##
### STEP 1: PASS filter
##

outputStep1="${name}.PASS.vcf"
grep '^#' "${input}" > "${outputStep1}"

grep '^#' "${input}" > ${name}.notPASS.vcf

##PASS
grep -v '^#' "${input}" | grep 'PASS'  >> "${outputStep1}"
## NO PASS
grep -v '^#' ${input} | grep -v 'PASS' >> ${name}.notPASS.vcf

##
###STEP 1.1 GENEFILTER
##
############# TO BE IMPLEMENTED #############
### input ${name}.notPASS.vcf
### output "${outputStep1_1}"

### 1.2 merge all variants that continue the tree
## "${outputStep1}" "${outputStep1_1}" > ${outputFinalStep1}
cat "${outputStep1}" > "${outputStep1_next}"

cat "${outputStep1_next}" | grep -v '^#' | wc -l > "${name}.step1.count"

##
### Step 2.1 Read Depth > 20x 2.2 Read Depth >10x ####
##
outputStep2_next="${name}.step2_next.vcf"
outputStep2_1="${name}.step2_1.moreThan20x.vcf"
outputStep2_2="${name}.step2_1.moreThan10x.vcf"
ml GATK/3.7-Java-1.8.0_74

 java -Xmx2g -jar "${EBROOTGATK}/${gatkJar}" \
   -R "${indexFile}" \
   -T SelectVariants \
   -V "${outputStep1_next}" \
   -o "${outputStep2_1}" \
   -sn '${externalSampleID}' \
   -select "DP >= 20.0"

cat "${outputStep2_1}" | grep -v '^#' | wc -l > "${name}.step2_1.count"

java -Xmx2g -jar "${EBROOTGATK}/${gatkJar}" \
   -R "${indexFile}" \
   -T SelectVariants \
   -V "${outputStep1_next}" \
   -o "${outputStep2_2}" \
   -sn '${externalSampleID}' \
   -select "DP >= 10.0 && DP < 20.0 "

cat "${outputStep2_2}" | grep -v '^#' | wc -l > "${name}.step2_2.count"

### 2.2.1 ManVar (V/LP/P) (SHARED STEP)
outputStep2_2_1_next="${name}.step2_2_1.manVar_No_V_LP_P.vcf"
outputStep2_2_1_nextHLA="${name}.step2_2_1.manVar_V_LP_P.vcf"

manVarCheck "${outputStep2_2}" "${outputStep2_2_1_nextHLA}" "${outputStep2_2_1_next}" "${manVarListMVL_VUS_LP_P}"

cat "${outputStep2_2_1_nextHLA}" | grep -v '^#' | wc -l > "${name}.step2_2_1nextHLA.count"
cat "${outputStep2_2_1_next}" | grep -v '^#' | wc -l > "${name}.step2_2_1next.count"

### 2.2.2 HGMD (DM)
#echo "${outputStep2_2_1}" 
### 2.2.3 Coding effect (SHARED STEP)
outputStep2_2_3_end="${name}.step2_2_3.noCodingEffect.vcf"
outputStep2_2_3_nextHLA="${name}.step2_2_3.codingEffect.vcf"

### 2.2.4 merge all variants that continue the tree
#echo "${outputStep2_1}" "${outputStep2_2_1_overlap}" outputStep2_2_2_overlap outputStep2_2_3_overlap > "${outputFinalStep2}"
java -jar ${EBROOTGATK}/${gatkJar} \
   -T CombineVariants \
   -R ${indexFile} \
   --variant "${outputStep2_1}" \
   --variant "${outputStep2_2_1_nextHLA}" \
   -o "${outputStep2_next}" \
   -genotypeMergeOptions UNSORTED


cat "${outputStep2_next}" | grep -v '^#' | wc -l > "${name}.step2.count"

##
### STEP 3: No HLA
##
outputStep3_next="${name}.step3_noHLA.vcf"
echo "starting step 3: No HLA check"
grep '^#' "${outputStep2_next}" > "${outputStep3_next}"
grep -v '^#' "${outputStep2_next}"  | grep -v 'HLA-D' >> "${outputStep3_next}"

cat "${outputStep3_next}" | grep -v '^#' | wc -l > "${name}.step3.count"


##
### STEP 4: NO MT
##
outputStep4_next="${name}.step4_noMT.vcf"
echo "starting step 4: No MT check"
grep '^#' "${outputStep3_next}" > "${outputStep4_next}"
grep -v '^#' "${outputStep3_next}" | awk '{if ($1 != "MT"){print $0}}' "${outputStep3_next}" > "${outputStep4_next}"

cat "${outputStep4_next}" | grep -v '^#' | wc -l > "${name}.step4.count"


##
### STEP 5: check if LB/B in MVL
##
outputStep5_next="${name}.step5.NoOverlapWith_MVL_LB-B.vcf"
outputStep5_end="${name}.step5.overlapWith_MVL_LB-B.vcf"

manVarCheck "${outputStep4_next}" "${outputStep5_end}" "${outputStep5_next}" "${manVarListMVL_LB_B}"
echo "step 5 done: ${outputStep5_next}"

cat "${outputStep5_next}" | grep -v '^#' | wc -l > "${name}.step5.count"

specTreeArray=()

##
### STEP 6: check if VOUS/LP/P in MVL 
##
outputStep6_next="${name}.step6.NoOverlapWith_MVL_VUS-LP-P.vcf"
outputStep6ToSpecTree="${name}.step6.overlapWith_MVL_VUS-LP-P.vcf"

manVarCheck "${outputStep5_next}" "${outputStep6ToSpecTree}" "${outputStep6_next}" "${manVarListMVL_VUS_LP_P}"
specTreeArray+=("--variant ${outputStep6ToSpecTree}")
echo "step 6 done: ${outputStep6_next}"

cat "${outputStep6_next}" | grep -v '^#' | wc -l > "${name}.step6.count"

##
### STEP 7: check if VOUS/LP/P in VKGL consensus
##
outputStep7_next="${name}.step7.NoOverlapWith_VKGL_consensus_VUS-LP-P.vcf"
outputStep7ToSpecTree="${name}.step7.overlapWith_VKGL_consensus_VUS-LP-P.vcf"

manVarCheck "${outputStep6_next}" "${outputStep7ToSpecTree}" "${outputStep7_next}" "${manVarListVKGL_consensus_VUS_LP_P}"
specTreeArray+=("--variant ${outputStep7ToSpecTree}")
echo "step 7 done: ${outputStep7_next}"
cat "${outputStep7_next}" | grep -v '^#' | wc -l > "${name}.step7.count"

## STEP 8.1 RLV TRUE / 8.2 FALSE
outputStep8ToSpecTree="${name}.step8.vcf"
outputStep8_1="${name}.step8.RLV_TRUE.vcf"
outputStep8_2="${name}.step8.RLV_FALSE.vcf"
echo "starting step 8: RLV PRESENT"
grep '^#' "${outputStep7_next}" > "${outputStep8_1}"
grep '^#' "${outputStep7_next}" > "${outputStep8_2}"

rlvTrue="true"
if grep 'RLV_PRESENT=TRUE' "${outputStep7_next}"
then
	cat "${outputStep8_1}" | grep -v '^#' | wc -l >  "${name}.step8_1.count"

	grep 'RLV_PRESENT=TRUE' "${outputStep7_next}" >> "${outputStep8_1}"
	##
	### Step 8.1.1 HGMD
	##

	##
	### STEP 8.1.2 ClinVar pathogenic/likely pathogenic
	##
	echo "step 8.1.2: ClinVar pathogenic/likely pathogenic"

	outputStep8_1_2ToSpecTree="${name}.step8_1_2.pathogenic.vcf"

	outputStep8_1_2_next="${name}.step8_1_2.notPathogenic.vcf"

	grep '^#' "${outputStep8_1}" > "${outputStep8_1_2ToSpecTree}"
	grep '^#' "${outputStep8_1}" > "${outputStep8_1_2_next}"

	grep -v '^#' "${outputStep8_1}" | grep 'pathogenic' "${outputStep8_1}" >> "${outputStep8_1_2ToSpecTree}"
	grep -v '^#' "${outputStep8_1}" | grep -v 'pathogenic' "${outputStep8_1}" >> "${outputStep8_1_2_next}"

	specTreeArray+=("--variant ${outputStep8_1_2ToSpecTree}")
	cat "${outputStep8_1_2_next}" | grep -v '^#' | wc -l > "${name}.step8_1_2.count"

	##
	### STEP 8.1.3 Pop freq <1% (GnomAD) annotate Homozygous/Hemizygous (SHARED STEP)
	##
	echo "Step 8.1.3: check pop frequency below 1 percent"
	outputStep8_1_3ToSpecTree="${name}.step8_2_5_AF_lt_1percent.vcf"
	outputStep8_1_3_end="${name}.step8_1_3_AF_ge_1percent.vcf"

	gnomADpopFreqCheck "${outputStep8_1_2_next}" "${outputStep8_1_3ToSpecTree}" "${outputStep8_1_3_end}" "1"
	specTreeArray+=("--variant ${outputStep8_1_3ToSpecTree}")

else
	echo "there are no variants with RLV_PRESENT=TRUE"
        rlvTrue="false"
fi



grep 'RLV_PRESENT=FALSE' "${outputStep7_next}" >> "${outputStep8_2}"

cat "${outputStep8_2}" | grep -v '^#' | wc -l > "${name}.step8_2.count"

##
### STEP 8.2.2 Coding effect (SHARED STEP)
##
popFreqArray=()

echo "step 8.2.2: check if there is a coding effect"
outputStep8_2_2ToPopFreq="${name}.step8_2_2.CodingEffect.vcf"
outputStep8_2_2_next="${name}.step8_2_2.noCodingEffect.vcf"
## write headers
grep '^#' "${outputStep8_2}" > "${outputStep8_2_2_next}"
grep -v '^#' "${outputStep8_2}" | grep -E -v 'start_lost|stop_gained|frameshift_variant|inframe' >> "${outputStep8_2_2_next}"

size8_2=$(cat "${outputStep8_2}" | wc -l)
size8_2_2_next=$(cat "${outputStep8_2_2_next}" | wc -l)

if [ "${size8_2_2_next}" != "${size8_2}" ]
then
	grep '^#' "${outputStep8_2}" > "${outputStep8_2_2ToPopFreq}"
        grep -v '^#' "${outputStep8_2}" | grep -E 'start_lost|stop_gained|frameshift_variant|inframe' >> "${outputStep8_2_2ToPopFreq}"
	echo "coding effect found"
	popFreqArray+=("--variant ${outputStep8_2_2ToPopFreq}")
else
	echo "8_2_2: size is the same, no coding effect found in variants"
fi

cat "${outputStep8_2_2_next}" | grep -v '^#' | wc -l > "${name}.step8_2_2.count"


#start_lost
#stop_gained
#frameshift_variant
#inframe
##
### STEP 8.2.3 Splice site (-2 / +2)
##
echo "step 8.2.3: check if the splice variant is at -2/+2 "
outputStep8_2_3ToPopFreq="${name}.step8_2_3.Splicesite.vcf"
outputStep8_2_3_end="${name}.step8_2_3.noSplicesite.vcf"

grep '^#' "${outputStep8_2_2_next}" > "${outputStep8_2_3_end}"
grep -v '^#' "${outputStep8_2_2_next}" | grep -v -E 'splice.*HIGH' >> "${outputStep8_2_3_end}"

size8_2_3_end=$(cat "${outputStep8_2_3_end}" | wc -l)

if [ "${size8_2_3_end}" != "${size8_2_2_next}" ]
then
	grep '^#' "${outputStep8_2_2_next}" > "${outputStep8_2_3ToPopFreq}"
        grep -v '^#' "${outputStep8_2_2_next}" | grep -E 'splice.*HIGH' > "${outputStep8_2_3ToPopFreq}"
	echo "splice variant found"
	popFreqArray+=("--variant ${outputStep8_2_3ToPopFreq}")
else
	echo "8_2_3: size is the same, no splice sites found in the variants"
fi

outputStep8_2_4_next="${name}.step8_2_4.mergedSteps.vcf"

echo "${#popFreqArray[@]}"
if [ "${#popFreqArray[@]}" == 1 ]
then
	echo "${popFreqArray[0]}" | awk 'BEGIN {FS=" "}{print $2}'
	outputStep8_2_4_next=$(echo "${popFreqArray[0]}" | awk 'BEGIN {FS=" "}{print $2}')

elif [ "${#popFreqArray[@]}" == 0 ]
then
	echo "skip merging, because there are no coding effects nor splice sites found in the data"
else
	##
	### STEP 8.2.4 merge outputs together
        echo "merging steps 8.2.2 and 8.2.3 together"
        java -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
        -T CombineVariants \
        -R //apps//data//1000G/phase1/human_g1k_v37_phiX.fasta \
        "${popFreqArray[@]}" \
        -o "${outputStep8_2_4_next}" \
        -genotypeMergeOptions UNSORTED

        ##
        ### STEP 8.2.5 Pop freq <0.5% (annotate Homozygous/Hemizygous) (SHARED STEP)
        ##
	echo "Step 8.2.5: check pop frequency below 0.5 percent"
        outputStep8_2_5ToSpecTree="${name}.step8_2_5_AF_lt_point5percent.vcf"
	outputStep8_2_5_end="${name}.step8_2_5_AF_ge_point5percent.vcf"
        gnomADpopFreqCheck "${outputStep8_2_4_next}" "${outputStep8_2_5ToSpecTree}" "${outputStep8_2_5_end}" "0.5"

	cat "${outputStep8_2_5FinalOutput}" | grep -v '^#' | wc -l > "${name}.step8_2_5.count"
	specTreeArray+=("--variant ${outputStep8_2_5oSpecTree}")


fi

##
### STEP 9 MERGE ALL PREVIOUS CONTINUE TO SPEC TREE FILES
##
echo "starting step 9"
outputStep9ToSpecTree="${name}.step9_proceedToSpecTree.vcf"
java -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
   -T CombineVariants \
   -R //apps//data//1000G/phase1/human_g1k_v37_phiX.fasta \
   ${specTreeArray[@]} \
   -o "${outputStep9ToSpecTree}" \
   -genotypeMergeOptions UNSORTED

cat "${outputStep9ToSpecTree}" | grep -v '^#' | wc -l > "${name}.step9.count"


for i in $(ls ${name}*.count)
do
	b=${i%.*} 
	stepName=${b##*.}
	printf "proceded in tree for ${stepName}: "
	cat "${i}"
done

echo "This is the output: ${outputStep9ToSpecTree}"

####################
## STEP 10
### Annotate AR/AD/X-Linked with OMIM/HPO
##



####################
## STEP 11
### CONTINUE TREE
##

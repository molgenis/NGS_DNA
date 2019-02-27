#Parameter mapping
#string project
#string logsDir
#string groupname
#string tmpName



#string intermediateDir
#string externalSampleID
#string manVarListMVL_LB_B
#string manVarListMVL_VUS_LP_P
#string manVarListVKGL_consensus_VUS_LP_P
#string gatkJar
#string bedToolsVersion
#string bcfToolsVersion
#string gatkVersion
#string indexFile
#string gavinOutputFinalMergedRLV
#string inhouseIntervalsDir
#string ngsversion
#string ngsUtilsVersion
#string vcf2Table


### SHARED STEPS (USED MULTIPLE TIMES)

####################
##
## ManVar (inputfile,outputfile)
function manVarCheck(){
input="${1}"
outputOverlap="${2}"
outputNoOverlap="${3}"
manVarList="${4}"

#continue to next step
bedtools intersect -header -v -a "${input}" -b "${manVarList}" > "${outputNoOverlap}.tmp.vcf"

##found back in ManVar = continue to specific tree
bedtools intersect -header -a "${input}" -b "${manVarList}" > "${outputOverlap}.tmp"

grep "^#" "${outputOverlap}.tmp"  > "${outputOverlap}"
grep "^#" "${outputOverlap}.tmp"  > "${outputOverlap}.NoMatchingAlleles.vcf"

while read line
do
	if [[ "${line}" != \#* ]]
	then
		getLine=$(echo "${line}" | awk '{print $1"\t"$2"\t"$4"\t"$5}')
		if grep -q "${getLine}" ${manVarList}.pos.bed
		then
			echo "${line}" >> "${outputOverlap}"
		else
			echo "${line}" >> "${outputOverlap}.NoMatchingAlleles.vcf" 
		fi
	fi
done<"${outputOverlap}.tmp" 
if [[ -f "${outputOverlap}.NoMatchingAlleles.vcf" ]]
then
	manList=$(basename ${manVarList%.*})
	grep -v '^#' "${outputOverlap}.NoMatchingAlleles.vcf" | awk -v manList=${manList} 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,manList":NoMatchingAlleles",$8,$10}' >> ${name}.tagsAndFilters.tsv
fi

##combine overlap and genome check
java -cp ${EBROOTGATK}/${gatkJar} org.broadinstitute.gatk.tools.CatVariants \
   -R ${indexFile} \
   --variant "${outputOverlap}.NoMatchingAlleles.vcf"  \
   --variant "${outputNoOverlap}.tmp.vcf"  \
   -out "${outputNoOverlap}.combined.vcf"  \
   --assumeSorted

##sort vcf
bcftools sort "${outputNoOverlap}.combined.vcf" -O v -o "${outputNoOverlap}"

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
   -o "${outputOverlap}.PASS_Exome_AF_Filter.vcf" \
   --restrictAllelesTo BIALLELIC \
   -sn '${externalSampleID}' \
   -select "vc.hasAttribute('gnomAD_exome_AF_MAX') && (! vc.getAttribute('gnomAD_exome_AF_MAX').equals('.')) && gnomAD_exome_AF_MAX < ${freq}"

##No overlap
java -Xmx2g -jar "${EBROOTGATK}/GenomeAnalysisTK.jar" \
   -R "//apps//data//1000G/phase1/human_g1k_v37_phiX.fasta" \
   -T SelectVariants \
   -V "${input}" \
   -o "${outputNoOverlap}" \
   --restrictAllelesTo BIALLELIC \
   -sn '${externalSampleID}' \
   -select "vc.hasAttribute('gnomAD_exome_AF_MAX') && (! vc.getAttribute('gnomAD_exome_AF_MAX').equals('.')) && gnomAD_exome_AF_MAX >= ${freq}"
grep -v '^#' "${outputNoOverlap}" | awk -v freq=${freq} 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"AF>"freq,$8,$10}' >> ${name}.tagsAndFilters.tsv


##missing in exome, check genome (< freq)
java -Xmx2g -jar "${EBROOTGATK}/GenomeAnalysisTK.jar" \
   -R "//apps//data//1000G/phase1/human_g1k_v37_phiX.fasta" \
   -T SelectVariants \
   -V "${input}" \
   -o "${outputOverlap}.PASS_Genome_AF_Filter.vcf" \
   --restrictAllelesTo BIALLELIC \
   -sn '${externalSampleID}' \
   -select "((! vc.hasAttribute('gnomAD_exome_AF_MAX')) || vc.getAttribute('gnomAD_exome_AF_MAX').equals('.')) && ((! vc.hasAttribute('gnomAD_genome_AF_MAX')) || vc.getAttribute('gnomAD_genome_AF_MAX').equals('.') || gnomAD_genome_AF_MAX < ${freq})"
grep -v '^#' "${outputOverlap}.PASS_Genome_AF_Filter.vcf" | awk -v freq=${freq} 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"GenomeAF<"freq" or NA",$8,$10}' >> ${name}.tagsAndFilters.tsv

##missing in exome, check genome (> freq)
java -Xmx2g -jar "${EBROOTGATK}/GenomeAnalysisTK.jar" \
   -R "//apps//data//1000G/phase1/human_g1k_v37_phiX.fasta" \
   -T SelectVariants \
   -V "${input}" \
   -o "${outputOverlap}.NotPASS_Genome_AF_Filter.vcf" \
   --restrictAllelesTo BIALLELIC \
   -sn '${externalSampleID}' \
   -select "((! vc.hasAttribute('gnomAD_exome_AF_MAX')) || vc.getAttribute('gnomAD_exome_AF_MAX').equals('.')) && ( vc.hasAttribute('gnomAD_genome_AF_MAX') && (! vc.getAttribute('gnomAD_genome_AF_MAX').equals('.')) && gnomAD_genome_AF_MAX > ${freq})"

grep -v '^#' "${outputOverlap}.NotPASS_Genome_AF_Filter.vcf" |  awk -v freq=${freq} 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"GenomeAF>"freq,$8,$10}' >> ${name}.tagsAndFilters.tsv

##combine overlap and genome check
java -cp ${EBROOTGATK}/${gatkJar} org.broadinstitute.gatk.tools.CatVariants \
   -R ${indexFile} \
   --variant "${outputOverlap}.PASS_Exome_AF_Filter.vcf" \
   --variant "${outputOverlap}.PASS_Genome_AF_Filter.vcf" \
   -out "${outputOverlap}.tmp.vcf" \
   --assumeSorted

##sort vcf
bcftools sort "${outputOverlap}.tmp.vcf" -O v -o "${outputOverlap}"
}

i="${externalSampleID}"
module load "${bedToolsVersion}"
################################################################################################
### 1. Pass
	### 1.1 yes
	### 1.2 Genesfilter (set of genes that always should be included)
### 2. Read Depth
	### 2.1 >20x
	### 2.2 >10x ####
		### 2.2.1 ManVar (V/LP/P)
		### 2.2.3 Coding effect
### 3. No HLA
### 4. No MT
### 5. MVL LB/B
### 6. MVL VUS/LP/P Cartegenia
### 7. VKGL Consensus Cartegenia
### 8. RLV Present Cartegenia
	### 8.1 RLV_True
		### 8.1.2 ClinVar
		### 8.1.3 Pop freq <1% (GnomAD) annotate Homozygous/Hemizygous
	### 8.2 RLV_False
		### 8.2.2 Coding effect (frameshift, startloss, stopgain, in-frame
		### 8.2.3 Splice site (-2 / +2)
		### 8.2.4 Pop freq <0.5% (GnomAD) annotate Homozygous/Hemizygous
### 9. Merge all continue to spec tree together
### 10. Annotate AR/AD/X-Linked with OMIM/HPO
### 11. Continue to specific tree
#################################################################################################

##First step is to remove the homozygous reference calls
grep '^#' "${gavinOutputFinalMergedRLV}" > ${gavinOutputFinalMergedRLV%.*}.removed0_0_calls.vcf
grep -v '^#' "${gavinOutputFinalMergedRLV}" | grep -v '0/0:' >> ${gavinOutputFinalMergedRLV%.*}.removed0_0_calls.vcf

input=${gavinOutputFinalMergedRLV%.*}.removed0_0_calls.vcf

name=${gavinOutputFinalMergedRLV%.GAVIN.rlv.vcf}

rm -f ${name}.tagsAndFilters.tsv
rm -f ${name}.step*.count

COUNTARRAY=()
count_0=$(cat "${input}" | wc -l)
COUNTARRAY+=("starting with ${count_0}")

outputStep1_next="${name}.step1_nextOne.vcf"

##
### STEP 1: PASS filter
##

outputStep1="${name}.PASS.vcf"
grep '^#' "${input}" | cat > "${outputStep1}"

grep '^#' "${input}" | cat > "${name}.notPASS.vcf"
grep -v '^#' "${name}.notPASS.vcf" | awk '{print $1,$2,$4,$5,"NOT PASS",$8,$10}' >> ${name}.tagsAndFilters.tsv

##PASS
grep -v '^#' "${input}" | grep 'PASS' | cat  >> "${outputStep1}"
## NO PASS
grep -v '^#' ${input} | grep -v 'PASS' | cat >> "${name}.notPASS.vcf"

##
###STEP 1.1 GENEFILTER
##
############# TO BE IMPLEMENTED #############
### input ${name}.notPASS.vcf
### output "${outputStep1_1}"

### 1.2 merge all variants that continue the tree
## "${outputStep1}" "${outputStep1_1}" > ${outputFinalStep1}
cat "${outputStep1}" > "${outputStep1_next}"

count_1_true=$(cat "${outputStep1_next}" | grep -v '^#' | wc -l | cat)
count_1_false=$((count_0 - count_1_true))

COUNTARRAY+=("step 1(PASS FILTER); TRUE:${count_1_true},FALSE:${count_1_false}")

##
### Step 2.1 Read Depth > 20x 2.2 Read Depth >10x ####
##
outputStep2_next="${name}.step2_next.vcf"
outputStep2_1="${name}.step2_1.moreThan20x.vcf"
outputStep2_2_0="${name}.step2_2.moreThan10x.vcf"
outputStep2_2_0_end="${name}.step2_2.lessThan10x.vcf"
ml ${gatkVersion}
ml ${bcfToolsVersion}

 java -Xmx2g -jar "${EBROOTGATK}/${gatkJar}" \
   -R "${indexFile}" \
   -T SelectVariants \
   -V "${outputStep1_next}" \
   -o "${outputStep2_1}" \
   -sn '${externalSampleID}' \
   -select "DP >= 20.0"


count_2_1_true=$(cat "${outputStep2_1}" | grep -v '^#' | cat | wc -l)
count_2_1_false=$((count_1_true - count_2_1_true))
COUNTARRAY+=("step 2.1(Read depth > 20); TRUE:${count_2_1_true},FALSE:${count_2_1_false}")
java -Xmx2g -jar "${EBROOTGATK}/${gatkJar}" \
   -R "${indexFile}" \
   -T SelectVariants \
   -V "${outputStep1_next}" \
   -o "${outputStep2_2_0}" \
   -sn '${externalSampleID}' \
   -select "DP >= 10.0 && DP < 20.0"

grep -v '^#' "${outputStep2_2_0}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,">10x<20x",$8,$10}' >> ${name}.tagsAndFilters.tsv

###
java -Xmx2g -jar "${EBROOTGATK}/${gatkJar}" \
   -R "${indexFile}" \
   -T SelectVariants \
   -V "${outputStep1_next}" \
   -o "${outputStep2_2_0_end}" \
   -sn '${externalSampleID}' \
   -select "DP < 10.0"

grep -v '^#' "${outputStep2_2_0_end}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"<10x",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_2_2_0_true=$(cat "${outputStep2_2_0}" | grep -v '^#' | cat | wc -l)
count_2_2_0_false=$((count_1_true - count_2_2_0_true))

COUNTARRAY+=("step 2.2(Read depth > 10 && < 20); TRUE:${count_2_2_0_true}")

### 2.2.1 ManVar (V/LP/P) (SHARED STEP)
outputStep2_2_1_next="${name}.step2_2_1.manVar_No_V_LP_P.vcf"
outputStep2_2_1_nextHLA="${name}.step2_2_1.manVar_V_LP_P.vcf"

manVarCheck "${outputStep2_2_0}" "${outputStep2_2_1_nextHLA}" "${outputStep2_2_1_next}" "${manVarListMVL_VUS_LP_P}"

grep -v '^#' "${outputStep2_2_1_nextHLA}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"V/LP/P",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_2_2_1_true=$(cat "${outputStep2_2_1_nextHLA}" | grep -v '^#' | wc -l | cat)
count_2_2_1_false=$(cat "${outputStep2_2_1_next}" | grep -v '^#' | wc -l | cat)
COUNTARRAY+=("Step 2.2.1(> 10 <20x AND VUS/LP/P; TRUE: ${count_2_2_1_true}, FALSE:${count_2_2_1_false}")

### 2.2.3 Coding effect (SHARED STEP)
outputStep2_2_3_end="${name}.step2_2_3.noCodingEffect.vcf"
outputStep2_2_3_nextHLA="${name}.step2_2_3.codingEffect.vcf"

grep '^#' "${outputStep2_2_1_next}" | cat > "${outputStep2_2_3_nextHLA}"
grep '^#' "${outputStep2_2_1_next}" | cat > "${outputStep2_2_3_end}"
grep -v '^#' "${outputStep2_2_1_next}" | grep -v -E 'start_lost|stop_gained|frameshift_variant|inframe' | cat >> "${outputStep2_2_3_end}"
grep -v '^#' "${outputStep2_2_1_next}" | grep -E 'start_lost|stop_gained|frameshift_variant|inframe' | cat >> "${outputStep2_2_3_nextHLA}"

grep -v '^#' "${outputStep2_2_3_nextHLA}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"coding",$8,$10}' >> ${name}.tagsAndFilters.tsv
grep -v '^#' "${outputStep2_2_3_end}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"noCoding",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_2_2_3_true=$(cat "${outputStep2_2_3_nextHLA}" | grep -v '^#' |  wc -l | cat)
count_2_2_3_false=$((count_2_2_1_false - count_2_2_3_true))
COUNTARRAY+=("Step 2.2.3(> 10 <20x AND Coding Effect); TRUE: ${count_2_2_3_true}, FALSE:${count_2_2_3_false}")

### 2.2.4 merge all variants that continue the tree
#echo "${outputStep2_1}" "${outputStep2_2_1_overlap}" outputStep2_2_2_overlap outputStep2_2_3_overlap > "${outputFinalStep2}"
java -cp ${EBROOTGATK}/${gatkJar} org.broadinstitute.gatk.tools.CatVariants \
   -R ${indexFile} \
   --variant "${outputStep2_1}" \
   --variant "${outputStep2_2_1_nextHLA}" \
   --variant "${outputStep2_2_3_nextHLA}" \
   -out "${outputStep2_next}.tmp.vcf" \
   --assumeSorted

bcftools sort ${outputStep2_next}.tmp.vcf -O v -o ${outputStep2_next}

count_2_true=$(cat "${outputStep2_next}" | grep -v '^#' | wc -l | cat)
count_2_false=$((count_1_true - count_2_true))
COUNTARRAY+=("Step 2(Read Depth); TRUE: ${count_2_true}, FALSE:${count_2_false}")

##
### STEP 3: No HLA
##
outputStep3_next="${name}.step3_noHLA.vcf"
outputStep3_end="${name}.step3_HLA.vcf"
echo "starting step 3: No HLA check"
grep '^#' "${outputStep2_next}" | cat > "${outputStep3_next}"
grep '^#' "${outputStep2_next}" | cat > "${outputStep3_end}"
grep -v '^#' "${outputStep2_next}"  | grep -v 'HLA-D' | cat >> "${outputStep3_next}"
grep -v '^#' "${outputStep2_next}"  | grep 'HLA-D' | cat >> "${outputStep3_end}"

grep -v '^#' "${outputStep3_end}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"HLA",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_3_true=$(cat "${outputStep3_next}" | grep -v '^#' |  wc -l | cat)
count_3_false=$((count_2_true - count_3_true))
COUNTARRAY+=("Step 3(No HLA region); TRUE: ${count_3_true}, FALSE:${count_3_false}")

##
### STEP 4: NO MT
##
outputStep4_next="${name}.step4_noMT.vcf"
outputStep4_end="${name}.step4_MT.vcf"
echo "starting step 4: No MT check"
grep '^#' "${outputStep3_next}" | cat > "${outputStep4_next}"
grep '^#' "${outputStep3_next}" | cat > "${outputStep4_end}"
grep -v '^#' "${outputStep3_next}" | cat |  awk '{if ($1 != "MT"){print $0}}' >> "${outputStep4_next}"
grep -v '^#' "${outputStep3_next}" | cat |  awk '{if ($1 == "MT"){print $0}}' >> "${outputStep4_end}"

grep -v '^#' "${outputStep4_end}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"MT",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_4_true=$(cat "${outputStep4_next}" | grep -v '^#' | wc -l | cat)
count_4_false=$((count_3_true - count_4_true))
COUNTARRAY+=("Step 4(No MT region); TRUE: ${count_4_true}, FALSE:${count_4_false}")

##
### STEP 5: check if LB/B in MVL
##
outputStep5_next="${name}.step5.NoOverlapWith_MVL_LB-B.vcf"
outputStep5_end="${name}.step5.overlapWith_MVL_LB-B.vcf"

manVarCheck "${outputStep4_next}" "${outputStep5_end}" "${outputStep5_next}" "${manVarListMVL_LB_B}"
echo "step 5 done: ${outputStep5_next}"

grep -v '^#' "${outputStep5_end}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"MVL:LB/B",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_5_true=$(cat "${outputStep5_next}" | grep -v '^#' | wc -l | cat)
count_5_false=$(cat "${outputStep5_end}" | wc -l)
COUNTARRAY+=("Step 5(Not LB/B in MVL); TRUE: ${count_5_true}, FALSE:${count_5_false}")

specTreeArray=()

##
### STEP 6: check if VOUS/LP/P in MVL 
##
outputStep6_next="${name}.step6.NoOverlapWith_MVL_VUS-LP-P.vcf"
outputStep6ToSpecTree="${name}.step6.overlapWith_MVL_VUS-LP-P.vcf"

manVarCheck "${outputStep5_next}" "${outputStep6ToSpecTree}" "${outputStep6_next}" "${manVarListMVL_VUS_LP_P}"
specTreeArray+=("--variant ${outputStep6ToSpecTree}")
echo "step 6 done: ${outputStep6_next}"

grep -v '^#' "${outputStep6ToSpecTree}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"V/LP/P",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_6_true=$(cat "${outputStep6ToSpecTree}" | grep -v '^#' | wc -l | cat)
count_6_false=$(cat "${outputStep6_next}" | wc -l)
COUNTARRAY+=("Step 6(VUS/LP/P in MVL); TRUE: ${count_6_true} (proceed to end of tree), FALSE:${count_6_false}")

##
### STEP 7: check if VOUS/LP/P in VKGL consensus
##
outputStep7_next="${name}.step7.NoOverlapWith_VKGL_consensus_VUS-LP-P.vcf"
outputStep7ToSpecTree="${name}.step7.overlapWith_VKGL_consensus_VUS-LP-P.vcf"

manVarCheck "${outputStep6_next}" "${outputStep7ToSpecTree}" "${outputStep7_next}" "${manVarListVKGL_consensus_VUS_LP_P}"
specTreeArray+=("--variant ${outputStep7ToSpecTree}")
echo "step 7 done: ${outputStep7_next}"

grep -v '^#' "${outputStep7ToSpecTree}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"VKGL:V/LP/P",$8,$10}' >> ${name}.tagsAndFilters.tsv

count_7_true=$(cat "${outputStep7ToSpecTree}" | grep -v '^#' | wc -l | cat)
count_7_false=$(cat "${outputStep7_next}" | wc -l)
COUNTARRAY+=("Step 7(VUS/LP/P in VKGL Cons); TRUE: ${count_7_true} (proceed to end of tree), FALSE:${count_7_false}")

## STEP 8.1 RLV TRUE / 8.2 FALSE
outputStep8ToSpecTree="${name}.step8.vcf"
outputStep8_1_0="${name}.step8.RLV_TRUE.vcf"
outputStep8_2_0="${name}.step8.RLV_FALSE.vcf"
echo "starting step 8: RLV PRESENT"
grep '^#' "${outputStep7_next}" > "${outputStep8_1_0}"
grep '^#' "${outputStep7_next}" > "${outputStep8_2_0}"

rlvTrue="true"
if grep -q 'RLV_PRESENT=TRUE' "${outputStep7_next}"
then
	grep 'RLV_PRESENT=TRUE' "${outputStep7_next}" >> "${outputStep8_1_0}"

	grep -v '^#' "${outputStep8_1_0}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"TRUE",$8,$10}' >> ${name}.tagsAndFilters.tsv

	count_8_1_0_true=$(cat "${outputStep8_1_0}" | grep -v '^#' | wc -l | cat)
	COUNTARRAY+=("Step 8_1_0(Gavin, RLV_PRESENT=TRUE); TRUE: ${count_8_1_0_true}")

	##
	### STEP 8.1.2 ClinVar pathogenic/likely pathogenic
	##
	echo "step 8.1.2: ClinVar pathogenic/likely pathogenic"

	outputStep8_1_2ToSpecTree="${name}.step8_1_2.pathogenic.vcf"
	outputStep8_1_2_next="${name}.step8_1_2.notPathogenic.vcf"

	grep '^#' "${outputStep8_1_0}" | cat > "${outputStep8_1_2ToSpecTree}"
	grep '^#' "${outputStep8_1_0}" | cat > "${outputStep8_1_2_next}"

	grep -v '^#' "${outputStep8_1_0}" | grep -E 'clinvar_sig=Pathogenic|Reported_pathogenic|clinvar_sig=Pathogenic/Likely_pathogenic|clinvar_sig=Likely_pathogenic' | cat >> "${outputStep8_1_2ToSpecTree}"
	grep -v '^#' "${outputStep8_1_0}" | grep -v -E 'clinvar_sig=Pathogenic|Reported_pathogenic|clinvar_sig=Pathogenic/Likely_pathogenic|clinvar_sig=Likely_pathogenic' | cat >> "${outputStep8_1_2_next}"

	grep -v '^#' "${outputStep8_1_2ToSpecTree}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"(likely)pathogenic",$8,$10}' >> ${name}.tagsAndFilters.tsv

	specTreeArray+=("--variant ${outputStep8_1_2ToSpecTree}")

	count_8_1_2_true=$(cat "${outputStep8_1_2ToSpecTree}" | grep -v '^#' | wc -l | cat)
	count_8_1_2_false=$(cat "${outputStep8_1_2_next}" | wc -l)
	COUNTARRAY+=("Step 8_1_2(GAVIN=TRUE, ClinVar=Pathogenic); TRUE: ${count_8_1_2_true} (proceed to end of tree), FALSE:${count_8_1_2_false}")

	##
	### STEP 8.1.3 Pop freq <1% (GnomAD) annotate Homozygous/Hemizygous (SHARED STEP)
	##
	echo "Step 8.1.3: check pop frequency below 1 percent"
	outputStep8_1_3ToSpecTree="${name}.step8_2_5_AF_lt_1percent.vcf"
	outputStep8_1_3_end="${name}.step8_1_3_AF_ge_1percent.vcf"

	gnomADpopFreqCheck "${outputStep8_1_2_next}" "${outputStep8_1_3ToSpecTree}" "${outputStep8_1_3_end}" "0.01"
	specTreeArray+=("--variant ${outputStep8_1_3ToSpecTree}")

        count_8_1_3_true=$(cat "${outputStep8_1_3ToSpecTree}" | grep -v '^#' | wc -l | cat)
        count_8_1_3_false=$((count_8_1_2_false - count_8_1_3_true))
        COUNTARRAY+=("Step 8_1_3(GAVIN=TRUE, PopFreq < 1%); TRUE: ${count_8_1_3_true} (proceed to end of tree), FALSE:${count_8_1_3_false}")

else
	echo "there are no variants with RLV_PRESENT=TRUE"
        rlvTrue="false"
fi


grep 'RLV_PRESENT=FALSE' "${outputStep7_next}" | cat >> "${outputStep8_2_0}"
grep -v '^#' "${outputStep8_2_0}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"FALSE",$8,$10}' >> ${name}.tagsAndFilters.tsv
count_8_2_0_true=$(cat "${outputStep8_2_0}" | grep -v '^#' | wc -l | cat)
COUNTARRAY+=("Step 8_2_0(Gavin, RLV_PRESENT=FALSE); TRUE: ${count_8_2_0_true}")
##
### STEP 8.2.2 Coding effect (SHARED STEP)
##
#start_lost
#stop_gained
#frameshift_variant
#inframe

popFreqArray=()

echo "step 8.2.2: check if there is a coding effect"
outputStep8_2_2ToPopFreq="${name}.step8_2_2.CodingEffect.vcf"
outputStep8_2_2_next="${name}.step8_2_2.noCodingEffect.vcf"
## write headers
grep '^#' "${outputStep8_2_0}" | cat > "${outputStep8_2_2_next}"
grep -v '^#' "${outputStep8_2_0}" | grep -E -v 'start_lost|stop_gained|frameshift_variant|inframe' | cat >> "${outputStep8_2_2_next}"

size8_2_0=$(cat "${outputStep8_2_0}" | wc -l)
size8_2_2_next=$(cat "${outputStep8_2_2_next}" | wc -l)

if [ "${size8_2_2_next}" == "${size8_2_0}" ]
then
	echo "8_2_2: size is the same, no coding effect found in variants"
	count_8_2_2_false=${count_8_2_0_true}
	COUNTARRAY+=("Step 8_2_2(GAVIN=FALSE, Coding Effect); TRUE: 0, FALSE:${count_8_2_2_false}")
else
	grep '^#' "${outputStep8_2_0}" | cat > "${outputStep8_2_2ToPopFreq}"
        grep -v '^#' "${outputStep8_2_0}" | grep -E 'start_lost|stop_gained|frameshift_variant|inframe' | cat >> "${outputStep8_2_2ToPopFreq}"
	grep -v '^#' "${outputStep8_2_2ToPopFreq}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"coding",$8,$10}' >> ${name}.tagsAndFilters.tsv
	echo "coding effect found"
	popFreqArray+=("--variant ${outputStep8_2_2ToPopFreq}")

	count_8_2_2_true=$(cat "${outputStep8_2_2ToPopFreq}" | grep -v '^#' | wc -l | cat)
	count_8_2_2_false=$(cat ${outputStep8_2_2_next} | grep -v '^#' | wc -l | cat)
	COUNTARRAY+=("Step 8_2_2(GAVIN=FALSE, Coding Effect); TRUE: ${count_8_2_2_true}(proceed to pop freq), FALSE:${count_8_2_2_false}")

fi

##
### STEP 8.2.3 Splice site (-2 / +2)
##
echo "step 8.2.3: check if the splice variant is at -2/+2 "
outputStep8_2_3ToPopFreq="${name}.step8_2_3.Splicesite.vcf"
outputStep8_2_3_end="${name}.step8_2_3.noSplicesite.vcf"

grep '^#' "${outputStep8_2_2_next}" | cat  > "${outputStep8_2_3_end}"
grep -v '^#' "${outputStep8_2_2_next}" | grep -v -E 'splice.*HIGH' | cat >> "${outputStep8_2_3_end}"

size8_2_3_end=$(cat "${outputStep8_2_3_end}" | wc -l)

if [ "${size8_2_3_end}" == "${size8_2_2_next}" ]
then
	echo "8_2_3: size is the same, no splice sites found in the variants"
	count_8_2_3_false=${count_8_2_2_false}
	COUNTARRAY+=("Step 8_2_2(GAVIN=FALSE, Coding Effect); TRUE: 0, FALSE:${count_8_2_3_false}")
else
	grep '^#' "${outputStep8_2_2_next}" | cat > "${outputStep8_2_3ToPopFreq}"
        grep -v '^#' "${outputStep8_2_2_next}" | grep -E 'splice.*HIGH' | cat >> "${outputStep8_2_3ToPopFreq}"
	echo "splice variant found"
	popFreqArray+=("--variant ${outputStep8_2_3ToPopFreq}")
	grep -v '^#' "${outputStep8_2_3_end}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"NoSplice",$8,$10}' >> ${name}.tagsAndFilters.tsv
	grep -v '^#' "${outputStep8_2_3ToPopFreq}" | awk 'BEGIN {OFS="\t"}{print $1,$2,$4,$5,"splice",$8,$10}' >> ${name}.tagsAndFilters.tsv

        count_8_2_3_true=$(cat "${outputStep8_2_3ToPopFreq}" | grep -v '^#' | wc -l | cat)
        count_8_2_3_false=$(cat "${outputStep8_2_3_end}" | grep -v '^#' | wc -l | cat)
        COUNTARRAY+=("Step 8_2_3(GAVIN=FALSE, Splice site); TRUE: ${count_8_2_3_true}(proceed to pop freq), FALSE:${count_8_2_3_false}")
fi

echo "${#popFreqArray[@]}"
if [ "${#popFreqArray[@]}" == 0 ]
then
	echo "skip merging, because there are no coding effects nor splice sites found in the data"

else
	outputStep8_2_4_next="${name}.step8_2_4.mergingPrevSteps.vcf"
	if [ "${#popFreqArray[@]}" == 1 ]
	then
		echo "${popFreqArray[0]}" | awk 'BEGIN {FS=" "}{print $2}'
		outputStep8_2_4_next=$(echo "${popFreqArray[0]}" | awk 'BEGIN {FS=" "}{print $2}')

	else
		##
		### STEP 8.2.4 merge outputs together
		echo "merging steps 8.2.2 and 8.2.3 together"
		java -cp ${EBROOTGATK}/${gatkJar} org.broadinstitute.gatk.tools.CatVariants \
		-R ${indexFile} \
		${popFreqArray[@]} \
		-out "${outputStep8_2_4_next}.tmp.vcf" \
		--assumeSorted

		bcftools sort ${outputStep8_2_4_next}.tmp.vcf -O v -o ${outputStep8_2_4_next}
	fi
	##
        ### STEP 8.2.5 Pop freq <0.5% (annotate Homozygous/Hemizygous) (SHARED STEP)
        ##
	count_8_2_4_true=$(cat "${outputStep8_2_4_next}" | grep -v '^#' | wc -l | cat)
	COUNTARRAY+=("Step 8_2_4(GAVIN=FALSE, Merging previous steps); TRUE: ${count_8_2_4_true}")

	echo "Step 8.2.5: check pop frequency below 0.5 percent"
        outputStep8_2_5ToSpecTree="${name}.step8_2_5_AF_lt_point5percent.vcf"
	outputStep8_2_5_end="${name}.step8_2_5_AF_ge_point5percent.vcf"
        gnomADpopFreqCheck "${outputStep8_2_4_next}" "${outputStep8_2_5ToSpecTree}" "${outputStep8_2_5_end}" "0.005"

	count_8_2_5_true=$(cat "${outputStep8_2_5ToSpecTree}" | grep -v '^#' | wc -l | cat)
        count_8_2_5_false=$(cat "${outputStep8_2_5_end}" | grep -v '^#' | wc -l | cat)
        COUNTARRAY+=("Step 8_2_5(GAVIN=FALSE, Pop Freq < 0.5%); TRUE: ${count_8_2_5_true}(proceed to end of tree), FALSE:${count_8_2_5_false}")

	specTreeArray+=("--variant ${outputStep8_2_5ToSpecTree}")

fi

##
### STEP 9 MERGE ALL PREVIOUS CONTINUE TO SPEC TREE FILES
##
echo "starting step 9"
outputStep9="${name}.step9.vcf"
outputStep9_1ToSpecTree="${name}.step9_filteredOnTargets.proceedToSpecTree.vcf"
java -cp ${EBROOTGATK}/${gatkJar} org.broadinstitute.gatk.tools.CatVariants \
   -R //apps//data//1000G/phase1/human_g1k_v37_phiX.fasta \
   ${specTreeArray[@]} \
   -out "${outputStep9}.tmp.vcf" \
   --assumeSorted

bcftools sort ${outputStep9}.tmp.vcf -O v -o ${outputStep9}

for i in "${COUNTARRAY[@]}"
do
	echo "${i}"
done

#echo "outputstep1: ${outputStep1_next}"
#echo "outputstep2_1: ${outputStep2_1}"
#echo "outputstep2_2_0: ${outputStep2_2_0}"
#echo "outputStep2_2_3_nextHLA: ${outputStep2_2_3_nextHLA}"
#echo "outputStep2_2_3_end: ${outputStep2_2_3_end}"
#echo "outputStep2_next: ${outputStep2_next}"
#echo "outputStep3_next: ${outputStep3_next}"
#echo "outputStep4_next: ${outputStep4_next}"
#echo "outputStep5_next: ${outputStep5_next}"
#echo "outputStep5_end: ${outputStep5_end}"
#echo "outputStep6ToSpecTree: ${outputStep6ToSpecTree}"
#echo "outputStep6_next: ${outputStep6_next}"
#echo "outputStep7ToSpecTree: ${outputStep7ToSpecTree}"
#echo "outputStep7_next: ${outputStep7_next}"
#echo "outputStep8_1_0: ${outputStep8_1_0}"
#echo "outputStep8_1_2ToSpecTree: ${outputStep8_1_2ToSpecTree}"
#echo "outputStep8_1_2_next: ${outputStep8_1_2_next}"
#echo "outputStep8_1_3ToSpecTree: ${outputStep8_1_3ToSpecTree}"
#echo "outputStep8_1_3_end: ${outputStep8_1_3_end}
#echo "outputStep8_2_0: ${outputStep8_2_0}"
#echo "outputStep8_2_2ToPopFreq: ${outputStep8_2_2ToPopFreq}"
#echo "outputStep8_2_2_next: ${outputStep8_2_2_next}"
#echo "outputStep8_2_3ToPopFreq: ${outputStep8_2_3ToPopFreq}"
#echo "outputStep8_2_3_end: ${outputStep8_2_3_end}"
#echo "outputStep8_2_4_next: ${outputStep8_2_4_next}"
#echo "outputStep8_2_5ToSpecTree: ${outputStep8_2_5ToSpecTree}"
#echo "outputStep8_2_5_end: ${outputStep8_2_5_end}
#echo "outputStep9: ${outputStep9}"
echo "This is the final output: ${outputStep9_1ToSpecTree}"

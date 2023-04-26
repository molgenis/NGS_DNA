### Parameters
#string project
#string logsDir 
#string groupname
#string arrayFileLocation
#string arrayID
#string intermediateDir
#string sampleConcordanceFile
#string familyList
#string ngsUtilsVersion
#string arrayTmpMap
#string arrayMapFile
#string plink1Version
#string plink2Version
#string bedToolsVersion
#string externalSampleID
#string capturedExomeBed
#string htsLibVersion
#string indexFile
#string internalSampleID
#string gatkVersion
#string samplePrefix

###################################################################################

###Start protocol


if test ! -e ${arrayFileLocation};
then
	echo "name, step, nSNPs, PercDbSNP, Ti/Tv_known, Ti/Tv_Novel, All_comp_het_called_het, Known_comp_het_called_het, Non-Ref_Sensitivity, Non-Ref_discrepancy, Overall_concordance" > ${sampleConcordanceFile}
	echo "[1] NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA" >> ${sampleConcordanceFile}
else
	#Check finalReport on "missing" alleles. Also, see if we can fix missing alleles somewhere in GenomeStudio
	awk '{ if ($3 != "-" || $4 != "-") print $0};' ${arrayFileLocation} \
	> ${samplePrefix}.FinalReport.txt.tmp
	
	#Check finalreport on "D"alleles.
	awk '{ if ($3 != "D" || $4 != "D") print $0};' ${samplePrefix}.FinalReport.txt.tmp \
	> ${samplePrefix}.FinalReport_2.txt.tmp
	
	#Push sample belonging to family "1" into list.txt
	echo 1 ${arrayID} > ${familyList}
	
	#########################################################################
	#########################################################################
	
	module load ${ngsUtilsVersion}
	
	##Create .fam, .lgen and .map file from sample_report.txt
	sed -e '1,10d' ${samplePrefix}.FinalReport_2.txt.tmp | awk '{print "1",$2,"0","0","0","1"}' | uniq > ${samplePrefix}.concordance.fam
	sed -e '1,10d' ${samplePrefix}.FinalReport_2.txt.tmp | awk '{print "1",$2,$1,$3,$4}' | awk -f $EBROOTNGSMINUTILS/RecodeFRToZero.awk > ${samplePrefix}.concordance.lgen
	sed -e '1,10d' ${samplePrefix}.FinalReport_2.txt.tmp | awk '{print $6,$1,"0",$7}' OFS="\t" | sort -k1n -k4n | uniq > ${arrayTmpMap}
	grep -P '^[123456789]' ${arrayTmpMap} | sort -k1n -k4n > ${arrayMapFile}
	grep -P '^[X]\s' ${arrayTmpMap} | sort -k4n >> ${arrayMapFile}
	grep -P '^[Y]\s' ${arrayTmpMap} | sort -k4n >> ${arrayMapFile}
	
	#####################################
	##Create .bed and other files (keep sample from sample_list.txt).
	
	##Create .bed and other files (keep sample from sample_list.txt).
	
	module load ${plink1Version}
	module list
	
	plink \
	--lfile ${samplePrefix}.concordance \
	--recode \
	--noweb \
	--out  ${samplePrefix}.concordance \
	--keep ${familyList}
	
	module unload plink
	module load ${plink2Version}
	module list
	
	##Create genotype VCF for sample
	plink \
	--recode vcf-iid \
	--ped ${samplePrefix}.concordance.ped \
	--map ${arrayMapFile} \
	--out ${samplePrefix}.concordance
	
	##Rename plink.vcf to sample.vcf
	mv ${samplePrefix}.concordance.vcf ${samplePrefix}.genotypeArray.vcf
	
	##Replace chr23 and 24 with X and Y
	perl -pi -e 's/^23/X/' ${samplePrefix}.genotypeArray.vcf
	perl -pi -e 's/^24/Y/' ${samplePrefix}.genotypeArray.vcf
	
	##Create binary ped (.bed) and make tab-delimited .fasta file for all genotypes
	sed -e 's/chr//' ${samplePrefix}.genotypeArray.vcf | awk '{OFS="\t"; if (!/^#/){print $1,$2-1,$2}}' \
	> ${samplePrefix}.genotypeArray.bed
	
	#Remove SNP`s from array which are not in a exon with the exon bedfile
	module load ${bedToolsVersion}
	bedtools intersect -a ${samplePrefix}.genotypeArray.vcf -b ${capturedExomeBed} -header  >${samplePrefix}.genotypeArray.ExonFiltered.vcf
	
	
	#Remove SNP's from array which are called homozygous reference
	awk '{ if ($10!= "0/0") print $0};' ${samplePrefix}.genotypeArray.ExonFiltered.vcf \
	> ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.vcf
	
	#Count how much SNP's are in original VCF and how much proceed for Concordance
	wc -l ${samplePrefix}.genotypeArray.vcf > ${samplePrefix}.originalSNPs.txt
	wc -l ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.vcf > ${samplePrefix}.SNPswichproceedtoConcordance.txt
	
	#Change Array VCF to same name as NGS VCF
	awk '{OFS="\t"}{if ($0 ~ "#CHROM" ){ print $1,$2,$3,$4,$5,$6,$7,$8,$9,"'${internalSampleID}'"} else {print $0}}' ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.vcf  > ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf
	
	
	#Making Array VCF index
	
	module load ${htsLibVersion}
	bgzip -c ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf > ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf.gz
	tabix -p vcf ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf.gz
	
	#Removing small indels from NGS VCF
	
	module load ${gatkVersion}
	module list
	
	java -Xmx4g -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
	-T SelectVariants \
	-R ${indexFile} \
	-V ${intermediateDir}/${externalSampleID}.final.vcf \
	-o ${samplePrefix}.onlySNPs.FINAL.vcf \
	-selectType SNP
	
	### Comparing VCF From NGS with Array data
	
	module list
	
	java -Xmx4g -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
	-T GenotypeConcordance \
	-R ${indexFile} \
	-eval ${samplePrefix}.onlySNPs.FINAL.vcf \
	-comp ${samplePrefix}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf \
	-o ${samplePrefix}.GATK.VCF.Concordance.output.grp
	
	
fi

fgrepi -A 2 "#:GATKTable:GenotypeConcordance_Summary" ${samplePrefix}.GATK.VCF.Concordance.output.grp | tail -1 | awk '{print $4}' > ${samplePrefix}.concordance.txt

echo "script finished, data can be found here: ${samplePrefix}.GATK.VCF.Concordance.output.grp"

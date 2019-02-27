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
#string sampleNameID

###################################################################################

###Start protocol


if test ! -e ${arrayFileLocation};
then
	echo "name, step, nSNPs, PercDbSNP, Ti/Tv_known, Ti/Tv_Novel, All_comp_het_called_het, Known_comp_het_called_het, Non-Ref_Sensitivity, Non-Ref_discrepancy, Overall_concordance" > ${sampleConcordanceFile}
	echo "[1] NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA" >> ${sampleConcordanceFile}
else
	#Check finalReport on "missing" alleles. Also, see if we can fix missing alleles somewhere in GenomeStudio
	awk '{ if ($3 != "-" || $4 != "-") print $0};' ${arrayFileLocation} \
	> ${sampleNameID}.FinalReport.txt.tmp
	
	#Check finalreport on "D"alleles.
	awk '{ if ($3 != "D" || $4 != "D") print $0};' ${sampleNameID}.FinalReport.txt.tmp \
	> ${sampleNameID}.FinalReport_2.txt.tmp
	
	#Push sample belonging to family "1" into list.txt
	echo 1 ${arrayID} > ${familyList}
	
	#########################################################################
	#########################################################################
	
	module load ${ngsUtilsVersion}
	
	##Create .fam, .lgen and .map file from sample_report.txt
	sed -e '1,10d' ${sampleNameID}.FinalReport_2.txt.tmp | awk '{print "1",$2,"0","0","0","1"}' | uniq > ${sampleNameID}.concordance.fam
	sed -e '1,10d' ${sampleNameID}.FinalReport_2.txt.tmp | awk '{print "1",$2,$1,$3,$4}' | awk -f $EBROOTNGSMINUTILS/RecodeFRToZero.awk > ${sampleNameID}.concordance.lgen
	sed -e '1,10d' ${sampleNameID}.FinalReport_2.txt.tmp | awk '{print $6,$1,"0",$7}' OFS="\t" | sort -k1n -k4n | uniq > ${arrayTmpMap}
	grep -P '^[123456789]' ${arrayTmpMap} | sort -k1n -k4n > ${arrayMapFile}
	grep -P '^[X]\s' ${arrayTmpMap} | sort -k4n >> ${arrayMapFile}
	grep -P '^[Y]\s' ${arrayTmpMap} | sort -k4n >> ${arrayMapFile}
	
	#####################################
	##Create .bed and other files (keep sample from sample_list.txt).
	
	##Create .bed and other files (keep sample from sample_list.txt).
	
	module load ${plink1Version}
	module list
	
	plink \
	--lfile ${sampleNameID}.concordance \
	--recode \
	--noweb \
	--out  ${sampleNameID}.concordance \
	--keep ${familyList}
	
	module unload plink
	module load ${plink2Version}
	module list
	
	##Create genotype VCF for sample
	plink \
	--recode vcf-iid \
	--ped ${sampleNameID}.concordance.ped \
	--map ${arrayMapFile} \
	--out ${sampleNameID}.concordance
	
	##Rename plink.vcf to sample.vcf
	mv ${sampleNameID}.concordance.vcf ${sampleNameID}.genotypeArray.vcf
	
	##Replace chr23 and 24 with X and Y
	perl -pi -e 's/^23/X/' ${sampleNameID}.genotypeArray.vcf
	perl -pi -e 's/^24/Y/' ${sampleNameID}.genotypeArray.vcf
	
	##Create binary ped (.bed) and make tab-delimited .fasta file for all genotypes
	sed -e 's/chr//' ${sampleNameID}.genotypeArray.vcf | awk '{OFS="\t"; if (!/^#/){print $1,$2-1,$2}}' \
	> ${sampleNameID}.genotypeArray.bed
	
	#Remove SNP`s from array which are not in a exon with the exon bedfile
	module load ${bedToolsVersion}
	bedtools intersect -a ${sampleNameID}.genotypeArray.vcf -b ${capturedExomeBed} -header  >${sampleNameID}.genotypeArray.ExonFiltered.vcf
	
	
	#Remove SNP's from array which are called homozygous reference
	awk '{ if ($10!= "0/0") print $0};' ${sampleNameID}.genotypeArray.ExonFiltered.vcf \
	> ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.vcf
	
	#Count how much SNP's are in original VCF and how much proceed for Concordance
	wc -l ${sampleNameID}.genotypeArray.vcf > ${sampleNameID}.originalSNPs.txt
	wc -l ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.vcf > ${sampleNameID}.SNPswichproceedtoConcordance.txt
	
	#Change Array VCF to same name as NGS VCF
	awk '{OFS="\t"}{if ($0 ~ "#CHROM" ){ print $1,$2,$3,$4,$5,$6,$7,$8,$9,"'${internalSampleID}'"} else {print $0}}' ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.vcf  > ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf
	
	
	#Making Array VCF index
	
	module load ${htsLibVersion}
	bgzip -c ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf > ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf.gz
	tabix -p vcf ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf.gz
	
	#Removing small indels from NGS VCF
	
	module load ${gatkVersion}
	module list
	
	java -Xmx4g -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
	-T SelectVariants \
	-R ${indexFile} \
	-V ${intermediateDir}/${externalSampleID}.final.vcf \
	-o ${sampleNameID}.onlySNPs.FINAL.vcf \
	-selectType SNP
	
	### Comparing VCF From NGS with Array data
	
	module list
	
	java -Xmx4g -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
	-T GenotypeConcordance \
	-R ${indexFile} \
	-eval ${sampleNameID}.onlySNPs.FINAL.vcf \
	-comp ${sampleNameID}.genotypeArray.ExonFiltered.HomozygousRefRemoved.FINAL.vcf \
	-o ${sampleNameID}.GATK.VCF.Concordance.output.grp
	
	
fi

fgrepi -A 2 "#:GATKTable:GenotypeConcordance_Summary" ${sampleNameID}.GATK.VCF.Concordance.output.grp | tail -1 | awk '{print $4}' > ${sampleNameID}.concordance.txt

echo "script finished, data can be found here: ${sampleNameID}.GATK.VCF.Concordance.output.grp"

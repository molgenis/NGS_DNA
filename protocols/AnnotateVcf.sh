#MOLGENIS walltime=05:59:00 mem=6gb ppn=10
#string logsDir
#string groupname
#string project
#string caddAnnotationVcf
#string toCADD
#string fromCADD
#string projectBatchGenotypedVariantCalls
#string projectBatchGenotypedAnnotatedVariantCalls
#string indexFile
#string htsLibVersion
#string vcfAnnoVersion
#string bcfToolsVersion
#string fromCADDMerged
#string vcfAnnoConf
#string caddVersion
#string exacAnnotation

ml ${vcfAnnoVersion}
ml ${htsLibVersion}
ml ${bcfToolsVersion}
ml ${caddVersion}

makeTmpDir "${projectBatchGenotypedAnnotatedVariantCalls}"
tmpProjectBatchGenotypedAnnotatedVariantCalls="${MC_tmpFile}"

if [ -f ${projectBatchGenotypedVariantCalls} ]
then 

	echo "create file toCADD"
	##create file toCADD (split alternative alleles per line)
	bcftools norm -f "${indexFile}" -m -any "${projectBatchGenotypedVariantCalls}" | awk '{if (!/^#/){if (length($4) > 1 || length($5) > 1){print $1"\t"$2"\t"$3"\t"$4"\t"$5}}}' | bgzip -c > "${toCADD}"

	echo "starting to get CADD annotations locally for ${toCADD}"
	score.sh "${toCADD}" "${fromCADD}"

	echo "convert fromCADD tsv file to fromCADD vcf"
	##convert tsv to vcf
	(echo -e '##fileformat=VCFv4.1\n##INFO=<ID=raw,Number=A,Type=Float,Description="raw cadd score">\n##INFO=<ID=phred,Number=A,Type=Float,Description="phred-scaled cadd score">\n##CADDCOMMENT=<ID=comment,comment="CADD v1.3 (c) University of Washington and Hudson-Alpha Institute for Biotechnology 2013-2015. All rights reserved.">\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO' && gzip -dc ${fromCADD}\
	| awk '{if(NR>2){ printf $1"\t"$2"\t.\t"$3"\t"$4"\t1\tPASS\traw="; printf "%0.1f;",$5 ;printf "phred=";printf "%0.1f\n",$6}}') | bgzip -c > "${fromCADD}.vcf.gz"

	tabix -f -p vcf "${fromCADD}.vcf.gz"
	##merge the alternative alleles back in one vcf line
	echo "merging the alternative alleles back in one vcf line .. "
	bcftools norm -f "${indexFile}" -m +any "${fromCADD}.vcf.gz" > "${fromCADDMerged}"

	echo "bgzipping + indexing ${fromCADDMerged}"
	bgzip -c "${fromCADDMerged}" > "${fromCADDMerged}.gz"
	tabix -f -p vcf "${fromCADDMerged}.gz"

	cat > "${vcfAnnoConf}" << HERE
	[[annotation]]
	file="${fromCADDMerged}.gz"
	names=["CADD_SCALED","CADD"]
	fields=["phred", "raw"]
	ops=["self","self"]

	[[annotation]]
	file="${caddAnnotationVcf}"
	names=["CADD_SCALED","CADD"]
	fields=["phred", "raw"]
	ops=["self","self"]

	[[annotation]]
        file="${exacAnnotation}"
        names=["LossOfFunction","EXAC_AF","EXAC_AC_HET","EXAC_AC_HOM"]
        fields=["LoF", "AF","AC_Het","AC_Hom"]
        ops=["self","self","self","self"]
HERE

	echo "starting to annotate with vcfanno"
	vcfanno_linux64 "${vcfAnnoConf}" "${projectBatchGenotypedVariantCalls}" > "${tmpProjectBatchGenotypedAnnotatedVariantCalls}"

	mv "${tmpProjectBatchGenotypedAnnotatedVariantCalls}" "${projectBatchGenotypedAnnotatedVariantCalls}"
	echo "mv ${tmpProjectBatchGenotypedAnnotatedVariantCalls} ${projectBatchGenotypedAnnotatedVariantCalls}" 
else
	echo "${projectBatchGenotypedVariantCalls} does not exist, skipped"
fi

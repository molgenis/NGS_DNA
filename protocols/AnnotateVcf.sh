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
#string gonlAnnotation
#string gnomADGenomesAnnotation
#string gnomADExomesAnnotation
#string capturingKit
#string vcfAnnoGnomadGenomesConf
#string batchID
#string vcfAnnoCustomConfLua
#string projectBatchGenotypedCGDAnnotatedVariantCalls
#string clinvarAnnotation
#string cgdDataDir
#string cgdFile
#string intermediateDir

module load "${vcfAnnoVersion}"
module load "${htsLibVersion}"
module load "${caddVersion}"
module load "${bcfToolsVersion}"
module load "${htsLibVersion}"


makeTmpDir "${projectBatchGenotypedAnnotatedVariantCalls}"
tmpProjectBatchGenotypedAnnotatedVariantCalls="${MC_tmpFile}"

makeTmpDir "${projectBatchGenotypedCGDAnnotatedVariantCalls}"
tmpProjectBatchGenotypedCGDAnnotatedVariantCalls="${MC_tmpFile}"

bedfile=$(basename "${capturingKit}")

if [ -f "${projectBatchGenotypedVariantCalls}" ]
then

	echo "create file toCADD"
	##create file toCADD (split alternative alleles per line)
	bcftools norm -f "${indexFile}" -m -any "${projectBatchGenotypedVariantCalls}" | awk '{if (!/^#/){if (length($4) > 1 || length($5) > 1){print $1"\t"$2"\t"$3"\t"$4"\t"$5}}}' | bgzip -c > "${toCADD}.gz"

	echo "starting to get CADD annotations locally for ${toCADD}.gz"
	score.sh "${toCADD}.gz" "${fromCADD}"

	echo "convert fromCADD tsv file to fromCADD vcf"
	##convert tsv to vcf
	(echo -e '##fileformat=VCFv4.1\n##INFO=<ID=raw,Number=A,Type=Float,Description="raw cadd score">\n##INFO=<ID=phred,Number=A,Type=Float,Description="phred-scaled cadd score">\n##CADDCOMMENT=<ID=comment,comment="CADD v1.3 (c) University of Washington and Hudson-Alpha Institute for Biotechnology 2013-2015. All rights reserved.">\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO' && gzip -dc ${fromCADD}\
	| awk '{if(NR>2){ printf $1"\t"$2"\t.\t"$3"\t"$4"\t1\tPASS\traw="; printf "%0.1f;",$5 ;printf "phred=";printf "%0.1f\n",$6}}') | bgzip -c > "${fromCADD}.vcf.gz"

	# tabix -f -p vcf "${fromCADD}.vcf.gz"
	bcftools index -t -f "${fromCADD}.vcf.gz"
	##merge the alternative alleles back in one vcf line
	echo "merging the alternative alleles back in one vcf line .. "
	bcftools norm -f "${indexFile}" -m +any "${fromCADD}.vcf.gz" > "${fromCADDMerged}"

	echo "bgzipping + indexing ${fromCADDMerged}"
	bgzip -c "${fromCADDMerged}" > "${fromCADDMerged}.gz"
	# tabix -f -p vcf "${fromCADDMerged}.gz"
	bcftools index -t -f "${fromCADDMerged}.gz"


	## Prepare gnomAD config 
	rm -f "${vcfAnnoGnomadGenomesConf}"
	if [[ "${bedfile}" == *"Exoom"* ]]
	then
		if [[ ${batchID} == *"X"* ]]
		then
			echo -e "\n[[annotation]]\nfile=\"${gnomADGenomesAnnotation}/gnomad.genomes.r2.0.2.sites.chrX.normalized.vcf.gz\"\nfields=[\"AF_POPMAX\",\"segdup\"]\nnames=[\"gnomAD_genome_AF_MAX\",\"gnomAD_genome_RF_Filter\"]\nops=[\"self\",\"self\"]" >> "${vcfAnnoGnomadGenomesConf}"
			echo -e "\n[[annotation]]\nfile=\"${gonlAnnotation}/gonl.chrX.release4.gtc.vcf.gz\"\nfields=[\"AC\",\"AN\"]\nnames=[\"GoNL_AC\",\"GoNL_AN\"]\nops=[\"self\",\"first\"]" >> "${vcfAnnoGnomadGenomesConf}"
		elif [[ ${batchID} == *"Y"* || ${batchID} == *"NC_001422.1"* ||  ${batchID} == *"MT"* ]]
		then
			echo "chromosome Y/MT/NC_001422.1 is not in gnomAD, do nothing"
		else
			echo -e "\n[[annotation]]\nfile=\"${gnomADGenomesAnnotation}/gnomad.genomes.r2.0.2.sites.chr${batchID}.normalized.vcf.gz\"\nfields=[\"AF_POPMAX\",\"segdup\"]\nnames=[\"gnomAD_genome_AF_MAX\",\"gnomAD_genome_RF_Filter\"]\nops=[\"self\",\"self\"]" >> "${vcfAnnoGnomadGenomesConf}"
			echo -e "\n[[annotation]]\nfile=\"${gonlAnnotation}/gonl.chrCombined.snps_indels.r5.vcf.gz\"\nfields=[\"AC\",\"AN\"]\nnames=[\"GoNL_AC\",\"GoNL_AN\"]\nops=[\"self\",\"first\"]" >> "${vcfAnnoGnomadGenomesConf}"
		fi
	else
		for i in {1..22}
		do
			echo -e "\n[[annotation]]\nfile=\"${gonlAnnotation}/gonl.chrCombined.snps_indels.r5.vcf.gz\"\nfields=[\"AC\",\"AN\"]\nnames=[\"GoNL_AC\",\"GoNL_AN\"]\nops=[\"self\",\"first\"]" >> "${vcfAnnoGnomadGenomesConf}"
			echo -e "\n[[annotation]]\nfile=\"${gonlAnnotation}/gonl.chrX.release4.gtc.vcf.gz\"\nfields=[\"AC\",\"AN\"]\nnames=[\"GoNL_AC\",\"GoNL_AN\"]\nops=[\"self\",\"first\"]" >> "${vcfAnnoGnomadGenomesConf}"
			echo -e "\n[[annotation]]\nfile=\"${gnomADGenomesAnnotation}/gnomad.genomes.r2.0.2.sites.chr${i}.normalized.vcf.gz\"\nfields=[\"AF_POPMAX\",\"segdup\"]\nnames=[\"gnomAD_genome_AF_MAX\",\"gnomAD_genome_RF_Filter\"]\nops=[\"self\",\"self\"]" >> "${vcfAnnoGnomadGenomesConf}"
		done
	fi

cat > "${vcfAnnoConf}" << HERE

[[annotation]]
file="${caddAnnotationVcf}"
fields=["phred", "raw"]
names=["CADD_SCALED","CADD"]
ops=["self","self"]
HERE

length=$(zcat "${fromCADDMerged}.gz" | wc -l)

if [ "${length}" -gt 8 ]
then

cat >> "${vcfAnnoConf}" << HERE
[[annotation]]
file="${fromCADDMerged}.gz"
fields=["phred", "raw"]
names=["CADD_SCALED","CADD"]
ops=["self","self"]
HERE
fi
	## write first part of conf file
	cat >> "${vcfAnnoConf}" << HERE

#[[annotation]]
#file="${exacAnnotation}"
#fields=["AF","AC_Het","AC_Hom"]
#names=["EXAC_AF","EXAC_AC_HET","EXAC_AC_HOM"]
#ops=["self","self","self"]

[[annotation]]
file="${gnomADExomesAnnotation}/gnomad.exomes.r2.0.2.sites.normalized.vcf.gz"
fields=["Hom","Hemi", "AN","AF_POPMAX","segdup","AF_POPMAX"]
names=["gnomAD_Hom","gnomAD_Hemi","gnomAD_AN","gnomAD_exome_AF_MAX","gnomAD_exome_RF_Filter","EXAC_AF"]
ops=["self","self","first","self","self","self"]

[[annotation]]
file="${gonlAnnotation}/gonl.chrCombined.snps_indels.r5.vcf.gz"
fields=["AC","AN"]
names=["GoNL_AC","GoNL_AN"]
ops=["self","first"]

[[annotation]]
file="${clinvarAnnotation}"
fields=["CLNDN","CLNDISDB","CLNHGVS","CLNSIG"]
names=["clinvar_dn","clinvar_isdb","clinvar_hgvs","clinvar_sig"]
ops=["self","self","self","self"]

[[annotation]]
file="${cgdFile}"
columns = [5, 6, 7, 8, 9, 10]
names=["CGD_Condition","CGD_Inheritance","CGD_AgeGroup","CGD_Manfest_cat","CGD_invent_cat","invent_rat"]
ops=["self","self","self","self","self","self"]

HERE

## Adding gnomAD
if [[ -f "${vcfAnnoGnomadGenomesConf}" ]]
then
	cat "${vcfAnnoGnomadGenomesConf}" >> "${vcfAnnoConf}"
fi
#
## make custom .lua for calculating hom and het frequency
#
cat > "${vcfAnnoCustomConfLua}" << HERE

function calculate_gnomAD_AC(ind)
if(ind[1] == 0) then return "0" end
    return (ind[1] * 2)
end
--clinvar check if pathogenic is common variant in gnomAD
CLINVAR_SIG = {}
CLINVAR_SIG["0"] = 'uncertain'
CLINVAR_SIG["1"] = 'not-provided'
CLINVAR_SIG["2"] = 'benign'
CLINVAR_SIG["3"] = 'likely-benign'
CLINVAR_SIG["4"] = 'likely-pathogenic'
CLINVAR_SIG["5"] = 'pathogenic'
CLINVAR_SIG["6"] = 'drug-response'
CLINVAR_SIG["7"] = 'histocompatibility'
CLINVAR_SIG["255"] = 'other'
CLINVAR_SIG["."] = '.'

function contains(str, tok)
	return string.find(str, tok) ~= nil
end

function intotbl(ud)
	local tbl = {}
	for i=1,#ud do
		tbl[i] = ud[i]
	end
	return tbl
end

function clinvar_sig(vals)
    local t = type(vals)
    -- just a single-value
    if(t == "string" or t == "number") and not contains(vals, "|") then
        return CLINVAR_SIG[vals]
    elseif t ~= "table" then
		if not contains(t, "userdata") then
			vals = {vals}
		else
			vals = intotbl(vals)
		end
    end
    local ret = {}
    for i=1,#vals do
        if not contains(vals[i], "|") then
            ret[#ret+1] = CLINVAR_SIG[vals[i]]
        else
            local invals = vals[i]:split("|")
            local inret = {}
            for j=1,#invals do
                inret[#inret+1] = CLINVAR_SIG[invals[j]]
            end
            ret[#ret+1] = join(inret, "|")
        end
    end
    return join(ret, ",")
end

join = table.concat

HERE

cat >> "${vcfAnnoConf}" << HERE

## Calculating GoNL AF, gnomAD_HOM_AC
[[postannotation]]
fields=["GoNL_AC", "GoNL_AN"]
name="GoNL_AF"
op="div2"
type="Float"

[[postannotation]]
fields=["gnomAD_Hom"]
name="gnomAD_AN_Hom"
op="lua:calculate_gnomAD_AC(gnomAD_Hom)"
type="Integer"

[[postannotation]]
fields=["gnomAD_Hemi"]
name="gnomAD_AN_Hemi"
op="lua:calculate_gnomAD_AC(gnomAD_Hemi)"
type="Integer"

HERE

	echo "starting to annotate with vcfanno"
	vcfanno_linux64 -p 4 -lua "${vcfAnnoCustomConfLua}" "${vcfAnnoConf}" "${projectBatchGenotypedVariantCalls}" > "${tmpProjectBatchGenotypedAnnotatedVariantCalls}"

	mv "${tmpProjectBatchGenotypedAnnotatedVariantCalls}" "${projectBatchGenotypedAnnotatedVariantCalls}"
        echo "mv ${tmpProjectBatchGenotypedAnnotatedVariantCalls} ${projectBatchGenotypedAnnotatedVariantCalls}" 

else
	echo "${projectBatchGenotypedVariantCalls} does not exist, skipped"
fi

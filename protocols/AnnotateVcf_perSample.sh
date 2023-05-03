set -o pipefail
#string logsDir
#string groupname
#string project
#string caddAnnotationVcf
#string toCaddSample
#string fromCaddSample
#string indexFile
#string htsLibVersion
#string vcfAnnoVersion
#string bcfToolsVersion
#string vcfAnnoConfSample
#string vcfAnnoCustomConfLuaSample
#string caddVersion
#string gonlAnnotation
#string gnomADGenomesAnnotation
#string gnomADExomesAnnotation
#string capturingKit
#string vcfAnnoGnomadGenomesConfSample
#string clinvarAnnotation
#string cgdDataDir
#string cgdFile
#string intermediateDir
#string variantCalls
#string sampleGenotypedAnnotatedVariantCalls

module load "${vcfAnnoVersion}"
module load "${htsLibVersion}"
module load "${bcfToolsVersion}"


makeTmpDir "${sampleGenotypedAnnotatedVariantCalls}"
tmpSampleGenotypedAnnotatedVariantCalls="${MC_tmpFile}"

bedfile=$(basename "${capturingKit}")

if [[ ! -f "${variantCalls}" ]]
then

	echo "${variantCalls} does not exist, skipped"

else
	echo "create file toCADD"

	awk '{if (!/^#/){if (length($4) > 1 || length($5) > 1){print $1"\t"$2"\t"$3"\t"$4"\t"$5}}}' "${variantCalls}" | bgzip -c > "${toCaddSample}.gz"
	sizeToCADD=$(zcat "${toCaddSample}.gz" | wc -l)
	if [[ "${sizeToCADD}" == '0' ]]
	then
		echo "nothing to CADD, skip"
	else
		module load "${caddVersion}"
		echo "starting to get CADD annotations locally for ${toCaddSample}.gz"
		CADD.sh -g GRCh37 -o "${fromCaddSample}" "${toCaddSample}.gz" 

		echo "convert fromCaddSample tsv file to fromCaddSample vcf"
		##convert tsv to vcf
		(echo -e '##fileformat=VCFv4.1\n##INFO=<ID=raw,Number=A,Type=Float,Description="raw cadd score">\n##INFO=<ID=phred,Number=A,Type=Float,Description="phred-scaled cadd score">\n##CADDCOMMENT=<ID=comment,comment="CADD v1.3 (c) University of Washington and Hudson-Alpha Institute for Biotechnology 2013-2015. All rights reserved.">\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO' && gzip -dc "${fromCaddSample}"\
			| awk '{if(NR>2){ printf $1"\t"$2"\t.\t"$3"\t"$4"\t1\tPASS\traw="; printf "%0.1f;",$5 ;printf "phred=";printf "%0.1f\n",$6}}') | bgzip -c > "${fromCaddSample%.tsv.gz}.vcf.gz"
		
		tabix -f -p vcf "${fromCaddSample%.tsv.gz}.vcf.gz"

	fi
	## Prepare gnomAD config 
	rm -f "${vcfAnnoGnomadGenomesConfSample}"
	
	#shellcheck disable=SC2129
	echo -e "\n[[annotation]]\nfile=\"${gnomADGenomesAnnotation}/gnomad.genomes.r2.0.2.sites.chrX.normalized.vcf.gz\"\nfields=[\"AF_POPMAX\",\"segdup\"]\nnames=[\"gnomAD_genome_AF_MAX\",\"gnomAD_genome_RF_Filter\"]\nops=[\"self\",\"self\"]" >> "${vcfAnnoGnomadGenomesConfSample}"
	echo -e "\n[[annotation]]\nfile=\"${gonlAnnotation}/gonl.chrX.release4.gtc.vcf.gz\"\nfields=[\"AC\",\"AN\"]\nnames=[\"GoNL_AC\",\"GoNL_AN\"]\nops=[\"self\",\"first\"]" >> "${vcfAnnoGnomadGenomesConfSample}"
	echo -e "\n[[annotation]]\nfile=\"${gonlAnnotation}/gonl.chrCombined.snps_indels.r5.vcf.gz\"\nfields=[\"AC\",\"AN\"]\nnames=[\"GoNL_AC\",\"GoNL_AN\"]\nops=[\"self\",\"first\"]" >> "${vcfAnnoGnomadGenomesConfSample}"

cat > "${vcfAnnoConfSample}" << HERE

[[annotation]]
file="${caddAnnotationVcf}"
fields=["phred", "raw"]
names=["CADD_SCALED","CADD"]
ops=["self","self"]
HERE

if [[ "${sizeToCADD}" != '0' ]]
then
	length=$(zcat "${fromCaddSample%.tsv.gz}.vcf.gz" | wc -l)

	if [[ "${length}" -gt 8 ]]
	then

cat >> "${vcfAnnoConfSample}" << HERE
[[annotation]]
file="${fromCaddSample%.tsv.gz}.vcf.gz"
fields=["phred", "raw"]
names=["CADD_SCALED","CADD"]
ops=["self","self"]
HERE
	fi
fi
	## write first part of conf file
	cat >> "${vcfAnnoConfSample}" << HERE

[[annotation]]
file="${gnomADExomesAnnotation}/gnomad.exomes.r2.1.1.sites.vcf.normalized.vcf.gz"
fields=["nhomalt", "AN","AF_popmax","segdup","AF_popmax"]
names=["gnomAD_Hom","gnomAD_AN","gnomAD_exome_AF_MAX","gnomAD_exome_RF_Filter","EXAC_AF"]
ops=["self","first","self","self","self"]

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
ops=["by_alt","by_alt","by_alt","by_alt","by_alt","by_alt"]

HERE

## Adding gnomAD
if [[ -f "${vcfAnnoGnomadGenomesConfSample}" ]]
then
	cat "${vcfAnnoGnomadGenomesConfSample}" >> "${vcfAnnoConfSample}"
fi
#
## make custom .lua for calculating hom and het frequency
#
cat > "${vcfAnnoCustomConfLuaSample}" << HERE

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

cat >> "${vcfAnnoConfSample}" << HERE
## Calculating GoNL AF, gnomAD_HOM_AC
[[postannotation]]
fields=["GoNL_AC", "GoNL_AN"]
name="GoNL_AF"
op="div2"
type="Float"
HERE

	echo "starting to annotate with vcfanno"
	IRELATE_MAX_GAP=1000 GOGC=2000 vcfanno -p 4 -lua "${vcfAnnoCustomConfLuaSample}" "${vcfAnnoConfSample}" "${variantCalls}" > "${tmpSampleGenotypedAnnotatedVariantCalls}"
	mv -v "${tmpSampleGenotypedAnnotatedVariantCalls}" "${sampleGenotypedAnnotatedVariantCalls}"

fi

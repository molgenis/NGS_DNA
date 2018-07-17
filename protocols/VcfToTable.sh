#MOLGENIS walltime=05:59:00 mem=6gb ppn=1

#Parameter mapping
#string tmpName
#string vcf2Table
#string variantsFinalProjectVcfTable
#string tmpDataDir
#string logsDir
#string groupname
#string projectPrefix
#string intermediateDir
#list externalSampleID
#string	project
#string stage
#string ngsUtilsVersion


makeTmpDir "${variantsFinalProjectVcfTable}"
tmpVariantsFinalProjectVcfTable="${MC_tmpFile}"
${stage} "${ngsUtilsVersion}"
module list

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "${element}" == "${seeking}" ]]; then
            in=0
            break
        fi
    done
    return "${in}"
}

INPUTS=()
for sampleID in "${externalSampleID[@]}"
do
        array_contains INPUTS "${sampleID}" || INPUTS+=("${sampleID}")    # If bamFile does not exist in array add it
done

filter="AC,AF,AN,DP,FS,MQ,MQRankSum,QD,CADD,CADD_SCALED,gnomAD_exome_AF,CGD_AgeGroup,CGD_Condition,CGD_Inheritance,CGD_Manfest_cat,CGD_invent_cat,gnomAD_genome_AF_MAX,ANN,Samples"

for externalID in "${INPUTS[@]}"
do
	AS+="${externalID},"
	vcfTable="${intermediateDir}/${externalID}.final.vcf.table"
	tmpVcfTable="${vcfTable}.tmp"

	####Transform VCF file into tabular file####
	"${vcf2Table}" \
	-vcf "${intermediateDir}/${externalID}.final.vcf" \
	-output "${tmpVcfTable}" \
	-filter "${filter}" \
	-sample "${externalID}"

	mv "${tmpVcfTable}" "${vcfTable}"
	echo "mv ${tmpVcfTable} ${vcfTable}"
done

ALLSAMPLESINONE=$(echo ${AS%?})

####Transform VCF file into tabular file####
"${vcf2Table}" \
-vcf "${projectPrefix}.final.vcf" \
-output "${tmpVariantsFinalProjectVcfTable}" \
-filter "${filter}" \
-sample "${ALLSAMPLESINONE}"

mv "${tmpVariantsFinalProjectVcfTable}" "${variantsFinalProjectVcfTable}"
echo "moved ${tmpVariantsFinalProjectVcfTable} ${variantsFinalProjectVcfTable}"

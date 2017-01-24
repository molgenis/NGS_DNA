#MOLGENIS walltime=05:59:00 mem=13gb ppn=2

#Parameter mapping
#string tmpName
#string stage
#string checkStage
#string gatkVersion
#string gatkJar
#string htsLibVersion
#string tempDir
#string intermediateDir
#string projectVariantsMerged
#string projectVariantsMergedIdx
#string projectVariantsMergedSorted
#list batchID
#string projectPrefix
#string tmpDataDir
#string project
#string logsDir 
#string groupname
#string sortVCFpl
#string indexFile
#string indexFileFastaIndex

#Load module GATK,tabix
${stage} ${gatkVersion}
${stage} ${htsLibVersion}
${stage} ngs-utils
${checkStage}

makeTmpDir ${projectVariantsMerged}
tmpProjectVariantsMerged=${MC_tmpFile}
makeTmpDir ${projectVariantsMergedIdx}
tmpProjectVariantsMergedIdx=${MC_tmpFile}

makeTmpDir ${projectVariantsMergedSorted}
tmpProjectVariantsMergedSorted=${MC_tmpFile}

#Function to check if array contains value
array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

INPUTS=()

for b in "${batchID[@]}"
do
	if [ -f ${projectPrefix}.batch-${b}.variant.calls.snpeff.exac.gonl.cadd.gatk.vcf ]
	then
		array_contains INPUTS "--variant ${projectPrefix}.batch-${b}.variant.calls.snpeff.exac.gonl.cadd.gatk.vcf" || INPUTS+=("--variant ${projectPrefix}.batch-${b}.variant.calls.snpeff.exac.gonl.cadd.gatk.vcf")
	fi
done

java -Xmx12g -Djava.io.tmpdir=${tempDir} -cp ${EBROOTGATK}/${gatkJar} org.broadinstitute.gatk.tools.CatVariants \
-R ${indexFile} \
${INPUTS[@]} \
-out ${tmpProjectVariantsMerged}

mv ${tmpProjectVariantsMergedIdx} ${projectVariantsMergedIdx}
echo "mv ${tmpProjectVariantsMergedIdx} ${projectVariantsMergedIdx}"
mv ${tmpProjectVariantsMerged} ${projectVariantsMerged}
echo "mv ${tmpProjectVariantsMerged} ${projectVariantsMerged}"

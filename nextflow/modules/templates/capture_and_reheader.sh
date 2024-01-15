#!/bin/bash

set -o pipefail
set -eu

echo -e "!{samples.combinedIdentifier}" "!{samples.externalSampleID}" > "!{samples.externalSampleID}.newVCFHeader.txt"
bedfile=!{params.dataDir}/!{samples.capturingKit}/human_g1k_v37/captured.merged.bed

if [[ "!{samples.build}" == "GRCh38" ]]
then
    bedfile="!{params.bedfile_GRCh38}"
fi

echo "##intervals=[${bedfile}]" > "bedfile.txt"
bcftools reheader -s "!{samples.externalSampleID}.newVCFHeader.txt" "!{genotypedVCF}" | bcftools annotate -h "bedfile.txt" -O v -o "!{genotypedVCF}.tmp"

bedtools intersect -header -a "!{genotypedVCF}.tmp" -b ${bedfile} > "!{genotypedVCF}.captured.vcf"

bgzip -c -f "!{genotypedVCF}.captured.vcf" > "!{genotypedVCF}.captured.vcf.gz"
tabix -p vcf "!{genotypedVCF}.captured.vcf.gz"
rename .variant.calls.genotyped.vcf.captured.vcf .captured.vcf "!{genotypedVCF}.captured.vcf.gz"

touch "!{params.tmpDataDir}/logs/!{samples.project}/run01.nextflow_pipeline.finished"
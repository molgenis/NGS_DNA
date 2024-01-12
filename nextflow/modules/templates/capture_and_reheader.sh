#!/bin/bash

set -o pipefail
set -eu

echo -e "!{samples.combinedIdentifier}" "!{samples.externalSampleID}" > "!{samples.externalSampleID}.newVCFHeader.txt"
bedfile="!{params.dataDir}/!{samples.capturingKit}/human_g1k_v37/captured.merged.bed"

if [[ "!{samples.build}" == "GRCh38" ]]
then
    bedfile="!{params.bedfile_GRCh38}"
fi

echo "##intervals=[${bedfile}]" > "bedfile.txt"
bedtools intersect -header -a "!{genotypedVCF}" -b  > "!{genotypedVCF}.captured.vcf"

bcftools reheader -s "!{samples.externalSampleID}.newVCFHeader.txt" "!{genotypedVCF}.captured.vcf" | bcftools annotate -h "bedfile.txt" -O v -o "!{genotypedVCF}.tmp"
    
bgzip -c -f "!{genotypedVCF}.tmp" > "!{genotypedVCF}.gz"
tabix -p vcf "!{genotypedVCF}.gz"

touch "!{params.tmpDataDir}/logs/!{samples.project}/run01.nextflow_pipeline.finished"
#!/bin/bash

set -o pipefail
set -eu

echo -e "!{samples.combinedIdentifier}" "!{samples.externalSampleID}" > "!{samples.externalSampleID}.newVCFHeader.txt"

echo "##intervals=[!{params.dataDir}/!{samples.capturingKit}/human_g1k_v37/captured.merged.bed]" > "bedfile.txt"

bcftools reheader -s "!{samples.externalSampleID}.newVCFHeader.txt" "!{genotypedVCF}" | bcftools annotate -h "bedfile.txt" -O v -o "!{genotypedVCF}.tmp"
    
bgzip -c -f "!{genotypedVCF}.tmp" > "!{genotypedVCF}.gz"
tabix -p vcf "!{genotypedVCF}.gz"
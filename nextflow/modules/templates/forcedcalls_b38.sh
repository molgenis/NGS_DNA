#!/bin/bash

set -o pipefail
set -eu

if [[ -f "!{samples.combinedIdentifier}.bam" ]]
	then

	bcftools mpileup \
	-Ou -f "!{params.dataDir}/GRC/GRCh38/GRCh38_full_analysis_set_plus_decoy_hla.fa" \
	"!{samples.combinedIdentifier}.bam" \
	-R "!{params.dataDir}/UMCG/concordanceCheckSnps.bed" \
	| bcftools call \
	-m -Ob -o "!{samples.externalSampleID}.concordanceCheckCalls.vcf"
else
    echo "The !{samples.combinedIdentifier}.bam does not exist"
fi
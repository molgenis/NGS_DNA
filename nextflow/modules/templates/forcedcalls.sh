#!/bin/bash

set -o pipefail
set -eu

if [[ -f "!{samples.combinedIdentifier}.bam" ]]
	then

	bcftools mpileup \
	-Ou -f "!{params.dataDir}/1000G/phase1/human_g1k_v37_phiX.fasta" "!{samples.combinedIdentifier}.bam" -R "!{params.dataDir}/UMCG/concordanceCheckSnps.bed" \
	| bcftools call -m -Ob -o "!{samples.externalSampleID}.concordanceCheckCalls.vcf"
else
    echo "The !{samples.combinedIdentifier}.bam does not exist"
fi
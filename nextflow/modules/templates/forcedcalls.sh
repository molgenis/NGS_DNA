#!/bin/bash

set -o pipefail
set -eu

fasta="!{params.reference_GRCh37}"

if [[ "!{samples.build}" == "GRCh38" ]]
then
    fasta="!{params.reference_GRCh38}"	
else
	fasta="!{params.reference_GRCh37}"
fi

if [[ -f "!{samples.combinedIdentifier}.bam" ]]
then
	bcftools mpileup \
	-Ou -f "${fasta}" "!{samples.combinedIdentifier}.bam" -R "!{params.dataDir}/UMCG/concordanceCheckSnps_!{samples.build}.bed" \
	| bcftools call -m -Ob -o "!{samples.externalSampleID}.concordanceCheckCalls.vcf"
else
	echo "The !{samples.combinedIdentifier}.bam does not exist"
fi
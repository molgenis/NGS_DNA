#!/bin/bash

set -o pipefail
set -eu

rename "!{samples.combinedIdentifier}" "!{samples.externalSampleID}" "!{samples.combinedIdentifier}"*
   
bedtools intersect -u -header -a "!{samples.externalSampleID}.hard-filtered.vcf.gz" -b "!{params.dataDir}/"!{samples.capturingKit}"/human_g1k_v37/captured.merged.bed" > "!{samples.externalSampleID}.variant.calls.vcf"
bcftools annotate -x 'FORMAT/AF,FORMAT/F1R2,FORMAT/F2R1,FORMAT/GP' "!{samples.externalSampleID}.variant.calls.vcf" > "!{samples.externalSampleID}.variant.calls.genotyped.vcf"

if [[ -f "!{samples.externalSampleID}.hard-filtered.gvcf.gz" ]]
then
    rename ".gvcf.gz" ".g.vcf.gz" "!{samples.externalSampleID}.hard-filtered.gvcf.gz"*
    rsync -Lv "!{samples.externalSampleID}.hard-filtered.g.vcf.gz"* "!{samples.projectResultsDir}/variants/gVCF/"
fi

if [[ -f "!{samples.externalSampleID}.bam" ]]
then
    rsync -Lv "!{samples.externalSampleID}.bam"{,.md5,.bai} "!{samples.projectResultsDir}/alignment/"
fi
    
if [[ -f "!{samples.externalSampleID}.html" ]]
then
    rsync -Lv "!{samples.externalSampleID}"*.{bed,json,html} "!{samples.projectResultsDir}/qc/"
fi
process PDD-PARSING {
  input:
  tuple val(samples,combinedIdentifier, AnalysisFolder, projectResultsDir )

  output:
  tuple val(samples,combinedIdentifier, AnalysisFolder, projectResultsDir )

  shell:
  '''
    ## rename (g)VCF files
    rename "${combinedIdentifier}" "${externalSampleID}" "${intermediateDir}/${combinedIdentifier}.hard-filtered."*"vcf.gz"*

    bedtools intersect -u -header -a "${intermediateDir}/!{samples.externalSampleID}.hard-filtered.vcf.gz" -b "${captured}.merged.bed" > "!{samples.externalSampleID}.variant.calls.genotyped.vcf"
    bcftools annotate -x 'FORMAT/AF,FORMAT/F1R2,FORMAT/F2R1,FORMAT/GP' "!{samples.externalSampleID}.variant.calls.genotyped.vcf" > "!{samples.externalSampleID}.variant.calls.genotyped.vcf.tmp"
    bgzip -c -f "!{samplesexternalSampleID}.variant.calls.genotyped.vcf.tmp" > "!{samples.externalSampleID}.variant.calls.genotyped.vcf.gz"
    echo "start indexing !{samples.externalSampleID}.variant.calls.genotyped.vcf.gz"
    tabix -p vcf "!{samples.externalSampleID}.variant.calls.genotyped.vcf.gz"

    rename 'gvcf.gz' 'g.vcf.gz' "!{samples.externalSampleID}.hard-filtered.gvcf.gz"*
    rsync -av "!{samples.externalSampleID}.hard-filtered.g.vcf.gz"* "${projectResultsDir}/variants/gVCF/"

    # moving files to results folder
    if [[ -f "${AnalysisFolder}/${combinedIdentifier}/${combinedIdentifier}.bam" || -f "${AnalysisFolder}/${combinedIdentifier}/!{samples.externalSampleID}.merged.dedup.bam" ]]
    then
    	rename "${combinedIdentifier}.bam" "!{samplesexternalSampleID}.merged.dedup.bam" "${AnalysisFolder}/${combinedIdentifier}/"*".bam"*
    	mv -v "${AnalysisFolder}/${combinedIdentifier}/!{samples.externalSampleID}.merged.dedup.bam"{,.md5,.bai} "${projectResultsDir}/alignment/"
    	echo "bam files renamed and moved into ${projectResultsDir}/alignment/" 
    else
    	echo -e "${AnalysisFolder}/${combinedIdentifier}/${combinedIdentifier}.bam not found.\nThis can have 2 reasons, the data is already moved before to ${projectResultsDir}/alignment/\n or the data does not exist at all"
    fi
    # moving qc files
    if [[ -f "${AnalysisFolder}/${combinedIdentifier}/${combinedIdentifier}.html" ]]
    then
    	mv -v "${tmpDataDir}/${gsBatch}/Analysis/${combinedIdentifier}/"*.{bed,json,html} "${projectResultsDir}/qc/"
    	rename "${combinedIdentifier}" "!{samples.externalSampleID}" "${projectResultsDir}/qc/"*
    	echo "qc files renamed in ${projectResultsDir}/qc/" 
    else
    	echo -e "${AnalysisFolder}/${combinedIdentifier}/${combinedIdentifier}.html.\nThis can have 2 reasons:\n1)the data is already moved before to ${projectResultsDir}/qc/ or\n2) the data does not exist at all"
    fi

    echo "$gsBatch"
    
    
    
    
  '''

}
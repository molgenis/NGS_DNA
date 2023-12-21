process PDD-PARSING {
  input:
  tuple val(samples,combinedIdentifier, AnalysisFolder)

  output:
  tuple val(samples)

  shell:
  '''
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
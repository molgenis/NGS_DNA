 projectResultsDir="!{params.tmpDataDir}/projects/NGS_DNA/!{samples.project}/run01/results/"
    combi=$(cat "!{combinedIdentifier}")
    analysisF=$(cat "!{analysisFolder}")
    # moving files to results folder
    if [[ -f "!{analysisFolder}/!{combinedIdentifier}/${combinedIdentifier}.bam" || -f "!{analysisFolder}/!{combinedIdentifier}/!{samples.externalSampleID}.merged.dedup.bam" ]]
    then
    	rename "!{combinedIdentifier}.bam" "!{samplesexternalSampleID}.merged.dedup.bam" "!{analysisFolder}/!{combinedIdentifier}/"*".bam"*
    	mv -v "!{analysisFolder}/!{combinedIdentifier}/!{samples.externalSampleID}.merged.dedup.bam"{,.md5,.bai} "${projectResultsDir}/alignment/"
    	echo "bam files renamed and moved into ${projectResultsDir}/alignment/" 
    else
    	echo -e "!{analysisFolder}/!{combinedIdentifier}/!{combinedIdentifier}.bam not found.\nThis can have 2 reasons, the data is already moved before to ${projectResultsDir}/alignment/\n or the data does not exist at all"
    fi
    # moving qc files
    if [[ -f "!{analysisFolder}/!{combinedIdentifier}/!{combinedIdentifier}.html" ]]
    then
    	mv -v "${tmpDataDir}/!{samples.gsBatch}/Analysis/!{combinedIdentifier}/"*.{bed,json,html} "${projectResultsDir}/qc/"
    	rename "!{combinedIdentifier}" "!{samples.externalSampleID}" "${projectResultsDir}/qc/"*
    	echo "qc files renamed in ${projectResultsDir}/qc/" 
    else
    	echo -e "!{analysisFolder}/!{combinedIdentifier}/!{combinedIdentifier}.html.\nThis can have 2 reasons:\n1)the data is already moved before to ${projectResultsDir}/qc/ or\n2) the data does not exist at all"
    fi

    echo "$gsBatch"
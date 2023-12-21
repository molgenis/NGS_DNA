projectResultsDir

process PDD-COPY {
  input:
  tuple val(samples)

  output:
  tuple val(samples, combinedIdentifier, AnalysisFolder, projectResultsDir )

  shell:
  '''
    AnalysisFolder="!{params.tmpDataDir}/!{samples.gsBatch}/Analysis"
    projectResultsDir="!{params.tmpDataDir}/projects/NGS_DNA/!{samples.project}/run01/results/"
    ## first copy the the stats.csv file
    if [[ -f "${AnalysisFolder}/stats.tsv" ]]
    then
    	echo "rsync -v \"${AnalysisFolder}/stats.tsv\" \"${projectResultsDir}/qc/\"
    fi

    ## copy (g)VCF files first
    combinedIdentifier=$(ls -d "${AnalysisFolder}/"*"-!{samples.sampleProcessStepID}")
    combinedIdentifier=$(basename "${combinedIdentifier}")
    echo  "${combinedIdentifier}" > "${intermediateDir}/!{samples.externalSampleID}.txt"
    echo "rsync -av \"${AnalysisFolder}/${combinedIdentifier}/${combinedIdentifier}.hard-filtered\"*\"vcf.gz\"* \"${intermediateDir}\""
   
    
  '''

}
process forcedcalls {

	publishDir "$samples.projectResultsDir/variants", mode: 'copy', overwrite: true, pattern: '*.concordanceCheckCalls.vcf'
	module = ['BCFtools/1.16-GCCcore-11.3.0']
	label 'forcedcalls'

  	input: 
    tuple val(samples), path(files)

    output:
    tuple val(samples), path(files), path(concordanceCheckCallsVcf)

  	shell:
	concordanceCheckCallsVcf="${samples.externalSampleID}.concordanceCheckCalls.vcf"

  	template 'forcedcalls.sh'
  


}
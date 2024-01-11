process capture_and_reheader {

  publishDir "$samples.projectResultsDir/variants", mode: 'copy', overwrite: true
  label 'reheader'
  module = ['HTSlib/1.16-GCCcore-11.3.0','BCFtools/1.16-GCCcore-11.3.0']

  input: 
    tuple val(samples), path(genotypedVCF)

    output:
    tuple val(samples), path(genotypedVCFgz)

shell:  

  genotypedVCFgz="${genotypedVCF}.gz"
  
  template 'reheader.sh'

}
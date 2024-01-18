process preprocess {

  module = ['BEDTools/2.30.0-GCCcore-11.3.0','HTSlib/1.16-GCCcore-11.3.0','BCFtools/1.16-GCCcore-11.3.0']

  input: 
    tuple val(samples), path(files), path(concordanceCheckCallsVcf)

    output:
    tuple val(samples), path(genotypedVCF)

  shell:
  genotypedVCF="${samples.externalSampleID}.variant.calls.genotyped.vcf"

  template 'preprocess.sh'

}
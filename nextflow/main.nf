#!/usr/bin/env nextflow

nextflow.enable.dsl=2

log.info """\
         T E S T - N F   P I P E L I N E
         ===================================
         outdir       : ${params.outdir}
         samplesheet  : ${params.samplesheet}
         group        : ${params.group}
         tmpdir       : ${params.tmpdir}
         launchDir    : ${params.launchDir}
         """
         .stripIndent()

include { preprocess } from './modules/preprocess'
include { reheader } from './modules/reheader'
include { forcedcalls } from './modules/forcedcalls'

def find_file(sample) {

    String path=params.tmpDataDir + sample.gsBatch + "/Analysis/" + sample.GS_ID + "-" + sample.originalproject + "-" + sample.sampleProcessStepID
    sample.files = file(path+"/*")
    sample.analysisFolder="/groups/umcg-gst/tmp05/" + sample.gsBatch + "/Analysis/"
    sample.projectResultsDir=params.tmpDataDir+"/projects/NGS_DNA/"+sample.project+"/run01/results/"
    sample.combinedIdentifier= file(path).getBaseName()
    return sample
}

workflow {

  Channel.fromPath(params.samplesheet)
  | splitCsv(header:true)
  | map { find_file(it) }
  | map { samples -> [ samples, samples.files ]}
  | set { ch_input }

  //Run once
  ch_input.last()
  | copyStats

  ch_input
  | forcedcalls
  | preprocess
  | reheader
  | view

}

process copyStats{

input: 
 tuple val(samples), path(files)

echo true
   
  shell:
  '''
    mkdir -p !{samples.projectResultsDir}/{alignment,qc,variants/{gVCF,GAVIN}}

    rsync -av "!{samples.analysisFolder}/stats.tsv" "!{samples.projectResultsDir}/qc/"
    echo "DONE DONE"
  '''

}
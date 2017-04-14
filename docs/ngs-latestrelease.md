##Latest release

download here: https://github.com/molgenis/NGS_DNA/releases/tag/3.4.0

Release notes 3.4.0:

## GoNL part
Final version GoNL pipeline on b38, reference genome is ucsc build 38 *ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz*

**new files**
- generate_template_gonl.sh
- workflow_gonl.csv
- batch_b38_chr.csv

**Version updates**
* dbSNP version 149 (All_20161122.vcf.gz)

## Regular pipeline updates
**Version updates** 
* GATK 3.6 --> 3.7 
* picard 1.130 --> 2.9

**New tools**
* Using SeqTk (1.2) for the converting the fastQ files from Illumina 1.5 to 1.9 encoding

**bugfixes + updates**
* removed VariantAnnotator out of workflow: HaplotypeCaller can change the bam by the internally indel realignment and VariantAnnotator is updating the genotypes based on the dedup.bam, this is basically not what we want
* added summary metrics file in GCbias metrics
* removed **stand_call_conf 10.0** in genotyping step, default is 10.0
* removed **stand_emit_conf 20.0** in genotyping step, deprecated in GATK 3.7
* combine Bwa align with SortBam (by FIFO piping) in one step

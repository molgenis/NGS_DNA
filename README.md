# NGS_DNA pipeline 
## Manual
Find manual on installation and use at https://molgenis.gitbooks.io/ngs_dna

## Preprocessing

During the first preprocessing steps of the pipeline, PhiX reads are inserted in each sample to create control SNPs in the dataset. Subsequently, Illumina encoding is checked and QC metrics are calculated using a FastQC tool [[1]](#r1).
  
### Alignment to a reference genome

The bwa-mem command from Burrows-Wheeler Aligner(BWA) [[2]](#r2) is used to align the sequence data to a reference genome resulting in a SAM (Sequence Alignment Map) file. The reads in the SAM file are sorted with Sambamba[[3]](#r3). resulting in a sorted BAM file. When multiple lanes were used during sequencing, all lane BAMs were merged into a sample BAM using Sambamba. The (merged) BAM file is marked for duplicates of the same read pair using Sambamba.

### Variant discovery

The GATK [[4]](#r4) HaplotypeCaller estimates the most likely genotypes and allele frequencies in an alignment using a Bayesian likelihood model for every position of the genome regardless of whether a variant was detected at that site or not. This information can later be used in the project based genotyping step.
A joint analysis has been performed of all the samples in the project. This leads to a posterior probability of a variant allele at a site. SNPs and small Indels are written to a VCF file, along with information such as genotype quality, allele frequency, strand bias and read depth for that SNP/Indel. Based on quality thresholds from the GATK "best practices" [[5]](#r5). The SNPs and indels are filtered and marked as Lowqual or Pass resulting in a final VCF file.

### References
<a name="r1"> 1. Andrews S. (2010). FastQC: a quality control tool for high throughput sequence data. Available online at:http://www.bioinformatics.babraham.ac.uk/projects/fastqc </a>

<a name="r2"> 2. Li Durbin. Fast and accurate short read alignment with Burrows-Wheeler transform.</a>

<a name="r3"> 3. Tarasov et al. Sambamba. Fast processing of NGS alignment formats. </a>

<a name="r4"> 4. McKenna et al. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. </a>

<a name="r5"> 5. Van der Auwera et al. From FastQ data to high confidence variant calls: the Genome Analysis Toolkit best practices pipeline.</a>

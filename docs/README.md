<h1> NGS_DNA pipeline </h1>

<h2>Manual</h2>
Find manual on installation and use at https://molgenis.gitbooks.io/ngs_dna

<h3>Preprocessing</h3>
During the first preprocessing steps of the pipeline, PhiX reads are inserted in each sample to create control SNPs in the dataset. Subsequently, Illumina encoding is checked and QC metrics are calculated using FastQC<sup>1</sup>. 

<h3>Alignment to a reference genome</h3>
The bwa-mem command from Burrows-Wheeler Aligner (BWA)<sup>2</sup> is used to align the sequence data to a reference genome resulting in a SAM (Sequence Alignment Map) file. The reads in the SAM file are sorted with Sambamba<sup>3</sup> resulting in a sorted BAM file. When multiple lanes were used during sequencing, all lane BAMs were merged into a sample BAM using Sambamba. The (merged) BAM file is marked for duplicates of the same read pair using Sambamba.

<h3>Variant discovery</h3>
The GATK<sup>4</sup> HaplotypeCaller estimates the most likely genotypes and allele frequencies in an alignment using a Bayesian likelihood model for every position of the genome regardless of whether a variant was detected at that site or not. This information can later be used in the project based genotyping step.
A joint analysis has been performed of all the samples in the project. This leads to a posterior probability of a variant allele at a site. SNPs and small Indels are written to a VCF file, along with information such as genotype quality, allele frequency, strand bias and read depth for that SNP/Indel.
Based on quality thresholds from the GATK "best practices"<sup>5</sup>.
the SNPs and indels are filtered and marked as Lowqual or Pass resulting in a final VCF file.

<h3>References</h3>
1. Andrews S (2010). FastQC: a quality control tool for high throughput sequence data. Available online at:http://www.bioinformatics.babraham.ac.uk/projects/fastqc.<br/>
2. Li H, Durbin R (2009). Fast and accurate short read alignment with Burrows-Wheeler transform.<br/>
3. Tarasov A et al. (2015). Sambamba: Fast processing of NGS alignment formats.<br/>
4. McKenna A et al. (2010). The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data.<br/>
5. Van der Auwera GA et al. (2013). From FastQ data to high confidence variant calls: the Genome Analysis Toolkit best practices pipeline.<br/>


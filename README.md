# NGS_DNA

The sequencer is producing reads (in FastQ format) and are aligned to the hg19 reference genome with BWA (Li & Durbin1). 
Sambamba (Tarasov et al.2) is processing the aligned reads and then we applied GATK (McKenna et al. 3) duplicate removal, performed 
SNP and INDEL discovery and genotyping using standard hard filtering parameters to GATK Best Practices recommendations (Van der Auwera et al.4)


References
1)	Li Durbin, Fast and accurate short read alignment with Burrows-Wheeler transform.
2)	Sambamba: Fast processing of NGS alignment formats
3)	The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data
4)	From FastQ data to high confidence variant calls: the Genome Analysis Toolkit best practices pipeline


Documentation is available online @ http://molgenis.github.io/pipelines/


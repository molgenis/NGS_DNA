<h1>NGS_DNA pipeline</h1>
<h2>Manual</h2>
Find manual on installation and use at https://molgenis.gitbooks.io/molgenis-pipelines/

<h2>Summary</h2>
The sequencer is producing reads (in FastQ format) and are aligned to the hg19 reference genome with BWA (Li & Durbin <sup>1</sup>).
Sambamba (Tarasov et al.<sup>2</sup>)  is processing the aligned reads and then we applied GATK (McKenna et al. <sup>3</sup>) duplicate removal,
performed SNP and INDEL discovery and genotyping using standard hard filtering parameters to GATK Best Practices recommendations (Van der Auwera et al.<sup>4</sup>)

<h3>References</h3>
1. Li Durbin, Fast and accurate short read alignment with Burrows-Wheeler transform.
2. Sambamba: Fast processing of NGS alignment formats
3. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data
4. From FastQ data to high confidence variant calls: the Genome Analysis Toolkit best practices pipeline

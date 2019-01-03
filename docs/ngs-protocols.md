# Preprocessing (aligning --> bam )
### Step 1: PrepareFastQ
#### Spike in the PhiX reads

The PhiX reads will be inserted in each sample to see whether the pipeline ran correctly. Later on (step 23 of the pipeline) there will be a concordance check to see if the SNPs that are put in, will be found back.

**Scriptname:** SpikePhiX<br/>
**Input:** Raw sequence file in the form of a gzipped fastQ file<br/>
**Output:** FastQ files (${filePrefix}_${lane}_${barcode}.fq.gz)*<br/>

#### Check the Illumina encoding

In this step the encoding of the FastQ files will be checked. Older (2012 and older) sequence data contains the old Phred+64 encoding (this is called Illumina 1.5 encoding). New sequence data is encoded in Illumina 1.8 or 1.9 (Phred+33). If the data is enoded with Illumina 1.5, it will be converted to the 1.9 encoding

**Toolname:** seqTk<br/>
**Scriptname:** CheckIlluminaEncoding<br/>
**Input:** FastQ files (${filePrefix}_${lane}_${barcode}.fq.gz)<br/>
**Output:** If conversion took place, encoded.fq.gz<br/>
```
seqtk seq fastq_1.fq.gz -Q 64 -V > fastq_1.encoded.fq.gz
seqtk seq fastq_2.fq.gz -Q 64 -V > fastq_2.encoded.fq.gz
```
### Step 2: Alignment + SortSam

In this step, the Burrows-Wheeler Aligner (BWA) is used to align the (mostly paired end) sequencing data to the reference genome. The method that is used is BWA mem. The output is a FIFO piped SAM file, in this way we can do the sorting of the SAM/BAM file in one go without writing it to disk in between.

**Scriptname:** BwaAlignAndSortBam

#### Aligning

**Toolname:** BWA<br/>
**Input:** Raw sequence file in the form of a gzipped fastQ file (${filePrefix}.fq.gz)<br/>
**Output:** FIFO piped SAM formatted file (${filePrefix}.sam)<br/>
```
bwa mem \
    -M \
    -R $READGROUPLINE \
    -t 8 \
	-human_g1k_v37.fa \
	-fastq1.gz \
	-fastq2.gz \
	> aligned.sam &
```
#### Sorting SAM/BAM file

**Toolname:** Picard SortSam<br/>
**Input**: fifo piped sam file<br/>
**Output**: sorted bamfile (.sorted.bam)<br/>
```
java -Djava.io.tmpdir=${tempDir} -XX:ParallelGCThreads=4
-Xmx29G -jar /folder/to/picard/picard.jar \
SortSam \
INPUT= aligned.sam \
OUTPUT=aligned.sorted.bam  \
SORT_ORDER=coordinate \
CREATE_INDEX=true
```
### Step 3: Calculate QC metrics on raw data

In this step (Fastqc), quality control (QC) metrics are calculated for the raw sequencing data. This is done using the tool FastQC. This tool will run a series of tests on the input file. The output is a text file containing the output data which is used to create a summary in the form of several HTML pages with graphs for each test. Both the text file and the HTML document provide a flag for each test: pass, warning or fail. This flag is based on criteria set by the makers of this tool. Warnings or even failures do not necessarily mean that there is a problem with the data, only that it is unusual compared to the used criteria. It is possible that the biological nature of the sample means that this particular bias is to be expected.

**Toolname:** FastQC<br/>
**Scriptname:** Fastqc<br/>
**Input:** fastq_1.fq.gz and fastq_2.fq.gz (${filePrefix}_${lane}_${barcode}.fq.gz)<br/>
**Output:** ${filePrefix}.fastqc.zip archive containing amongst others the HTML document and the text file<br/>
```
fastqc \
	fastq1.gz \
	fastq2.gz \
	-o outputDirectory
```
### Step 4: Merge BAMs and build index

To improve the coverage of sequence alignments, a sample can be sequenced on multiple lanes and/or flowcells. If this is the case for the sample(s) being analyzed, this step merges all BAM files of one sample and indexes this new file. If there is just one BAM file for a sample, nothing happens.

**Toolname:** Sambamba merge<br/>
**Scriptname:** SambambaMerge<br/>
**Input:** sorted BAM files from (${sample}.sorted.bam)<br/>
**Output:** merged BAM file (${sample}.merged.bam)<br/>
```
sambamba merge \
	merged.bam \
	${arrayOfSortedBams[@]}
```
### Step 5: Base recalibration
Calculate more accurate base quality scores, the output of this step can be used as an argument in HaplotypeCaller (see step XX VariantCalling )

**Toolname:** GATK BaseRecalibrator<br/>
**Scriptname:** BaseRecalibrator<br/>
**Input:** merged.bam<br/>
**Output:** merged.bam.recalibrated.table<br/>
```
java -XX:ParallelGCThreads=2 -Djava.io.tmpdir=${tempDir} -Xmx9g -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-R human_g1k_v37.fa \
-I merged.bam \
```
### Step 6: Marking duplicates 

In this step, the BAM file is examined to locate duplicate reads, using Sambamba markdup. A mapped read is considered to be duplicate if the start and end base of two or more reads are located at the same chromosomal position in comparison to the reference genome. For paired-end data the start and end locations for both ends need to be the same to be called duplicate. One read pair of these duplicates is kept, the remaining ones are flagged as being duplicate.

**Toolname:** Sambamba markdup<br/>
**Scriptname:** MarkDuplicates<br/>
**Input:** Merged BAM file (${sample}.merged.bam)<br/>
**Output:**
- BAM file with duplicates flagged (${sample}.dedup.bam)
- BAM index file (${sample}.dedup.bam.bai)

Mark duplicates:
```
sambamba markdup \
	--nthreads=4 \
	--overflow-list-size 1000000 \
	--hash-table-size 1000000 \
	-p \
	merged.bam \
	merged.dedup.bam
```
### Step 10: Flagstat (dedup metrics)
Calculating dedup metrics.

**Toolname:** Sambamba flagstat<br/>
**Scriptname:** FlagstatMetrics<br/>
**Input:** dedup BAM file (${sample}.dedup.bam)<br/>
**Output:** .flagstat file (${sample}.dedup.bam.flagstat)
```
sambamba flagstat \
	--nthreads=4 \
	merged.dedup.bam \
	> dedup.bam.flagstat
```
# Indel calling with Manta, Convading & XHMM
### Step 11a: Calling big deletions with Manta

In this step, the program Manta calls all types of structural variants (DEL,DUP,INV,TRA,INS) from the merged BAM file. The calls are written to 3 different gzipped VCF files. These files are candidateSmallIndels, candidateSV and diploidSV along with information such as difference in length between REF and ALT alleles, type of structural variant and information about allele depth.

**Toolname:** Manta<br/>
**Scriptname:** Manta<br/>
**Input:** dedup BAM file (${sample}.dedup.bam)<br/>
**Output:** 
- ${sample}.candidateSmallIndels.vcf.gz
- ${sample}.candidateSV.vcf.gz
- ${sample}.diploidSV.vcf.gz

Prepare workflow:
```
python configManta.py \
        --bam merged.dedup.bam \
        --referenceFasta human_g1k_v37.fa \
        --exome \
        --runDir /run/dir/manta
```
run workflow:
```
        python /run/dir/manta/runWorkflow.py \ 
		-m local \
		-j 20
```
### Step 12a: CoNVaDING
CoNVaDING (Copy Number Variation Detection In Next-generation sequencing Gene panels) was designed for small (single-exon) copy number variation (CNV) detection in high coverage next-generation sequencing (NGS) data, such as obtained by analysis of smaller targeted gene panels.
This step includes the 4 Convading steps in one protocol. It is gender specific for the sex chromosomes. For more detail about this step: http://molgenis.github.io/software/CoNVaDING
Note: This step needs an already defined controlsgroup!

**Toolname:** Convading<br/>
**Scriptname:** Convading<br/>
**Input:** dedup BAM file (${sample}.dedup.bam)<br/>
**Output:** file containing regions that contain a CNV ${sample}.finallist<br/>

**Step 1:StartWithBam**
```
perl CoNVaDING.pl \
	-mode StartWithBam \
	-inputDir Convading/InputBamsDir/ \
	-outputDir Convading/StartWithBam/ \
	-controlsDir Convading/ControlsDir/ \
	-bed mypanel.bed \
	-rmdup
```
**Step 2:StartWithMatchScore**
```
perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode StartWithMatchScore \
    -inputDir Convading/StartWithBam/ \
    -outputDir Convading/StartWithMatchScore/ \
    -controlsDir Convading/ControlsDir/
```						
**Step 3:StartWithBestScore**
```
perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode StartWithBestScore \
	-inputDir Convading/StartWithMatchScore/ \
	-outputDir Convading/StartWithBestScore/ \
	-controlsDir Convading/ControlsDir/ \
	-sexChr	##only selected when there are sexChromosomes	
```
**Step 4: CreateFinalList**
```
perl ${EBROOTCONVADING}/CoNVaDING.pl \
	-mode CreateFinalList \
	-inputDir Convading/StartWithBestScore/ \
	-outputDir Convading/CreateFinalList/ \
	-targetQcList targetQcList.txt
```	
### Step 12b: XHMM
The XHMM software suite was written to call copy number variation (CNV) from next-generation sequencing projects, where exome capture was used (or targeted sequencing, more generally).
This protocol contains all the steps described here http://atgu.mgh.harvard.edu/xhmm/tutorial.shtml

**Toolname:** XHMM<br/>
**Scriptname:** XHMM<br/>
**Input:** dedup BAM file (${sample}.dedup.bam)<br/>
**Output:** file containing regions that contain a CNV ${sample}.xcnv<br/>

### Step 12c: Decision tree
To determine if a CNV is true, the output from steps Convading and XHMM will be checked usinh a decision tree developed by L. Johannson together with his student (M. Frans). The end results of the decision tree will result in a file with very high confidence CNVs.

**Scriptname:** DecisionTree<br/>
**Input:** multiple output files from XHMM (${SAMPLE}_step10.xcnv.final) and Convading (.shortlist.finallist.txt, .shortlist.txt, .totallist.txt and .longlist.txt)<br/>
**Output:** ${SAMPLE}.longlistplusplusFinal.txt<br/>

# Determine gender
### Step 07: GenderCalculate

Due to the fact a male has only one X chromosome it is important to know if the sample is from a male or a female. Calculating the coverage on the non pseudo autosomal region and compare this to the average coverage on the complete genome predicts male or female well.

**Toolname:** Picard CalculateHSMetrics<br/>
**Scriptname:** GenderCalculate<br/>
**Input:** dedup BAM file (${sample}.dedup.bam)<br/>
**Output:** ${dedupBam}.nonAutosomalRegionChrX_hs_metrics<br/>
```
java -jar -Xmx4g picard.jar CalculateHsMetrics \
	INPUT=merged.dedup.bam \
	TARGET_INTERVALS=input.nonAutosomalChrX.interval_list \
	BAIT_INTERVALS=input.nonAutosomalChrX.interval_list \
	OUTPUT=output.nonAutosomalRegionChrX_hs_metrics
```
# Side steps
### Step 13: CramConversion

Producing more compressed BAM files, decreasing size with 40%.

**Toolname:** Scramble<br/>
**Scriptname:** CramConversion<br/>
**Input:** dedup BAM file (${sample}.dedup.bam)<br/>
**Output:** dedup CRAM file (${sample}.dedup.bam.cram)<br/>
```
scramble \
	-I bam \
	-O cram \
	-r human_g1k_v37.fa \
	-m \
	-t 8 \
	merged.dedup.bam \
	merged.dedup.bam.cram
```
### Step 14: Make md5’s for the bam files

Small step to create md5sums for the bams created in the MarkDuplicates step

**Scriptname:** MakeDedupBamMd5<br/>
**Input:** realigned BAM file (.merged.dedup.bam)<br/>
**Output:** md5sums (.merged.dedup.bam.md5)<br/>
```
md5sum merged.dedup.bam > merged.dedup.bam.md5
```
# Coverage calculations (diagnostics only)
### Step 15: Calculate coverage per base and per target

Calculates coverage per base and per target, the output will contain chromosomal position, coverage per base and gene annotation

**Toolname:** GATK DepthOfCoverage<br/>
**Scriptname:** CoverageCalculations<br/>
**Input:** dedup BAM file (.merged.dedup.bam)<br/>
**Output:** Tab-delimited file containing chromosomal position, coverage per base and Gene annotation name (.coveragePerBase.txt).<br/>

Per base:
```
java -Xmx10g -jar /path/to/GATK/GenomeAnalysisTK.jar \
	-R human_g1k_v37.fa \
	-T DepthOfCoverage \
	-o region.coveragePerBase \
	--omitLocusTable \
	-I merged.dedup.bam \
	-L region.bed
```
Per target:
```
java -Xmx10g -jar /path/to/GATK/GenomeAnalysisTK.jar \
	-R human_g1k_v37.fa \
	-T DepthOfCoverage \
	-o region.coveragePerTarget \
	--omitDepthOutputAtEachBase \
	-I merged.dedup.bam \
	-L region.bed
```
# Metrics calculations
### Step 08 (a,b,c,d): Calculate alignment QC metrics

In this step, QC metrics are calculated for the alignment created in the previous steps. This is done using several QC related Picard tools:

- CollectAlignmentSummaryMetrics<br/>
- CollectGcBiasMetrics<br/>
- CollectInsertSizeMetrics<br/>
- MeanQualityByCycle (machine cycle)<br/>
- QualityScoreDistribution<br/>
- CalculateHsMetrics (hybrid selection)<br/>
- BamIndexStats<br/>

These metrics are later used to create tables and graphs (step 24). The Picard tools also output a PDF version of the data themselves, containing graphs.

**Toolname:** several Picard QC tools<br/>
**Scriptname:** Collect metrics<br/>
**Input:** dedup BAM file (.merged.dedup.bam)<br/>
**Output:** alignmentmetrics, gcbiasmetrics, insertsizemetrics, meanqualitybycycle, qualityscoredistribution, hsmetrics, bamindexstats (text files and matching PDF files)<br/>

# Determine Gender
### Step 09: Gender check

Due to the fact that a male has only one X chromosome it is important to know if the sample is from a male or a female. Calculating the coverage on the non pseudo autosomal region and compare this to the average coverage on the complete genome predicts male or female well.

**Scriptname:** GenderCheck<br/>
**Input:** ${dedupBam}.hs\_metrics (CalculateHsMetrics step) (${dedupBam}.nonAutosomalRegionChrX_hs_metrics (GenderCalculate step)<br/>
**Output:** ${sample}.chosenSex.txt<br/>

# Variant discovery
### Step 16a: Call variants (VariantCalling)

The GATK HaplotypeCaller estimates the most likely genotypes and allele frequencies in an alignment using a Bayesian likelihood model for every position of the genome regardless of whether a variant was detected at that site or not. This information can later be used in the project based genotyping step.

**Scriptname::** GATK HaplotypeCaller<br/>
**Scriptname:** VariantGVCFCalling<br/>
**Input:** merged BAM files<br/>
**Output:** gVCF file (${sample}.${batchBed}.variant.calls.g.vcf)<br/>
```
java -Xmx12g -jar /path/to/GATK/GenomeAnalysisTK.jar \
    -T HaplotypeCaller \
    -R human_g1k_v37.fa \
    -I merged.dedup.bam \
	--BQSR merged.bam.calibrated.table \
	--dbsnp dbsnp_137.b37.vcf \
	--newQuals \
    -o output.g.vcf.gz \
    -L captured.bed \
    --emitRefConfidence GVCF \
	-ploidy 2  ##ploidy 1 in non autosomal chr X region in male##
```
### Step 16b: Genotype variants

This step performs a joint analysis over all the samples in the project. This leads to a posterior probability of a variant allele at a site. SNPs and small Indels are written to a VCF file, along with information such as genotype quality, allele frequency, strand bias and read depth for that SNP/Indel.

**Toolname:** GATK GenotypeGVCFs<br/>
**Scriptname:** VariantGVCFGenotype<br/>
**Input:** gVCF files from step 16a **or** combined gVCF files from step 16b<br/>
**Output:** VCF file for all the samples in the project (${project}.${batchBed}.variant.calls.genotyped.vcf)<br/>
```
java -Xmx16g -jar /path/to/GATK/GenomeAnalysisTK.jar \
	-T GenotypeGVCFs \
	-R human_g1k_v37.fa \
	-L captured.bed \
	--dbsnp dbsnp_137.b37.vcf \
	-o genotyped.vcf \
	${ArrayWithgVCFgz[@]} 
```
# Annotation
### Step 17: Annotating with vcfanno

Data will be annotated with a tool called vcfanno.
Databases such as CGD, CADD, ClinVar, gnomAD and GoNL are used to pick fields of interest.

Initially, a preprocessing step is performed to split all the alternative alleles into separate lines in the vcf. This is done in order to get a CADD score for every variant. Then, they will be joined together to run the annotation.

**Toolname:** vcfanno and bcftools<br/>
**ScriptName:** AnnotateVCF<br/>
**Input:** genotyped vcf (.genotyped.vcf)<br/>
**Output:** VEP annotated vcf (.calls.genotyped.annotated.vcf)<br/>
```
 vcfanno_linux64 \
 -p 4 \
 -lua "${vcfAnnoCustomConfLua}" \
 "${vcfAnnoConf}" \
  ${batch}.genotyped.vcf > ${batch}.calls.genotyped.annotated.vcf
```
### Step 18: Annotating with SnpEff 

Data will be annotated with SnpEff
Genetic variant annotation and effect prediction toolbox. It annotates and predicts the effects of variants on genes (such as amino acid changes). 

**Toolname:** SnpEff<br/>
**ScriptName:** SnpEff<br/>
**Input:** genotyped vcf (.genotyped.vcf)<br/>
**Output:** snpeff annotated vcf (.snpeff.vcf)<br/>
```
java -XX:ParallelGCThreads=4 -Xmx4g -jar \
        /path/to/snpEff/snpEff.jar \
        -v hg19 \
        -noStats \
        -noLog \
        -lof \
		-canon \
        -ud 0 \
        -c snpEff.config \
        genotyped.vcf \
        > genotyped.snpeff.vcf
```
### Step s19: Merge batches

Running GATK CatVariants to merge all the files created in the previous step into one.

**Toolname:** GATK CatVariants<br/>
**Scriptname:** MergeChrAndSplitVariants<br/>
**Input:** CmdLineAnnotator vcf file (.genotyped.snpeff.exac.gonl.cadd.vcf)<br/>
**Output:** merged (batches) vcf per project (${project}.variant.calls.vcf)<br/>
```
java -Xmx12g -Djava.io.tmpdir=${tempDir} -cp /path/to/GATK/GenomeAnalysisTK.jar \
org.broadinstitute.gatk.tools.CatVariants \
-R human_g1k_v37.fa \
${arrayWithVcfs[@]} \
-out merged.variant.calls.vcf
```

### Step 20: Split indels and SNPs

This step is necessary because the filtering of the vcf needs to be done separately.

**Toolname:** GATK SelectVariants<br/>
**Scriptname:** SplitIndelsAndSNPs<br/>
**Input:** merged (batches) vcf per project (${project}.variant.calls.GATK.vcf) (from step 22)<br/>
**Output:**
- .annotated.indels.vcf 
- .annotated.snps.vcf

```
java -XX:ParallelGCThreads=2 -Xmx4g -jar /path/to/GATK/GenomeAnalysisTK.jar \
-R human_g1k_v37 \
-T SelectVariants \
--variant merged.variant.calls.vcf \
-o .annotated.snps.vcf #.annotated.indels.vcf \
-L captured.bed \
--selectTypeToExclude INDEL ##--selectTypeToInclude INDEL  \
-sn ${externalSampleID}
```

### Step 21: (a) SNP and (b) Indel filtration

Based on certain quality thresholds (based on GATK best practices) the SNPs and indels are filtered or marked as Pass.

**Toolname:** GATK VariantFiltration<br/>
**Scriptname:** VariantFiltration<br/>
**Input:**
- .annotated.snps.vcf
- .annotated.indels.vcf

**Output:**
- Filtered snp vcf file (.annotated.filtered.snps.vcf)
- Filtered indel vcf file (.annotated.filtered.indels.vcf)

SNP:
```
java-Xmx8g -Xms6g -jar /path/to/GATK/GenomeAnalysisTK.jar \
-T VariantFiltration \
-R human_g1k_v37.fa \
-o .annotated.filtered.snps.vcf \
--variant inputSNP.vcf \
--filterExpression "QD < 2.0" \
--filterName "filterQD" \
--filterExpression "MQ < 25.0" \
--filterName "filterMQ" \
--filterExpression "FS > 60.0" \
--filterName "filterFS" \
--filterExpression "MQRankSum < -12.5" \
--filterName "filterMQRankSum" \
--filterExpression "ReadPosRankSum < -8.0" \
--filterName "filterReadPosRankSum"
```
Indel:
```
java-Xmx8g -Xms6g -jar /path/to/GATK/GenomeAnalysisTK.jar \
-T VariantFiltration \
-R human_g1k_v37.fa \
-o .annotated.filtered.indels.vcf\
--variant inputIndel.vcf \
--filterExpression "QD < 2.0" \
--filterName "filterQD" \
--filterExpression "FS > 200.0" \
--filterName "filterFS" \
--filterExpression "ReadPosRankSum < -20.0" \
--filterName "filterReadPosRankSum"
```
### Step 22: Merge indels and SNPs

Merge all the SNPs and indels into one file (per project) and merge SNPs and indels per sample.

**Toolname:** GATK CombineVariants<br/>
**Scriptname:** MergeIndelsAndSnps<br/>
**Input:**
- .annotated.filtered.indels.vcf
- .annotated.snps.vcf

**Output:**
- sample.final.vcf
- project.final.vcf

Per sample:
```
java -Xmx2g -jar /path/to/GATK/GenomeAnalysisTK.jar \
	-R human_g1k_v37.fa \
	-T CombineVariants \
	--variant sample.annotated.filtered.indels.vcf \
	--variant sample.annotated.filtered.snps.vcf \
	--genotypemergeoption UNSORTED \
	-o sample.final.vcf
```
Per project:
```
java -Xmx2g -jar ${EBROOTGATK}/${gatkJar} \
-R human_g1k_v37.fa \
-T CombineVariants \
${arrayWithAllSampleFinalVcf[@]} \
-o ${projectPrefix}.final.vcf
```
### Step 23: Determine trio

This step will determine which samples are related in the project vcf.

**Toolname:** vcfped<br/>
**Scriptname:** DetermineTrio<br/>
**Input:** vcf with all the samples (${projectPrefix}.final.vcf)<br/>
**Output:**
- "${trioInformationPrefix}"_family{1-9}.txt
- ${child}.hasFamily
```
vcfped ${projectPrefix}.final.vcf -o "${projectPrefix}"
```
### Step s24a: Gavin

Tool that predicts the impact of the SNP with the help of different databases (CADD etc). 

**Scriptname:** Gavin<br/>
**Toolname:** gavin-plus<br/>
**Input:** merged vcf per sample ${sample}.variant.calls.GATK.vcf<br/>
**Output:** Gavin final output (.GAVIN.RVCF.final.vcf)<br/>
```
java -Xmx4g -jar /path/to/Gavin_toolpack/GAVIN-APP.jar \
-i input.vcf \
-o output.vcf \
-m ANALYSIS \
-c emptyFile.tsv \
-p gavinClinVar.vcf.gz \
-d gavinCGD.txt.gz \
-f gavinFDR.tsv \
-g gavinCalibrations.tsv
-x \
-y \
-k \
-s \
-q BOTH
```
### Step s24b: CartageniaTree

Representation of the Cartagenia tree for filtering interesting variants.

**Toolname:** bedtools, GATK CatVariants, GATK SelectVariants<br/>
**Scriptname:** CartegeniaTree<br/>
**Input:** Gavin final output (.GAVIN.RVCF.final.vcf)<br/>
**Output:** ${sample}.step9_filteredOnTargets.proceedToSpecTree.vcf<br/>

### Step s24c: CartageniaFiltering

Filter the variants based on a certain gene panel, RF_Filter. 
Adding tags where the variant is filtered out (or why it is included) in the previous step.

**Toolname:** bcftools annotate<br/>
**Scriptname:** CartegeniaFiltering<br/>
**Input:** ${sample}.step9_filteredOnTargets.proceedToSpecTree.vcf<br/>
**Output:** "${sample}.finalProduct.tsv<br/>
```
bcftools annotate -x ^FORMAT/GT "${outputStep9_1ToSpecTree}" | awk 'BEGIN {OFS="\t"}{if ($0 !~ /^#/){split($10,a,"/"); print $1,$2,$3,$4,$5,$6,$7,a[1],a[2],$8}}' | sort -V > "${name}.splittedAlleles.txt"
```
### Step 25a/b: Compressing sample and project vcf

Compressing the vcfs.

### Step 26: Convert structural variants VCF to table

In this step the indels in VCF format are converted into a tabular format using Perlscript vcf2tab by F. Van Dijk.

**Toolname:** vcf2tab.pl<br/>
**Scriptname:** IndelVcfToTable<br/>
**Input:** (${sample}.final.vcf)<br/>
**Output:** (${sample}.final.vcf.table)<br/>

# QC-ing
### Step 27: In silico concordance check

The reads that are inserted contain SNPs that are handmade. To see whether the pipeline ran correctly at least these SNPs should be found.

**Input:** InSilicoData.chrNC_001422.1.variant.calls.vcf and ${sample}.variant.calls.sorted.vcf<br/>
**Output:** inSilicoConcordance.txt<br/>

### Step 28: Generate quality control report

The step in the in-house sequence analysis pipeline outputs the statistics and metrics from each step that produced such data that was collected in the QCStats step before. We use the multiQC tool to create an interactive HTML file with all the statistics.

**Toolname:** multiqc<br/>
**Scriptname:** MultiQC<br/>
**Input:** ${sample}.total.qc.metrics.table<br/>
**Output:** A quality control report html(*_multiqc.html)<br/>

### Step 29: Check if all files are finished

This step performs checking if all the steps in the pipeline are actually finished. It sometimes happens that a job is not submitted to the scheduler. If everything is finished than it will write a file called CountAllFinishedFiles_CORRECT. If not, it will make CountAllFinishedFiles_INCORRECT. This file contains the name(s) of the file(s) that are not finished yet.

**Scriptname:** CountAllFinishedFiles<br/>
**Input:** all .sh scripts + all .sh.finished files in the jobs folder<br/>
**Output:** CountAllFinishedFiles_CORRECT or CountAllFinishedFiles_INCORRECT<br/>

### Step 30: Prepare data to ship to the customer

In this last step, the final results of the in-house sequence analysis pipeline are gathered and prepared to be shipped to the customer. The pipeline tools and scripts write intermediate results to a temporary directory. From the files in the temporary directory, a selection is copied to a results directory. This directory has five subdirectories:

o alignment: the merged BAM file with index<br/>
o coverage: coverage statistics and plots<br/>
o coverage_visualization: coverage BEDfiles<br/>
o qc: all QC files, from which the QC report is made<br/>
o rawdata/ngs: symbolic links to the raw sequence files and their md5 sum<br/>
o snps: all SNP calls in VCF format and in tab-delimited format<br/>
o structural_variants: all SVs calls in VCF and in tab-delimited format<br/>

Additionally, the results directory contains the final QC report, the worksheet which was the basis for this analysis (see 4.2) and a zipped archive with the data that will be shipped to the client (see: GCC_P0006_Datashipment.docx). The archive is accompanied by an md5 sum and README file explaining the contents.<br/>

**Scriptname:** CopyToResultsDir<br/>

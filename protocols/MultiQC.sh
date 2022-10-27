#Parameter mapping
#string tmpName
#string tmpDirectory
#string tempDir
#string project
#string logsDir
#string groupname
#string intermediateDir

#string bedToolsVersion
#string bwaVersion
#string computeVersion
#string caddVersion
#string convadingVersion
#string fastqcVersion
#string gatkVersion
#string gavinPlusVersion
#string iolibVersion
#string javaVersion
#string mantaVersion
#string multiQCVersion
#string ngsUtilsVersion
#string picardVersion
#string rVersion
#string sambambaVersion
#string samtoolsVersion
#string seqTkVersion
#string snpEffVersion
#string htsLibVersion
#string vcfAnnoVersion
#string projectResultsDir
#string ngsversion
#string capturingKit


#string runDateInfoFile
#list externalSampleID
#list capturingKit
#list sequencingStartDate

set -e
set -u

#Making Header of the MultiQC Report
# shellcheck disable=SC1078
echo -e "report_header_info:
- Contact E-mail: 'hpc.helpdesk@umcg.nl'
- Pipeline Version: '${ngsversion}'
- Project : '${project}'
- capturingKit : '${capturingKit}'
- '' : ''
- Used toolversions: ' '
- '' : ''
- '': '${bedToolsVersion}'
- '': '${bwaVersion}'
- '': '${computeVersion}'
- '': '${caddVersion}'
- '': '${convadingVersion}'
- '': '${fastqcVersion}'
- '': '${gatkVersion}'
- '': '${gavinPlusVersion}'
- '': '${iolibVersion}'
- '': '${javaVersion}'
- '': '${mantaVersion}'
- '': '${ngsUtilsVersion}'
- '': '${picardVersion}'
- '': '${rVersion}'
- '': '${sambambaVersion}'
- '': '${samtoolsVersion}'
- '': '${seqTkVersion}'
- '': '${snpEffVersion}'
- '': '${htsLibVersion}'
- '': '${vcfAnnoVersion}'
- '': '${multiQCVersion}'
- '' : ''
- pipeline description : ''
- Manual : ''
- '': 'Find manual on installation and use at https://molgenis.gitbooks.io/ngs_dna'
- '' : ''
- Preprocessing : ''
- '': 'During the first preprocessing steps of the pipeline, PhiX reads are inserted in each sample to create control SNPs in the dataset.'
- '': 'Subsequently, Illumina encoding is checked and QC metrics are calculated using a FastQC tool Andrews S. (2010) 1)'
- '' : ''
- Alignment to a reference genome : ''
- '' : ''
- '': 'The bwa-mem command from Burrows-Wheeler Aligner(BWA) (Li & Durbin 3)) is used to align the sequence data to a reference genome resulting in a SAM (Sequence Alignment Map) file.'
- '': 'The reads in the SAM file are sorted with Sambamba(Tarasov et al. 3)). resulting in a sorted BAM file.'
- '': 'When multiple lanes were used during sequencing, all lane BAMs were merged into a sample BAM using Sambamba.'
- '': 'The (merged) BAM file is marked for duplicates of the same read pair using Sambamba.'
- Variant discovery : ''
- '' : ''
- '': 'The GATK (McKenna et al. 4)) HaplotypeCaller estimates the most likely genotypes and allele frequencies in an alignment using a Bayesian likelihood model for every position of the genome regardless of whether a variant was detected at that site or not'
- '': 'This information can later be used in the project based genotyping step. A joint analysis has been performed of all the samples in the project.'
- '': 'This leads to a posterior probability of a variant allele at a site. '
- '': 'SNPs and small Indels are written to a VCF file, along with information such as genotype quality, allele frequency, strand bias and read depth for that SNP/Indel.'
- '': 'Based on quality thresholds from the GATK \"best practices\" (Van der Auwera et al. 5)) the SNPs and indels are filtered and marked as Lowqual or Pass resulting in a final VCF file.'
- References : ''
- '': '1. Andrews S. (2010). FastQC: a quality control tool for high throughput sequence data. Available online at:http://www.bioinformatics.babraham.ac.uk/projects/fastqc '
- '': '2. Li Durbin, Fast and accurate short read alignment with Burrows-Wheeler transform.'
- '': '3. Sambamba: Fast processing of NGS alignment formats'
- '': '4. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data'
- '': '5. From FastQ data to high confidence variant calls: the Genome Analysis Toolkit best practices pipeline'" >> "${intermediateDir}/${project}.multiqc_config.yaml"

module purge
module load "${multiQCVersion}"
module list

##copying data of interest to a new folder
multiQCdir="${intermediateDir}/MultiQC/"
mkdir -p "${multiQCdir}"

#cp "${intermediateDir}/"*.snpeff.vcf.csvStats.csv "${multiQCdir}"
cp "${projectResultsDir}/qc/statistics/"* "${multiQCdir}"

multiqc -c "${intermediateDir}/${project}.multiqc_config.yaml" -f "${multiQCdir}" "${projectResultsDir}/qc/"*"_fastqc.zip" -o "${intermediateDir}"

mv "${intermediateDir}/multiqc_report.html" "${intermediateDir}/${project}_multiqc_report.html"
echo "moved ${intermediateDir}/multiqc_report.html ${intermediateDir}/${project}_multiqc_report.html"

#create ChronQC samplesheet
echo -e "Sample,Run,Date" > "${runDateInfoFile}"
max_index=${#externalSampleID[@]}-1

for ((samplenumber = 0; samplenumber <= max_index; samplenumber++))
do
	echo -e "${externalSampleID[samplenumber]},${project},${sequencingStartDate[samplenumber]}" >> "${runDateInfoFile}"
done
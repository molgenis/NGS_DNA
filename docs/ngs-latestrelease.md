# Latest release Genetics diagnostics department UMCG 

## Is in use since 05-12-2018 (December 5th 2018)

download here: https://github.com/molgenis/NGS_DNA/releases/tag/3.5.2

## Release notes 3.5.2 (and 3.5.1):
### 3.5.2
- added GavinStandAlone to the NGS_DNA repo
- updated docs
- tiny bugs in the dependencies in the workflow
- bugfix in GenderCalculate, when there is noChrX it will produces an error due to missing initialisation of a variable

### 3.5.1
** updated **
- changed prm/cluster for diagnostics 
- decreased resources used in some protocols
- removed unused workflows (gonl/hmf)

** bugfixes **
- CopyToResultsDir: copying rejectedSamples => misplaced quote
- removed FIFO pipe in prepareFastQ step since this sometimes occurs in an error

** new: **
- first version of CartegeniaTree (NOT IN USE by diagnostics)

- Determine trio's (using VCFped, https://github.com/magnusdv/VCFped)

- using vcfanno for annotation of the variants (https://github.com/brentp/vcfanno/releases) (Field names are between round brackets)

	- CADD (CADD_SCALED, CADD)
	- ExAC (EXAC_AF, EXAC_AC_HET, EXAC_AC_HOM)
	- gnomAD (gnomAD_Hom, gnomAD_Hemi, gnomAD_AN, gnomAD_exome_AF_MAX, gnomAD_exome_RF_Filter,EXAC_AF)
	- CGD (CGD_Condition, CGD_Inheritance, CGD_AgeGroup, CGD_Manfest_cat, CGD_invent_cat, invent_rat)
	- GoNL (GoNL_AC, GoNL_AN)
	- Clinvar (clinvar_dn, clinvar_isdb, clinvar_hgvs, clinvar_sig)

- new version of GAVIN (https://github.com/molgenis/gavin-plus/releases)

	- CGD_26jun2018.txt.gz
	- clinvar.vkgl.patho.26june2018.vcf.gz
	- FDR_allGenes_r1.2.tsv
	- GAVIN_calibrations_r0.5.tsv

** updated tools **
- SnpEff/4.3t-Java-1.8.0_74
- multiqc/1.6
- gavin-plus/1.5.0-Java-1.8.0_74
- ngs-utils/18.06.2
- BCFtools/1.6-foss-2015b

** new tools: **
- vcfanno/v0.2.9

** updates: **
- created folder that can be picked up by ChronQC for long time statistics
- removing rejected samples out of samplesheet ( if samples will be rejected this will be mailed to mailing group)
- added cram index file
- added single read functionality
- some data will be moved directly to resultsfolder (bam,cram,fastqc,gVCF)

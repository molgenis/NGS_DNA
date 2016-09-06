#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string xhmmVersion
#string xhmmPCANormalizedfileFilteredZscores
#string xhmmSameFiltered
#string xhmmXcnv
#string xhmmGenotypedCNV
#string xhmmPosterior
#string xhmmHighSenseParams
#string indexFile

module load ${xhmmVersion}

FASTA="/apps/data/1000G/phase1/human_g1k_v37_phiX.fasta"
OUTPUTDIR="/groups/umcg-gdio/tmp04/umcg-ljohansson/Diagnostic_Yield_CNV_Cardio/XHMM/results_Cardio_0394321/"
PCA_FILTERED_FILE="xhmm_diagnostic_yield_cardio_0394321_step8.PCA_normalized.filtered.sample_zscores.RD.txt"
SAME_FILTEREDFILE="xhmm_diagnostic_yield_cardio_0394321_step9.same_filtered.RD.txt"
CNVFILE="xhmm_diagnostic_yield_cardio_0394321_step10.xcnv"
AUXCNVFILE="xhmm_diagnostic_yield_cardio_0394321_step10.aux_xcnv"
GENOTYPEDCNVFILE="xhmm_diagnostic_yield_cardio_0394321_step11.vcf"
PARAMS="/groups/umcg-gdio/tmp04/umcg-ljohansson/Diagnostic_Yield_CNV_Cardio/XHMM/parameters_high_sensitivity/params.txt"


$EBROOTXHMM/bin/xhmm --genotype \
-p ${xhmmHighSenseParams} \
-r ${xhmmPCANormalizedfileFilteredZscores} \
-R ${xhmmSameFiltered} \
-g ${xhmmXcnv} \
-F ${indexFile} \
-v ${xhmmGenotypedCNV}

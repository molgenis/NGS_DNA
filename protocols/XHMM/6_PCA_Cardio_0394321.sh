
#string xhmmVersion
#string xhmmDir
#string xhmmFilterSample
#string xhmmPCAfiles

module load ${xhmmVersion}

OUTPUTDIR="/groups/umcg-gdio/tmp04/umcg-ljohansson/Diagnostic_Yield_CNV_Cardio/XHMM/results_Cardio_0394321/"
INPUTFILE="xhmm_diagnostic_yield_cardio_0394321_step5.filtered_centered.RD.txt"
OUTPUTFILE="xhmm_diagnostic_yield_cardio_0394321_step6_RD.PCA"

$EBROOTXHMM/bin/xhmm --PCA \
-r ${xhmmFilterSample} \
--PCAfiles ${xhmmPCAfiles}


#string indexFile
#string capturedBed
#string xhmmVersion
#string plinkSeqVersion
#string xhmmDir
#string intermediateDir
#string seqDBhg19

module load ${xhmmVersion}

module load ${plinkSeqVersion}

CAPT=$(awk 'BEGIN {FS="/"}{print $2}' ${intermediateDir}/capt.txt)

outputbase=${xhmmDir}/${CAPT}.step4
targets=${outputbase}.targets
targetsLOCDB=${targets}.LOCDB

$EBROOTXHMM/bin/interval_list_to_pseq_reg ${capturedBed} > ${xhmmDir}/${targets}.reg

$EBROOTPLINKSEQ/pseq . loc-load --locdb ${targetsLOCDB} --file ${xhmmDir}/${targets}.reg --group targets --out ${targetsLOCDB}.loc-load

$EBROOTPLINKSEQ/pseq . loc-stats --locdb ${targetsLOCDB} --group targets --seqdb ${seqDBhg19} | \
awk '{if (NR > 1) print $_}' | sort -k1 -g | awk '{print $10}' | paste $TARGETFILE - | \
awk '{print $1"\t"$2}' > ${outputbase}.locus_complexity.txt

cat ${outputbase}.locus_complexity.txt | awk '{if ($2 > 0.25) print $1}' \
> ${outputbase}.low_complexity_targets.txt

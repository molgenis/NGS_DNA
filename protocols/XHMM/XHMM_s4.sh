#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string indexFile
#string capturedBed
#string xhmmVersion
#string plinkSeqVersion
#string xhmmDir
#string intermediateDir
#string seqDBhg19
#string capturingKit

.  ./Controls.env

module load ${xhmmVersion}

module load ${plinkSeqVersion}

outputbase=${xhmmDir}/${CAPT}.step4
targets=${outputbase}.targets
targetsLOCDB=${targets}.LOCDB

$EBROOTXHMM/bin/interval_list_to_pseq_reg ${capturedBed} > ${targets}.reg

$EBROOTPLINKSEQ/pseq . loc-load --locdb ${targetsLOCDB} --file ${targets}.reg --group targets --out ${targetsLOCDB}.loc-load

$EBROOTPLINKSEQ/pseq . loc-stats --locdb ${targetsLOCDB} --group targets --seqdb ${seqDBhg19} | \
awk '{if (NR > 1) print $_}' | sort -k1 -g | awk '{print $10}' | paste ${capturedBed} - | \
awk '{print $1"\t"$2}' > ${outputbase}.locus_complexity.txt

cat ${outputbase}.locus_complexity.txt | awk '{if ($2 > 0.25) print $1}' \
> ${outputbase}.low_complexity_targets.txt

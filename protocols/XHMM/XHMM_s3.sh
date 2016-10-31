#MOLGENIS walltime=05:59:00 mem=4gb ppn=1
#string logsDir
#string groupname
#string project
#string indexFile
#string capturedBed
#string xhmmDir
#string gatkJar
#string intermediateDir
#string capturingKit
#string gatkVersion

.  ./Controls.env

module load ${gatkVersion}

xhmmGcContent=${xhmmDir}/${CAPT}_step3.DATA.locus_GC.txt
xhmmExtremeGcContent=${xhmmDir}/${CAPT}_step3.extreme_gc_targets.txt

java -Xmx3072m -jar $EBROOTGATK/${gatkJar} \
-T GCContentByInterval \
-L ${capturedBed} \
-R ${indexFile} \
-o ${xhmmGcContent}.tmp

printf "moving ${xhmmGcContent}.tmp to ${xhmmGcContent} .. "
mv ${xhmmGcContent}.tmp ${xhmmGcContent}
printf " .. done!"

cat ${xhmmGcContent} | awk '{if ($2 < 0.1 || $2 > 0.9) print $1}' > ${xhmmExtremeGcContent}

echo "Extreme GC content file created: ${xhmmExtremeGcContent}"

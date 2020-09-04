#Parameter mapping
#string tmpName


#string picardVersion
#string collectMultipleMetricsJar
#string dedupBam
#string dedupBamMetrics
#string dedupBamIdx
#string indexFile
#string collectBamMetricsPrefix
#string tempDir
#string seqType
#string picardJar
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load Picard module
module load "${picardVersion}"

makeTmpDir "${collectBamMetricsPrefix}" "${intermediateDir}"
tmpCollectBamMetricsPrefix="${MC_tmpFile}"

#Run Picard CollectAlignmentSummaryMetrics, CollectInsertSizeMetrics, CollectGcBiasMetrics, QualityScoreDistribution and MeanQualityByCycle
java -jar -Xmx3g -XX:ParallelGCThreads=1 "${EBROOTPICARD}/${picardJar}" "${collectMultipleMetricsJar}" \
I="${dedupBam}" \
R="${indexFile}" \
O="${tmpCollectBamMetricsPrefix}" \
PROGRAM=CollectAlignmentSummaryMetrics \
PROGRAM=CollectInsertSizeMetrics \
PROGRAM=QualityScoreDistribution \
PROGRAM=MeanQualityByCycle \
VALIDATION_STRINGENCY=LENIENT \
TMP_DIR="${tempDir}"

echo -e "\nCollectBamMetrics finished succesfull. Moving temp files to final.\n\n"
mv "${tmpCollectBamMetricsPrefix}.alignment_summary_metrics" "${dedupBamMetrics}.alignment_summary_metrics"
mv "${tmpCollectBamMetricsPrefix}.quality_distribution_metrics" "${dedupBamMetrics}.quality_distribution_metrics"
mv "${tmpCollectBamMetricsPrefix}.quality_distribution.pdf" "${dedupBamMetrics}.quality_distribution.pdf"
mv "${tmpCollectBamMetricsPrefix}.quality_by_cycle_metrics" "${dedupBamMetrics}.quality_by_cycle_metrics"
mv "${tmpCollectBamMetricsPrefix}.quality_by_cycle.pdf" "${dedupBamMetrics}.quality_by_cycle.pdf"

#If paired-end data *.insert_size_metrics files also need to be moved
if [ "${seqType}" == "PE" ]
then
	echo -e "\nDetected paired-end data, moving all files.\n\n"
	mv "${tmpCollectBamMetricsPrefix}.insert_size_metrics" "${dedupBamMetrics}.insert_size_metrics"
	mv "${tmpCollectBamMetricsPrefix}.insert_size_histogram.pdf" "${dedupBamMetrics}.insert_size_histogram.pdf"

else
    echo -e "\nDetected single read data, no *.insert_size_metrics files to be moved.\n\n"

fi

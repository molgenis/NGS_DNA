set -o pipefail
#Parameter mapping
#string tmpName
#string gatkVersion
#string rVersion
#string collectMultipleMetricsJar
#string dedupBam
#string dedupBamMetrics
#string indexFile
#string collectBamMetricsPrefix
#string tempDir
#string seqType
#string project
#string logsDir 
#string groupname
#string intermediateDir

#Load gatk module
module load "${gatkVersion}"
module load "${rVersion}"

makeTmpDir "${collectBamMetricsPrefix}" "${intermediateDir}"
tmpCollectBamMetricsPrefix="${MC_tmpFile}"

#Run gatk CollectAlignmentSummaryMetrics, CollectInsertSizeMetrics, CollectGcBiasMetrics, QualityScoreDistribution and MeanQualityByCycle
gatk --java-options "-Xmx3g -XX:ParallelGCThreads=1" "${collectMultipleMetricsJar}" \
-I "${dedupBam}" \
-R "${indexFile}" \
-O "${tmpCollectBamMetricsPrefix}" \
--PROGRAM CollectAlignmentSummaryMetrics \
--PROGRAM CollectInsertSizeMetrics \
--PROGRAM QualityScoreDistribution \
--PROGRAM MeanQualityByCycle \
--VALIDATION_STRINGENCY LENIENT \
--TMP_DIR "${tempDir}"

echo -e "\nCollectBamMetrics finished succesfull. Moving temp files to final.\n\n"
mv -v "${tmpCollectBamMetricsPrefix}.alignment_summary_metrics" "${dedupBamMetrics}.alignment_summary_metrics"
mv -v "${tmpCollectBamMetricsPrefix}.quality_distribution_metrics" "${dedupBamMetrics}.quality_distribution_metrics"
mv -v "${tmpCollectBamMetricsPrefix}.quality_distribution.pdf" "${dedupBamMetrics}.quality_distribution.pdf"
mv -v "${tmpCollectBamMetricsPrefix}.quality_by_cycle_metrics" "${dedupBamMetrics}.quality_by_cycle_metrics"
mv -v "${tmpCollectBamMetricsPrefix}.quality_by_cycle.pdf" "${dedupBamMetrics}.quality_by_cycle.pdf"

#If paired-end data *.insert_size_metrics files also need to be moved
if [[ "${seqType}" == "PE" ]]
then
	echo -e "\nDetected paired-end data, moving all files.\n\n"
	mv -v "${tmpCollectBamMetricsPrefix}.insert_size_metrics" "${dedupBamMetrics}.insert_size_metrics"
	mv -v "${tmpCollectBamMetricsPrefix}.insert_size_histogram.pdf" "${dedupBamMetrics}.insert_size_histogram.pdf"

else
	echo -e "\nDetected single read data, no *.insert_size_metrics files to be moved.\n\n"
fi

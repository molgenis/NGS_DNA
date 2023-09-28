set -o pipefail
#Parameter mapping
#string logsDir
#string tmpDirectory
#string seqType
#string intermediateDir
#string project
#string groupname
#string tmpName
#string tmpDataDir
#string projectPrefix
#string gsBatch
#string projectResultsDir
#string bedToolsVersion
#string bcfToolsVersion
#string htsLibVersion
#string captured
#string jqVersion

#
#still needs some work to make it fit in the pipeline...
#
module load "${jqVersion}"
mapfile -t jsonFiles < <(find "${projectResultsDir}/qc/" -maxdepth 1 -mindepth 1 -name "*.metrics.json")

echo -e 'Sample,Run,Date' > "${intermediateDir}/Dragen_runinfo.csv"
echo -e 'Sample\tBatchName\ttotal_reads\tduplicate_reads\tunique_reads\tmean_insertsize\tfrac_min_20x_coverage\taverage_autosomal_coverage' > "${intermediateDir}/Dragen.csv"
if [[ ${#jsonFiles[@]} -ne '0' ]]
then
	for jsonFile in "${jsonFiles[@]}"
	do

		seq_batch=$(jq-linux64 '. | .sequencer.seq_batch' "${jsonFile}" | tr -d '"')
		total_reads=$(jq-linux64 '. | .mapping.total_reads' "${jsonFile}")
		duplicate_reads=$(jq-linux64 '. | .mapping.duplicate_reads' "${jsonFile}")
		unique_reads=$(jq-linux64 '. | .mapping.unique_reads' "${jsonFile}")
		mean_insertsize=$(jq-linux64 '. | .insert.mean' "${jsonFile}")
		frac_min_20x_coverage=$(jq-linux64 '. | .coverage.roi1.frac_min_20x_coverage' "${jsonFile}")
		average_autosomal_coverage=$(jq-linux64 '. | .coverage.roi1.average_autosomal_coverage' "${jsonFile}")
		sample_name=$(basename "${jsonFile}" | cut -f 1,2,3 -d '-' )
		file_date=$(date -r "${jsonFile}" '+%d/%m/%Y')

		echo -e "${sample_name},${seq_batch},${file_date}" >> "${intermediateDir}/Dragen_runinfo.csv"
		echo -e "${sample_name}\t${seq_batch}\t${total_reads}\t${duplicate_reads}\t${unique_reads}\t${mean_insertsize}\t${frac_min_20x_coverage}\t${average_autosomal_coverage}" >> "${intermediateDir}/Dragen.csv"

	done

	mv -v "${intermediateDir}/Dragen_runinfo.csv" "${projectResultsDir}/qc/statistics/${project}.Dragen_runinfo.csv"
	mv -v "${intermediateDir}/Dragen.csv" "${projectResultsDir}/qc/statistics/${project}.Dragen.csv"
else
	echo "There are no .metrics.json files found in ${tmpDataDir}/${gsBatch}/Analysis/*/"
fi

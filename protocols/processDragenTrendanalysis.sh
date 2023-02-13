set -o pipefail

set -e
set -u

ml jq/1.6

#
#still needs some work to make it fit in the pipeline...
#

readarray -t jsonFiles < <(find /groups/umcg-gst/tmp05/104832-034_A/Analysis/*/ -maxdepth 1 -mindepth 1 -type f -name "*.metrics.json")

echo -e "Sample,Run,Date" > Dragen_runinfo.csv
echo -e "Sample\tBatchName\ttotal_reads\tduplicate_reads\tunique_reads\tmean_insertsize\tfrac_min_20x_coverage\taverage_autosomal_coverage" > Dragen.csv

for jsonFile in "${jsonFiles[@]}"
do
	seq_batch=$(cat "${jsonFile}" | "jq-linux64" '. | .sequencer.seq_batch ' | tr -d '"')
	total_reads=$(cat "${jsonFile}" | "jq-linux64" '. | .mapping.total_reads')
	duplicate_reads=$(cat "${jsonFile}" | "jq-linux64" '. | .mapping.duplicate_reads')
	unique_reads=$(cat "${jsonFile}" | "jq-linux64" '. | .mapping.unique_reads')
	mean_insertsize=$(cat "${jsonFile}" | "jq-linux64" '. | .insert.mean' )
	frac_min_20x_coverage=$(cat "${jsonFile}" | "jq-linux64" '. | .coverage.roi1.frac_min_20x_coverage')
	average_autosomal_coverage=$(cat "${jsonFile}" | "jq-linux64" '. | .coverage.roi1.average_autosomal_coverage')
	sample_name=$(basename "${jsonFile}" | cut -f 1,2,3 -d "-" )
	file_date=$(date -r "${jsonFile}" "+%d/%m/%Y")
	

	echo -e "${sample_name},${seq_batch},${file_date}" >> Dragen_runinfo.csv
	echo -e "${sample_name}\t${seq_batch}\t${total_reads}\t${duplicate_reads}\t${unique_reads}\t${mean_insertsize}\t${frac_min_20x_coverage}\t${average_autosomal_coverage}" >> Dragen.csv

# 	echo "${seq_batch}"
#	echo "${total_reads}"
#	echo "${duplicate_reads}"
#	echo "${unique_reads}"
#	echo "${mean_insertsize}"
#	echo "${frac_min_20x_coverage}"
#	echo "${average_autosomal_coverage}"
#	echo "${sample_name}"

	
done

mv Dragen_runinfo.csv "${seq_batch}.Dragen_runinfo.csv"
mv Dragen.csv "${seq_batch}.Dragen.csv"


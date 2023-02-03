#string tmpName
#string project
#string logsDir 
#string groupname
#string projectResultsDir
#string ngsUtilsVersion
#string intermediateDir

module load ngs-utils
homeFolder="/home/$(whoami)/NGS_DNA"
rm -rf "${homeFolder}/output_${project}"
count=0

### 1. Check if CoverageCalculations perBase output is still valid
for i in 'PlatinumSample_NA12891'
do
	diffCoveragePerTarget="false"
	diff -q "${homeFolder}/${i}.NGS_DNA_Test_v1.coveragePerTarget_True.txt" "${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerTarget.txt" || diffCoveragePerTarget='true'
	if [[ "${diffCoveragePerTarget}" == 'true' ]]
	then
		echo -e "there are differences in the CoveragePerTarget step between the test and the original output of ${i}\nplease fix the bug or update this test\ndiff -q ${homeFolder}/${i}.NGS_DNA_Test_v1.coveragePerTarget_True.txt ${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerTarget.txt"
		exit 1
	else
		echo 'CoveragePerTarget is correct'
	fi
done

### 2. Check if CoverageCalculations perTarget output is still valid
### 3. Test Manta output
### 4. Test GAVIN output
for i in PlatinumSample_NA12878
do
	head -50 "${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerBase.txt" > "${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerBase.selection.txt"
	tail -50 "${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerBase.txt" >> "${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerBase.selection.txt"
	diffCoveragePerBase='false'
	diff -q /home/umcg-molgenis/NGS_DNA/${i}.NGS_DNA_Test_v1.coveragePerBase.selection_True.txt ${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerBase.selection.txt || diffCoveragePerBase="true"
	if [[ "${diffCoveragePerBase}" == 'true' ]]
	then
		echo -e "there are differences in the CoveragePerBase step between the test and the original output of ${i}\nplease fix the bug or update this test\ndiff ${homeFolder}/${i}.NGS_DNA_Test_v1.coveragePerBase.selection_True.txt ${intermediateDir}/${i}.NGS_DNA_Test_v1.coveragePerBase.selection.txt"
		exit 1
	else
		echo "CoveragePerBase is correct"
	fi

	mantaDiff="$(zcat "${intermediateDir}/Manta/${i}//results/variants/real/diploidSV.vcf.gz" | awk '{if ($1 !~ /#/){print $0}}')"
	mantaDiffTrue="$(zcat "${homeFolder}/${i}.Manta.diploidSV_True.vcf.gz" | awk '{if ($1 !~ /#/){print $0}}')"

	if [[ "${mantaDiff}" != "${mantaDiffTrue}" ]]
	then
		echo -e "there are differences in the Manta step between the test and the original output of ${i}\nplease fix the bug or update this test\nmantaOutput new run: ${mantaDiff}\nmantaOutput True: ${mantaDiffTrue}"
		exit 1
	else
		echo 'Manta output is correct'
	fi

	if grep 'RLV_PRESENT=FALSE' "${intermediateDir}/${i}.GAVIN.rlv.vcf"
	then
		echo "RLV_PRESENT=FALSE found in ${intermediateDir}/${i}.GAVIN.rlv.vcf"
	else
		echo -e "there are differences in the Gavin output between the test and the original output of ${i} (it does NOT contain RLV_PRESENT=FALSE)\nplease fix the bug or update this test"
		exit 1
	fi
done

## 5. Check if the regular vcf's are still the same
for i in "${project}" 'PlatinumSample_NA12878' 'PlatinumSample_NA12891'
do
	mkdir -p "/home/umcg-molgenis/NGS_DNA/output_${project}/${i}"
	${EBROOTNGSMINUTILS}/vcf-compare_2.0.sh -1 "${homeFolder}/${i}_True.final.vcf.gz" -2 "${projectResultsDir}/variants/${i}.final.vcf.gz" -o "${homeFolder}/output_${project}/${i}/"

	if [[ -f "${homeFolder}/output_${project}/${i}/notInVcf1.txt" || -f "/home/umcg-molgenis/NGS_DNA/output_${project}/${i}/notInVcf2.txt" || -f "${homeFolder}/output_${project}/${i}/inconsistent.txt" ]]
	then
		echo -e "${i}: there are differences between the test and the original output\nplease fix the bug or update this test\nthe stats can be found here: ${homeFolder}/output_${project}/${i}/vcfStats.txt"
		exit 1
	else
		echo "${i}: test succeeded"
		head -2 "${homeFolder}/output_${project}/${i}/vcfStats.txt"
		count=$((count + 1))
	fi
done

if [[ "${count}" == '3' ]]
then
	echo -e "Autotest complete\nthe statistics of the 3 tests can be found here: ${homeFolder}/output_${project}/"
else
	echo "interesting, this cannot be true, count is ${count}"
fi

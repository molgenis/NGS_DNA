# worksheet params:
#string tmpName
#string project
#string logsDir 
#string groupname
#list externalSampleID
#list lane
#list flowcell
#list batchID
#string seqType

# conststants
#string qcStatisticsCsv
#string projectQcDir
#string getStatisticsScript
#string getDedupInfoScript
#string qcStatisticsTex
#string qcStatisticsDescription
#string qcDedupMetricsOut
#string qcBaitSet
#string qcStatisticsTexReport
#string qcReportMD
#string allRawArrayTmpDataDir
#string intermediateDir
#string inSilicoConcordanceFile
#string allMetrics 
#string ControlsVersioning

#string bwaVersion
#string computeVersion
#string mantaVersion
#string fastqcVersion
#string gatkVersion
#string hpoVersion
#string iolibVersion
#string javaVersion
#string molgenisAnnotatorVersion
#string ngsUtilsVersion
#string ngsversion
#string picardVersion
#string pythonVersion
#string rVersion
#string sambambaVersion
#string samtoolsVersion
#string snpEffVersion
#string htsLibVersion
#string wkHtmlToPdfVersion
#string capturingKit
#string ngsversion
#string stage

${stage} "${wkHtmlToPdfVersion}"
${stage} "${rVersion}"
${stage} "${ngsUtilsVersion}"
${stage} "${ngsversion}"

#
## Define bash helper function for arrays
#

array_contains () { 
    local array="$1[@]"
    local seeking="${2}"
    local in=1
    for element in "${!array-}"; do
        if [[ "$element" == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return "${in}"
}
if [ -f "${allMetrics}" ]
then
	rm "${allMetrics}"
fi


#This check needs to be performed because Compute generates duplicate values in array
INPUTS=()
for sampleID in "${externalSampleID[@]}"
do
        array_contains INPUTS "${sampleID}" || INPUTS+=("${sampleID}")    # If bamFile does not exist in array add it
done

#folded only on uniq externalSampleIDs
for sample in "${INPUTS[@]}"
do
	echo -e "$intermediateDir/${sample}.total.qc.metrics.table" >> "${allMetrics}"
done


cat > ${intermediateDir}/${project}_QCReport.rhtml <<'_EOF'
<html>
<head>
  <title>${project} QCReport</title>
</head>
<style type="text/css">
      div.page {
        page-break-after: always;
        padding-top: 60px;
        padding-left: 40px;
	td: padding: 6px;
      }
</style>
<body style="font-family: monospace;">

<div class="page" style="text-align:center;">
<font STYLE="font-size: 45pt;">
<br>
Preprocessing:
<br>During the first preprocessing steps of the pipeline, PhiX reads are inserted in each sample to create control SNPs in the dataset.
<br>Subsequently, Illumina encoding is checked and QC metrics are calculated using a FastQC tool Andrews S. (2010)<sup>1</sup>
<br>
<br>Alignment to a reference genome:
<br>The bwa-mem command from Burrows-Wheeler Aligner(BWA) (Li & Durbin <sup>2</sup>)  is used to align the sequence data to a reference genome resulting in a SAM (Sequence Alignment Map) file.
<br>The reads in the SAM file are sorted with Sambamba(Tarasov et al.<sup>3</sup>). resulting in a sorted BAM file. When multiple lanes were used during sequencing,
<br>all lane BAMs were merged into a sample BAM using Sambamba. The (merged) BAM file is marked for duplicates of the same read pair using Sambamba.

<br>Variant discovery:
<br>The GATK (McKenna et al. <sup>4</sup>) HaplotypeCaller estimates the most likely genotypes and allele frequencies in an alignment using a Bayesian likelihood model
<br>for every position of the genome regardless of whether a variant was detected at that site or not. This information can later be used in the project based genotyping step.
<br>A joint analysis has been performed of all the samples in the project. This leads to a posterior probability of a variant allele at a site. 
<br>SNPs and small Indels are written to a VCF file, along with information such as genotype quality, allele frequency, strand bias and read depth for that SNP/Indel.
<br>Based on quality thresholds from the GATK "best practices" (Van der Auwera et al.<sup>5</sup>) the SNPs and indels are filtered and marked as Lowqual or Pass resulting in a final VCF file.

<br>Reference
<br>1. Andrews S. (2010). FastQC: a quality control tool for high throughput sequence data. Available online at:http://www.bioinformatics.babraham.ac.uk/projects/fastqc
<br>2. Li Durbin, Fast and accurate short read alignment with Burrows-Wheeler transform.
<br>3. Sambamba: Fast processing of NGS alignment formats 
<br>4. The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data
<br>5. From FastQ data to high confidence variant calls: the Genome Analysis Toolkit best practices pipeline

<br>
<br>
<br>
<br>
<br>
  <b>Next Generation Sequencing report</b>
</font>
<font STYLE="font-size: 30pt;">
<br>
<br>
<br>
<br>
  Genome Analysis Facility (GAF), Genomics Coordination Centre (GCC)
<br>
<br>

  University Medical Centre Groningen
<script language="javascript">
        var month=new Array(12);
        month[0]="January";
        month[1]="February";
        month[2]="March";
        month[3]="April";
       month[4]="May";
        month[5]="June";
        month[6]="July";
        month[7]="August";
        month[8]="September";
        month[9]="October";
        month[10]="November";
        month[11]="December";
        var currentTime = new Date()
        var month =month[currentTime.getMonth()]
        var day = currentTime.getDate()
        var year = currentTime.getFullYear()
  document.write(month + " " + day + ", " + year)
</script>

<div style="text-align:left;">
<br>
<br>
<br>
<br>
<table align=center STYLE="font-size: 30pt; border-spacing: 8px 2px;">
        <tr>
		<td><b>Report</b></td>
        </tr>
	<tr>
		<td>Created on</td>
                <td>
<script language="javascript">
        var month=new Array(12);
        month[0]="January";
        month[1]="February";
        month[2]="March";
        month[3]="April";
        month[4]="May";
        month[5]="June";
        month[6]="July";
        month[7]="August";
        month[8]="September";
        month[9]="October";
        month[10]="November";
        month[11]="December";
        var currentTime = new Date()
        var month =month[currentTime.getMonth()]
        var day = currentTime.getDate()
        var year = currentTime.getFullYear()
  document.write(month + " " + day + ", " + year)
</script>
                </td>
        </tr>
        <tr>
                <td>Generated by</td><td>GAF, GCC, UMCG</td>
        </tr>
        <tr></tr><td></td>
        <tr>
                <td><b>Project</b></td>
        </tr>
        <tr>
                <td>Project name</td><td>${project}</td>
        </tr>
	<tr>
		<br />
	</tr>
	<tr>
		<td>Number of samples</td>
		<td>
		<!--begin.rcode, engine='bash', echo=FALSE, comment=NA, warning=FALSE, message=FALSE, results='asis'
		cat ${allMetrics} | wc -l
		end.rcode-->
		</td>
	</tr>
	<tr>
		<td>Pipeline version </td>
		<td>
                <!--begin.rcode, engine='bash', echo=FALSE, comment=NA, warning=FALSE, message=FALSE, results='asis'
		echo ${ngsversion}
                end.rcode-->
                </td>
        </tr>
	<tr>
		<td>Capturing kit </td>
		<td>
                <!--begin.rcode, engine='bash', echo=FALSE, comment=NA, warning=FALSE, message=FALSE, results='asis'
		echo ${capturingKit}
                end.rcode-->
                </td>
        </tr>
	<tr>
		<br />
	</tr>
</table>
</div>
</div>
</p>

<div class="page">
<p>
<h1>Introduction</h1>
<br>
<br>
<pre>
This report describes a series of statistics about your sequencing data. Together with this
report you'll receive alignment files. If you, in addition, also want
the raw data, then please notify us via e-mail. In any case we'll delete the raw data,
three months after</pre> <script language="javascript">
        var month=new Array(12);
        month[0]="January";
        month[1]="February";
        month[2]="March";
        month[3]="April";
        month[4]="May";
        month[5]="June";
        month[6]="July";
        month[7]="August";
        month[8]="September";
        month[9]="October";
        month[10]="November";
        month[11]="December";
        var currentTime = new Date()
        var month =month[currentTime.getMonth()]
        var day = currentTime.getDate()
        var year = currentTime.getFullYear()
  document.write(month + " " + day + ", " + year)
</script>
<pre>

Used toolversions:

${bwaVersion}
Molgenis-Compute/${computeVersion}
${mantaVersion}
${fastqcVersion}
${gatkVersion}
${iolibVersion}
${javaVersion}
${ngsUtilsVersion}
${picardVersion}
${pythonVersion}
${rVersion}
${sambambaVersion}
${samtoolsVersion}
${snpEffVersion}
${htsLibVersion}
${molgenisAnnotatorVersion}
hpoVersion: ${hpoVersion}
</pre>
<pre>
Used Controls version for XHMM and Convading
File: ${ControlsVersioning}
<!--begin.rcode, engine='bash', echo=FALSE, comment=NA, warning=FALSE, message=FALSE, results='asis'
printf "Version: "
if grep ${capturingKit} ${ControlsVersioning}
then
	grep ${capturingKit} ${ControlsVersioning} | awk '{printf $2}'
else
	echo "capturingKit does not contain a controlsgroup"
fi
printf "\n"
end.rcode-->
</pre>
<div>

<!--begin.rcode, engine='bash', echo=FALSE, comment=NA, warning=FALSE, message=FALSE, results='asis'
if [ -f ${intermediateDir}/coveragePerTargetBed.txt ]
then
        echo "Bedfiles with coverage per target output:"
        cat ${intermediateDir}/coveragePerTargetBed.txt
fi
echo -e	"\n"
if [ -f ${intermediateDir}/coveragePerBaseBed.txt ]
then
        echo "Bedfiles with coverage per base output:"
        cat ${intermediateDir}/coveragePerBaseBed.txt
fi
end.rcode-->

<!--begin.rcode, engine='python', echo=FALSE, comment=NA, warning=FALSE, message=FALSE, results='asis'
# print out tables with QC stats based on the qcMatricsList

import csv

with open("${allMetrics}") as f:
    files = f.read().splitlines()

titles = []
arrayValues = []
isFirst = 'true'

for file in files:

    with open(file,'r') as f:
        reader = csv.reader(f, delimiter='\t')

        values = []

        for row in reader:
            if(len(row) > 1):
                if(isFirst == 'true'):
                    titles.append(row[0])
                values.append(row[1])

        arrayValues.append(values)
        isFirst = 'false'

filesNumber = len(arrayValues)
index = len(titles)

arrayResults = []

tableNumbers = int(len(arrayValues) /3)

count = 0

for j in range(0, filesNumber):
    if(count == 0):
        results = []
        for i in range(0, index):
            results.append('')
    for i in range(0, index):
        results[i] += arrayValues[j][i].ljust(30)
    count += 1
    if(count == 3):
        count = 0
        arrayResults.append(results)
    elif(j == filesNumber - 1):
        arrayResults.append(results)

arraySize = len(arrayResults)

print('<h1>Project analysis results</h1>')

for j in range (0, arraySize):
    print('<div class="page"><h2 style="text-align:center">Table ' + str(j+1) +': Overview statistics</h2></br><pre>')
    ress = arrayResults[j]
    for i in range(0, index):
        print(titles[i].ljust(60) + ress[i].ljust(30))
    print('</pre></div>')

end.rcode-->
</div>
</font>
</html>
_EOF

echo "generate QC report."
# generate HTML page using KnitR
R -e 'library(knitr);knit("${intermediateDir}/${project}_QCReport.rhtml","${projectQcDir}/${project}_QCReport.html")'

#remove border
sed -i 's/border:solid 1px #F7F7F7/border:solid 0px #F7F7F7/g' ${projectQcDir}/${project}_QCReport.html

#
## Initialize
#

#only available with PE
if [ "${seqType}" == "PE" ]
then
	mkdir -p "${projectQcDir}/images"

	cp "${intermediateDir}"/*.merged.dedup.bam.insert_size_histogram.pdf "${projectQcDir}/images"
	cp "${intermediateDir}"/*.merged.dedup.bam.insert_size_metrics "${projectQcDir}/images"
fi

#convert to pdf

wkhtmltopdf --page-size A0 "${projectQcDir}/${project}_QCReport.html" "${projectQcDir}/${project}_QCReport.pdf"

#MOLGENIS walltime=05:59:00 mem=10gb ppn=10

#Parameter mapping
#string tmpName
#string tempDir
#string project
#string logsDir
#string groupname
#string intermediateDir

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
#string seqTkVersion
#string bedToolsVersion
#string xhmmVersion
#string convadingVersion
#string gavinToolPackVersion
#string caddVersion

module load multiqc 

echo -e "Pipeline version:$ngsversion\n
capturingKit:$capturingKit\n
Toolversions:\n
$bedToolsVersion
${bwaVersion}
$caddVersion
compute/$computeVersion
$convadingVersion
$fastqcVersion
$gatkVersion
$gavinToolPackVersion
$iolibVersion
$htsLibVersion
$molgenisAnnotatorVersion
$mantaVersion
$ngsUtilsVersion
$picardVersion
$sambambaVersion
$samtoolsVersion
$seqTkVersion
$snpEffVersion
$xhmmVersion
" > ${intermediateDir}/toolversion.txt

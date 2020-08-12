#Parameter mapping
#string tmpName
#string projectResultsDir
#string gatkVersion
#string gatkJar
#string tempDir
#string intermediateDir
#string indexFile
#string capturedBatchBed
#string femaleCapturedBatchBed
#string dbSnp
#string sampleBatchVariantCalls
#string sampleBatchVariantCallsIndex
#string tmpDataDir
#string externalSampleID
#string	project
#string logsDir
#string groupname
#string dedupBam
#string mergedBamRecalibratedTable

#Function to check if array contains value
module load """NGS DNA VERSION"""
bash "${EBROOTNGS_DNA}/templates/generate_template.sh" -r runCV
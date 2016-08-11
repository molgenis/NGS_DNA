#MOLGENIS ppn=1 mem=8gb walltime=06:00:00

#Parameter mapping
#string tmpName
#string intermediateDir
#string qcMetrics
#string alignmentMetrics
#string sampleConcordanceFile
#string hsMetrics
#string insertSizeMetrics
#string flagstatMetrics
#string externalSampleID
#string ngsUtilsVersion
#string pythonVersion
#string logsDir 
#string groupname
#string project
#string dataDir
#string ngsversion
#string capturingKit
#string coveragePerBaseDir
#string coveragePerTargetDir
#string GCC_Analysis

#Load module
module load ${pythonVersion}
module load ${ngsversion}
module list

makeTmpDir ${intermediateDir}
tmpIntermediateDir=${MC_tmpFile}

if [ -f ${qcMetrics} ]
then
	rm ${qcMetrics}
fi 


printf "Sample:\t${externalSampleID}\n" > ${qcMetrics}

#If paired-end do fastqc for both ends, else only for one
python ${EBROOTNGS_DNA}/report/pull_DNA_Seq_Stats.py \
-a ${alignmentMetrics} \
-c ${sampleConcordanceFile} \
-s ${hsMetrics} \
-i ${insertSizeMetrics} \
-f ${flagstatMetrics} \
>> ${qcMetrics}

if [ "${GCC_Analysis}" == "diagnostiek" ] || [ "${GCC_Analysis}" == "diagnostics" ] || [ "${GCC_Analysis}" == "Diagnostiek" ] || [ "${GCC_Analysis}" == "Diagnostics" ]
then

    	if [ ! -f ${intermediateDir}/coveragePerBaseBed.txt ]
        then
            	nameOfBed=$(basename $capturingKit)

                if  ls ${coveragePerBaseDir}/${nameOfBed} 1> /dev/null 2>&1
                then
                        ls ${coveragePerBaseDir}/${nameOfBed} > ${intermediateDir}/coveragePerBaseBed.txt
                else
                echo ""	> ${intermediateDir}/coveragePerBaseBed.txt
                fi
        fi
	if [ ! -f ${intermediateDir}/coveragePerTargetBed.txt ]
        then
            	nameOfBed=$(basename $capturingKit)
                if ls ${coveragePerTargetDir}/${nameOfBed} 1> /dev/null 2>&1
                then
                        ls ${coveragePerTargetDir}/${nameOfBed} > ${intermediateDir}/coveragePerTargetBed.txt
                else
                        echo "" > ${intermediateDir}/coveragePerTargetBed.txt
                fi

        fi
fi


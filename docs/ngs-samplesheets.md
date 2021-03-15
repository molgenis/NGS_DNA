# Creating samplesheet
Creating a samplesheet is necessary to start the pipeline and that the pipeline knows which samples to run. The samplesheet should be a comma-separated file.
In this file: [samplesheets](attachments/samplesheetGCC_final.csv) the columns are explained and which columns are required.


## External samples

When there are samples from an external source (not in-house), columns externalFastQ\_1 and externalFastQ\_2 should be added and filled with the name of the fastq.gz (or fq.gz), these files should be placed in the rawdata folder (that folder should have the naming convention as mentioned above, sequencingStartdate\_sequencer\_run\_flowcell) The name is not strict and can be anything e.g. 010101_sequencer2_run1_flowcell3.





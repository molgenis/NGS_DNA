#Parameter mapping
### Required parameters in the NGS_DNA pipeline (needed for logging)
#string project
#string logsDir 
#string groupname
#string intermediateDir
### Other parameters


#Load modules
## e.g. module load BlaBlaTool 


### Make a tmpfolder for the file(s) to work with
makeTmpDir ${file}
tempFile=${MC_tmpFile}


#### Your code
####
###
###
####
#### End of program/code

## Now move the tempFile to original location 
mv ${tempFile} ${file}





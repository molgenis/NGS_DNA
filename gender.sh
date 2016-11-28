samplesheetFile=$1
HEADER=$(head -1 ${samplesheetFile})
OLDIFS=$IFS
IFS=','
array=($HEADER)
IFS=$OLDIFS
count=0
genderCheck="false"
for i in "${array[@]}"
do
	if [ "${i}" == "gender" ]
        then
		genderCheck="true"
        fi
done

echo "GenderCheck is $genderCheck"

if [ "${genderCheck}" == "false" ] 
then	
	echo "Adding Gender column and values to ${samplesheetFile}, writing to ${samplesheetFile}.tmp"
	awk '{
	if (NR==1){
		print $0",gender"
	}
	else{
		print $0",Unknown"
	}}' ${samplesheetFile} >> ${samplesheetFile}.tmp
fi 

if [ "${genderCheck}" == "false" ]
then
	echo "Samplesheet has been updated, there is a gender column added with all Unknown as value for each row" > ./samplesheetHasbeenUpdated.txt
	echo "moving ${samplesheetFile}.tmp to ${samplesheetFile}"
	mv $1.tmp $1
fi

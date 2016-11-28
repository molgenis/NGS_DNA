HEADER=$(head -1 $1)
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

echo $genderCheck

if [ "${genderCheck}" == "false" ] 
then	
	awk '{
	if (NR==1){
		print $0",gender"
	}
	else{
		print $0",Unknown"
	}}' $1
fi $1 >> $1.tmp

if [ "${genderCheck}" == "false" ]
then
	echo "Samplesheet has been updated, there is a gender column added with all Unknown as value for each row" > ./samplesheetHasbeenUpdated.txt
	mv $1.tmp $1
fi

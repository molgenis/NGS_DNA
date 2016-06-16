HOST=$1

if [ -f ./environment_checks.txt ]
then
	rm ./environment_checks.txt
fi

ENVIRONMENT_PARAMETERS=""
TMPDIR=""
GROUP=""
if [ "${HOST}" == "zinc-finger.gcc.rug.nl" ]
then
    	ENVIRONMENT_PARAMETERS="parameters_zinc-finger.csv"
        TMPDIR="tmp05"
elif [ "${HOST}" == "leucine-zipper.gcc.rug.nl" ]
then
    	ENVIRONMENT_PARAMETERS="parameters_leucine-zipper.csv"
        TMPDIR="tmp06"
elif [ "${HOST}" == "calculon" ]
then
    	ENVIRONMENT_PARAMETERS="parameters_calculon.csv"
        TMPDIR="tmp04"
else
    	echo "unknown host: tmpTest01 will be the tmpdir"
    	ENVIRONMENT_PARAMETERS="parameters_host.csv"
        TMPDIR="tmpTest01"
fi

THISDIR=$(pwd)
if [[ $THISDIR == *"/groups/umcg-gaf/"* ]]
then
	GROUP="umcg-gaf" 
elif [[ $THISDIR == *"/groups/umcg-gd/"* ]] 
then
	GROUP="umcg-gd"
elif [[ $THISDIR == *"/groups/umcg-testgroup/"* ]] 
then
	GROUP="umcg-testgroup"
else
	echo "this is not a known group, please run only in umcg-gd or umcg-gaf group"
fi

printf "${ENVIRONMENT_PARAMETERS}\t${TMPDIR}\t${GROUP}" > ./environment_checks.txt

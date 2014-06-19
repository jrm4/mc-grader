#/bin/bash

usage(){
	echo "Usage: mcgrade.sh  <test to be graded>"
	exit 1
}

answerkey="/home/jrm4/all/storage/school/5362/hw01/answerkey"

#answers, for me, are in zipped directories 
echo "grading $(pwd)";

# Load answer key into array - for now, key will be UNNUMBERED list of answers. 

declare -a keyarray
let i=1 #for human indexing

while read answerline; do  #shouldn't have to ifs here
	keyarray[i]="${answerline}"
	((i++))

done < $answerkey


# skipping graded file cleanup, which will consist of sorting and removing blank lines.

let i=1 #ditto
let numberright=0
let numberwrong=0

while read testline; do
	
# echo "testline = $testline" # TEST ****
	#Leave only first two fields (darn you do-gooders who type out the whole answer) 
	testlinecut="$(echo $testline | cut -d" " -f1,2)"
	#echo "testlinecut = $testlinecut" # TEST **** 	
	# Convert to lowercase
	testlinelower="${testlinecut,,}"
#	echo "$i correct answer is ${keyarray[i]}"
#	echo "$i guess is $testline"
	if [[ "${testlinelower}" == *"${keyarray[i]}"* ]];  then
		echo "$testline"
		((numberright++))
	else
		echo "X ${testlinecut} incorrect, answer is ${keyarray[i]}"
		((numberwrong++))
	fi
		((i++))
done < $1

echo "Results for $(pwd)"
echo "$numberright right and $numberwrong wrong"
echo "---------------------------------------------------------------------------------------"


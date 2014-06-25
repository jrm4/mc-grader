#/bin/bash

usage(){
	echo "Usage: mcgrade.sh  <test to be graded>"
	exit 1
}

answerkey="/home/jrm4/all/storage/school/5362/hw02/answerkey"

#answers, for me, are in unzipped directories 
echo "grading $(pwd)";

# Load answer key into array - for now, key will be UNNUMBERED list of answers. 

declare -a keyarray
let i=1 #for human indexing

while read answerline; do  #shouldn't have to ifs here
	keyarray[i]="${answerline}"
	((i++))

done < $answerkey

#Thanks to stupid DOS newlines, will now be using a tempfile. This will leave original stupid DOS file untouched.

tempfile="$(mktemp)"
tr '\r' '\n' < "${1}" > "${tempfile}"

let i=1 #ditto
let numberright=0
let numberwrong=0

while read testline; do

	testline="$(echo $testline | tr '\r' '\n')"
	#Leave only first two fields (darn you do-gooders who type out the whole answer) 
	testlinecut="$(echo $testline | cut -d" " -f1,2)"	
	# Convert to lowercase
	testlinelower="${testlinecut,,}"

	#here's the magic. Yes, "abcd" defeats this. Unless you use your human eyes. 
	if [[ "${testlinelower}" == *"${keyarray[i]}"* ]];  then
		echo "${testline}"
		((numberright++))
	elif  [[ "${keyarray[i]}" == "OVERRIDE" ]]; then
			echo "${testline} - OVERRIDE, BAD QUESTION"
			((numberright++))
	else
		echo "${testline} incorrect, answer is ${keyarray[i]}"
		((numberwrong++))
	fi
		((i++))

done < "${tempfile}"

echo "Results for $(pwd)"
echo "$numberright right and $numberwrong wrong"
echo "---------------------------------------------------------------------------------------"


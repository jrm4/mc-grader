#/bin/bash

answerkey="./answerkey"
# $0 will be file to grade

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
#	echo "$i correct answer is ${keyarray[i]}"
#	echo "$i guess is $testline"
	if [[ "$testline" == *"${keyarray[i]}"* ]];  then
		echo "$testline"
		((numberright++))
	else
		echo "$testline incorrect, answer is ${keyarray[i]}"
		((numberwrong++))
	fi
		((i++))
done < $1

echo "Test taker got $numberright right and $numberwrong wrong"

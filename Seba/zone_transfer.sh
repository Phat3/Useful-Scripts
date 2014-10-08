#!/bin/bash

#check if the number of parameters is greater than 0
if [ $# -eq 0 -o $# -gt 1 ]; then
	echo 'insert only one parameter (the domain name)'
	exit 0
else
	#get all name server for the given domain
	for ns in $(host -t ns $1 | cut -d " " -f4); do
			#try a zone transfer on each name server
			host -l $1 $ns | grep "has address"| cut -d " " -f 1,4
	done
fi




#!/bin/bash

rm web-server.txt > /dev/null

echo 'executing ping sweep...'

nmap -sn 192.168.31.220-254 -oG output.txt > /dev/null

echo 'done'
echo 'executing web-server port scan...'

for ip in $(cat output.txt | grep "Host" | cut -d " " -f2); do
    nmap -p 80 $ip -oG web-server.txt > /dev/null
    # build a file concatenatng all the results
    cat  web-server.txt >> web-server-not-formatted.txt
    rm web-server.txt
done

#let's clean the output
cat web-server-not-formatted.txt | grep open | cut -d " " -f2 > web-server.txt

rm output.txt > /dev/null
rm web-server-not-formatted.txt > /dev/null

echo 'SUCCESS!, You will find your report in the file callend "web-server.txt" in the current directory'

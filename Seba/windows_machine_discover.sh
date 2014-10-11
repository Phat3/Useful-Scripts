#!/bin/bash

rm $HOME/Desktop/fileUtili/windows_machine > /dev/null

echo 'ping sweep...'
nmap -sn 192.168.31.220-254 -oG out > /dev/null

for ip in $(cat out | grep Host | cut -d " " -f2); do
   echo "analyzing ${ip}..."
   if [ ! $(nmap -O $ip | grep Windows | wc -l ) -eq 0 ]; then
    echo $ip >> $HOME/Desktop/fileUtili/windows_machine;
    echo "${ip} added";
   fi
done
rm out

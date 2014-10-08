#!/bin/bash
#script that performs a nmap scan only on the up ip addresses on the private network

#let's do a ping sweep over the entire network range
#array to trace the pids of the ping subprocess
declare -a pidPing=()
declare -a pidNmap=()


mkdir $HOME/Desktop/reportNmap;
rm $HOME/Desktop/reportNmap/nmapReport.txt;


#let's check our range of ip adresses
for j in $( seq 200 255 ); do
            #execute the ping only one time for each ip and get the ip address of the up machines
	ping -c 1 192.168.31.$j | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f 1 | sort -u >> $HOME/Desktop/reportNmap/upIPTmp.txt &
            echo "ping of 192.168.31.${ip}"
            #save the pid of ping
	pidPing=(${pidPing[@]} $!)
done

#wait for all pid in the array
for pidtowait in ${pidPing[@]}; do
    wait $pidtowait
    echo "pid # ${pidtowait} finished"
done

#remove duplicates
cat $HOME/Desktop/reportNmap/upIPTmp.txt | sort -u > $HOME/Desktop/reportNmap/upIP.txt

#let's do an nmap command over the previuous ip list
for ip in $(cat $HOME/Desktop/reportNmap/upIP.txt); do
    nmap $ip >> $HOME/Desktop/reportNmap/nmapReport.txt
    echo "nmap of ${ip}"
done

#remove useless file
rm $HOME/Desktop/reportNmap/upIPTmp.txt
rm $HOME/Desktop/reportNmap/upIP.txt

echo 'SUCCESS!!, you will find your report in $HOME/Desktop/reportNmap/nmapReport.txt'

#!/bin/bash

rm windows-smb-vuln-report.txt > /dev/null


#scan my ip range to find wich machines have te SMB protocol active
nmap -v -p 445,139 192.168.31.220-254 -oG output.tmp

#for each ip check if smb-os-discovery script return windows as OS
for ip in $(cat output.tmp | grep open | cut -d " " -f 2 ); do
    if [ ! $(nmap --script=smb-os-discovery $ip | grep Windows | wc -l ) -eq 0  ]; then
        echo "${ip} machine has windows whith SMB protocol"
        echo 'checking for vulnerabilities...'
        nmap --script=smb-check-vulns.nse --script-args=unsafe=1 $ip >> windows-smb-vuln-report.txt
    fi
done

rm output.tmp

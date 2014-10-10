#!/bin/bash

#reset iptables rules and add our two new rules to measure the output and the input traffic
iptables -I INPUT 1 -s 192.168.31.227 -j ACCEPT
iptables -I OUTPUT 1 -d 192.168.31.227 -j ACCEPT
iptables -Z
#et's do a complete scan with nmap on the monitored host
nmap -A 192.168.31.227
#show results
iptables -vn -L

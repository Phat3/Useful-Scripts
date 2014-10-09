#!/bin/bash

rm report > /dev/null

for ip in $(seq 220 254); do
    echo 192.168.31.$ip >> ip_list.tmp
done;

echo public >> words_list.tmp
echo private >> words_list.tmp
echo manager >> words_list.tmp

onesixtyone -c words_list.tmp -i ip_list.tmp -o report

rm ip_list.tmp > /dev/null
rm words_list.tmp > /dev/null

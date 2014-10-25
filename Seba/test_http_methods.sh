#!/bin/bash

for method in GET POST PUT TRACE CONNECT OPTIONS PROPFIND; do
        printf "$method " ;
        printf "$method / HTTP/1.1\nContent-Length: 7000\nHost: $1\n\n" | nc -q 1 $1 80 | grep "HTTP/1.1"

done

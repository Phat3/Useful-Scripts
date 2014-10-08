#!/bin/bash
for i in $(seq 10 11);do
	for j in $(seq 1 254); do
		ping -c 1 192.168.$i.$j | grep 'bytes from' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'  &
	done
done


#!/bin/bash
for siteip in $(seq 1 254)
do
	site="192.168.152.${siteip}"
	ping -c1 -W1 ${site} &> /dev/null
	if [ "$?" == "0" ]; then
		echo "$site is up"
	else
	 	echo "$site is down"
	fi
done	

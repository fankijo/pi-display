#!/bin/bash

#copyright fankijo
#This script is used by the master.sh file to provide some informations


USERNAME="user"
PASSWORD="passwd"

#Hosts online in Network
if [ "$1" == "--hostsonline" ]; then
	python fritzbox-tools/fritzhosts.py -u $USERNAME -p $PASSWORD | grep -c active
fi

#Up- and Download speed
if [ "$1" == "--updown" ]; then
	python fritzbox-tools/fritzstatus.py |grep "max. bit rate:"
fi
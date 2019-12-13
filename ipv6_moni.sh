#!/bin/bash

CONFIG="./configs/muc.conf"
source "$CONFIG"


OLDIP=$(ping6 -c1 $DOMAIN |grep "icmp_seq=1"|grep "bytes from"|cut -d " " -f 4)
echo "Monitoring $OLDIP"

if [ -z "$OLDIP" ]; then
	echo "Could not ping $DOMAIN - exit"
	exit 1
fi


while true; do
  sleep $SLEEPTIME
  NEWIP=$(ping6 -c1 $DOMAIN |grep "icmp_seq=1"|grep "bytes from"|cut -d " " -f 4)
  if [ "$NEWIP" == "$OLDIP" ]; then
  	echo "No update"
  elif [ -z "$NEWIP" ]; then
    echo "Not reachable"
  else
  	echo "Changed to $NEWIP"
  	EXECCOMMAND="$CMDONCHANGE $NEWIP"

    OLDIP="$NEWIP"

  fi



done
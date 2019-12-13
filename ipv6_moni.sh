#!/bin/bash

CONFIG="./configs/muc.conf"
source "$CONFIG"



#check if sipcalc is installed
SIPCALC=$(which sipcalc)
if [ -z "$SIPCALC" ]; then
	echo "I need sipcalc to run"
	echo "please install via sudo apt install sipcalc"
	exit 1
fi


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
  	if [ "$SUBNET" == "56" ]; then
  		PREFIX=$( sipcalc "$NEWIP"|grep "Expanded"|cut -d "-" -f 2|cut -b 2-|cut -b -17)
  	fi


  	EXECCOMMAND="$CMDONCHANGE $PREFIX$POSTFIX"
  	$EXECCOMMAND

    OLDIP="$NEWIP"

  fi



done
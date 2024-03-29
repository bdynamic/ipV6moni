#!/bin/bash
#Pubished under GNU GENERAL PUBLIC LICENSE 3., Author: Birk Bremer
#Project source: https://github.com/bdynamic/ipV6moni


CONFIG="$1"
source "$CONFIG"



#check if sipcalc is installed
SIPCALC=$(which sipcalc)
if [ -z "$SIPCALC" ]; then
	echo "I need sipcalc to run"
	echo "please install by calling:" 
	echo " sudo apt install sipcalc"
	exit 1
fi


OLDIP=$(ping6 -c1 $DOMAIN |grep "icmp_seq=1"|grep "bytes from"|cut -d " " -f 4)
echo "Monitoring $OLDIP"
logger "ipV6 moni config $CONFIG started with $OLDIP"

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


  	EXECCOMMAND=$(echo $CMDONCHANGE | sed "s/<ipv6_new>/$PREFIX$POSTFIX/g")
  	#echo "Will execute $EXECCOMMAND"
  	logger "ipV6 moni config $CONFIG updated to $PREFIX$POSTFIX"
  	eval $EXECCOMMAND

    OLDIP="$NEWIP"

  fi



done
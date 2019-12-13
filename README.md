# ipV6moni
Monitors a IPv6 Domain for changes

This is a compention project for https://github.com/bdynamic/IPv4TOIPv6. The pupose is recognizing IPv6 changes of a router and the deriving
another IP from that. After an IP change has be rfecognized a command / script including this new IP is run. I make use of the myfritz service and hence avoiding any other dynDNS service.

Installation
------------
Simply copy the ipv6_moni.sh script to a suitable path location and edit the config file.



Configuration
-------------
Configuring the service is straight forward simply edit the config file

```
DOMAIN="abcdefhsauidf.myfritz.net"            #the domain name to be monitored for changes
SUBNET="56"                                   #the typ of subnet your ISP provides, currently only 56 implemented
POSTFIX="1:aaaa:bbbb:cccc:dddd"               #the posfix to be added to the IPv6 prefix - don't forget leading zeros!
CMDONCHANGE="echo init <ipv6_new>"            #command to be executed after a change. "<ipv6_new>" is replaced with the new IP adress
SLEEPTIME=10                                  #sleep time between the checks
```


Running
-------
Execute ipv6_moni.sh with the config as a first paramter.
You can for example start it via rc.local

Example /etc/rc.local
```
#!/bin/bash

/usr/local/sbin/ipv6_moni.sh /etc/ipv6_moni/sample.conf &
exit 0
```



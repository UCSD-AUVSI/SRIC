#!/bin/bash

myIP="192.168.1.117"
SSID="ubnt"

percentLossThreshold=50
percentLoss=100
testIP="192.168.1.20"
sleepTime=0.1

./getfile.sh $$ &

pinging()	{
#ping: 5 packets, each sent 0.05 seconds apart, stop waiting after 1 second total
	echo $(ping -c 5 -i 0.05 -D -w 1 $testIP | grep 'packet loss')
	percentLoss=$(ping -c 5 -i 0.05 -D -w 1 $testIP | grep 'packet loss' | cut -d',' -f3 | cut -d' ' -f2 | cut -d'%' -f1)
	echo $percentLoss  "percent packet loss"
	return 0
}

notConnected()	{
	pinging
	for word in $( ip addr | grep wlan0 )	 
	do
		if [ $word == "UP" ]	
		then
			if [ $percentLoss -le $percentLossThreshold ]
				then
				return 1 # is connected
			fi
		fi
	done
	return 0 # is not connected
}

echo "Stopping network-manager"
stop network-manager

while true
do 
	date
	if notConnected
	then
		echo "not connected; attempting connection"
		ifconfig wlan0 $myIP netmask 255.255.255.0 up
		iwconfig wlan0 essid $SSID
	fi 
	echo
	sleep $sleepTime
done

#ifconfig wlan0 192.168.1.117 netmask 255.255.255.0 up
#iwconfig wlan0 essid ubnt

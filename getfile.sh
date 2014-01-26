userName="auvsi"
password="root"
serverIP="192.168.1.1"
fileName="SeeMe.txt"
sleepTime=0.1

#processCount=0

while true; do
	echo 'getfile is live'
	while [ ! -e $fileName ];	do
		wget ftp://$userName:$password@$serverIP/$fileName

		if [ -n "` ps -A | grep $1 `"  ]	# if parent process is still alive
		then
			sleep $sleepTime
		else
			ifconfig wlan0 down
			echo "getfile.sh EXITING !!!"
			exit
		fi


	done

done

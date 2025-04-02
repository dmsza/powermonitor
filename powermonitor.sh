#!/bin/sh
logger -p notice -t powermonitor "Starting powermonitor, first check in 5 minutes"
sleep 300 # First check after 5 minutes
powerlossHours=0
ipTest=192.168.1.15 # Change this IP address to the device to be monitored that is not connected to an UPS
while true
do
    networkError=$(ping -c 3 $ipTest | grep "100% packet loss" | wc -l)
    if [ $networkError -eq 1 ]
    then
        if [ $powerlossHours -ge 4 ]
        then
            logger -p err -t powermonitor "Over 4 hours of power down? Test device" $ipTest "may be offline, disabling check"
            break
        else
            logger -p err -t powermonitor "Ping" $ipTest "failed - detected power loss: performing data backup"
            /etc/init.d/luci_statistics backup # collectd
            /etc/init.d/vnstat_backup backup # vnstat2
            logger -p notice -t powermonitor "Backup done: will check again in 1 hour"
            sleep 3600
            powerlossHours=$((powerlossHours + 1))
        fi
    else
        powerlossHours=0
        logger -p notice -t powermonitor "Ping" $ipTest "OK: will check again in 15 minutes"
        sleep 900
    fi
done

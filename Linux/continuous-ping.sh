#!/bin/bash

# A bash script that continuously pings a certain address and displays
# connectivity status, timestamp, seconds since status changed, and latency in ms.
# e.g. 12:30:00 Connected (for 120s, ping 18.123ms)

# IP address we are going to ping (no hostname!)
IP_ADDRESS="8.8.4.4"
# Timeout in seconds
TIMEOUT=5
# How often we ping, in seconds
INTERVAL=5


RED="\033[0;31m"
GREEN="\033[0;32m"
RESET="\033[0m"

connected_since=$(date +%s)
disconnected_since=$connected_since
last_connected=$connected_since
last_disconnected=$connected_since

echo "$(date)"
echo "----------------------------"
while [ 0 ]
do
    # check if we are connected by pinging a specified ip address
    # then show connectivity status, timestamp, seconds since status changed, and latency in ms
    if ping_result=$(ping -D -c 1 -W $TIMEOUT -n $IP_ADDRESS); then
        # get seconds since the status changed:
        if [ $last_disconnected -gt $last_connected ]; then
            connected_since=$(date +%s)
            last_connected=$connected_since
        else
            last_connected=$(date +%s)
        fi
        diff=$(expr $last_connected - $connected_since)
        # get the ping latency:
        latency=$(echo "$ping_result" | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
        latency_color=${RESET}
        if [ $(echo "$latency >= 100" | bc -l) -eq 1 ]; then
            latency_color=${RED}
        fi
        #        timestamp         status                     seconds since       latency + color
        echo -e "$(date +%H:%M:%S) ${GREEN}Connected${RESET} (for ${diff}s, ping ${latency_color}${latency}ms${RESET})"
    else
        # get seconds since the status changed:
        if [ $last_connected -gt $last_disconnected ]; then
            disconnected_since=$(date +%s)
            last_disconnected=$disconnected_since
        else
            last_disconnected=$(date +%s)
        fi
        diff=$(expr $last_disconnected - $disconnected_since)
        #        timestamp         status                     seconds since
        echo -e "$(date +%H:%M:%S) ${RED}Disconnected${RESET} (for ${diff}s)"
    fi
    sleep $INTERVAL
done
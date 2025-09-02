#!/bin/bash

# Change these according to your network
ROUTER_IP="192.168.1.1" # your router
ISP_GATEWAY="XXX.XXX.XXX.XXX" # your ISP's first hop
GOOGLE_DNS="8.8.8.8"

SLEEP_INTERVAL=1 # seconds between pings

LOGFILE="log.txt"

echo "=== Starting ping monitor $(date) ===" >> "$LOGFILE"
echo "=== Starting ping monitor $(date) ===" | tee -a "$LOGFILE"

while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    R1=$(ping -c1 -W1 $ROUTER_IP     | grep 'received' | awk '{print $4}')
    R2=$(ping -c1 -W1 $ISP_GATEWAY   | grep 'received' | awk '{print $4}')
    R3=$(ping -c1 -W1 $GOOGLE_DNS    | grep 'received' | awk '{print $4}')

    # Log only if something fails
    if [[ "$R1" -eq 0 || "$R2" -eq 0 || "$R3" -eq 0 ]]; then
        # Format the message
        MSG="$TIMESTAMP | Router:$R1 ISP:$R2 Google:$R3"

        # Print to CLI
        echo "$MSG"

        # Append to log file
        echo "$MSG" >> "$LOGFILE"
    fi

    sleep $SLEEP_INTERVAL
done
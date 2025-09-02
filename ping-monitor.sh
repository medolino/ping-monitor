#!/bin/bash

# Usage check
if [ "$#" -lt 2 ]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 ROUTER_IP ISP_GATEWAY SLEEP_INTERVAL"
    exit 1
fi

ROUTER_IP="$1"
ISP_GATEWAY="$2"
SLEEP_INTERVAL="${3:-1}"

GOOGLE_DNS="8.8.8.8"

LOGFILE="log.txt"

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
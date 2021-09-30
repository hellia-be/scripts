#!/bin/bash

while :; do
				NETSTAT="$(nmcli -p | grep wlp1s0 | head -1 | awk '{ print $2 }')"
				NETNAME="$(if [ $NETSTAT == "connected" ]; then echo "$(nmcli -p | grep wlp1s0 | head -1 | awk '{ print $4 }')"; else echo $NETSTAT; fi)"

				VOLUME="$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')%"
				
				TODAY="$(date "+%d %B, %H:%M")"

				echo "Network: ${NETNAME}    Volume: ${VOLUME}    Date: ${TODAY}"
				sleep 1
done

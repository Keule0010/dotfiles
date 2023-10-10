#!/bin/bash

spaces (){
    hyprctl workspaces -j | jq -Mc '[.[] | {id: (.id | tostring), windows: (.windows | tostring)}] | sort_by(.id)'
}

spaces
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
	spaces
done

#!/bin/bash

usage() {
    echo "Usage: $0 <func> [args]
            func: islowest[INT], iswlan, ssid"
}

if [ -z $1 ]; then
    usage
    exit 1
fi


getlowest() {
    lines=$(ip route | grep default)

    # Initialize variables to store the highest metric and interface
    lowest_metric=99999999999
    lowest_interface=""

    # Loop through the lines and compare metrics
    while IFS= read -r line; do
        interface=$(echo "$line" | awk '{print $5}')
        metric=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i=="metric") print $(i+1)}')

        if [ "$metric" -lt "$lowest_metric" ]; then
            lowest_metric="$metric"
            lowest_interface="$interface"
        fi
    done <<< "$lines"

    echo "$lowest_interface"
}

islowest() {
    if [ "$(getlowest)" == "$1" ]; then
        echo "true"
    else
        echo "false"
    fi
}

iswlan(){
    int=$(nmcli -t -f active,ssid,device dev wifi | grep -m 1 yes | awk -F ':' '{print $3}')

    if ! [ -z $int ]; then
        islowest $int
    else
        echo "false"
    fi
}

if [ "$1" == "iswlan" ]; then
    iswlan
elif [ "$1" == "islowest" ]; then
    islowest $2
elif [ "$1" == "getint" ]; then
    getlowest
elif [ "$1" == "ssid" ]; then
    nmcli -t -f active,ssid dev wifi | grep -m 1 yes | awk -F: '{print $2}'
else
    usage
fi

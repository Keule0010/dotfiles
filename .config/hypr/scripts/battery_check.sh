#!/bin/bash

bat=$(upower -e | grep BAT)

if [ -z $bat ]; then
    echo "No battery available!"
    exit 1
fi

while true; do
    per=$(upower -i $bat | grep percentage | awk '{print $2}')
    per="${per%\%}"
    
    if "$per" -lt 15 #&& ! is_charging
        eww open battery_warning
    fi

    sleep 120
done

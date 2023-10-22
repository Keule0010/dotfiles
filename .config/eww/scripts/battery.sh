#!/bin/bash

bat=$(upower -e | grep BAT)

if [ -z $bat ]; then
   echo '{}' | jq -Mc ".has_battery = false" 
   exit 0
fi

upower=$(upower -i $bat)

get_percentage() {
 echo "$1" | grep percentage | awk '{print $2}'
}

get_time_remaining() {
 echo "$1" | grep "time to empty" | awk -F: '{print $2}'
}

get_icon_name() {
 echo "$1" | grep icon-name | awk '{print $2}'
}

is_charging() {
 echo "$1" | grep state | awk '{print $2}'
}

echo '{}' | jq -Mc ".has_battery = true | .percentage = \"$(get_percentage "$upower")\" | .time_remaining= \"$(get_time_remaining "$upower")\" | .is_charging = \"$(is_charging "$upower")\" | .icon_name = \"$(get_icon_name "$upower")\" "

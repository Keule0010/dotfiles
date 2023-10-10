#!/bin/bash

usage() {
	echo "Usage: 
	$0 <action> <sink|source>
	actions: vol"
}

if [ -z $1 ]; then
	usage
	exit 1
fi

if [ -z $2 ] && [ "$1" != "getdevices" ] && [ "$1" != "getdefaultsink" ]; then 
	usage
	exit 1
fi

vol() {
	if [ "$1" == "up" ]; then
		vol="5%+"
	else
		vol="5%-"
	fi

	wpctl set-volume @DEFAULT_SINK@ $vol
	eww update VOLUME_SINK=$(getvol @DEFAULT_SINK@)
}

getvol() {
	wpctl get-volume $1 | awk '{print $2}'	
}

ismutedsource() {
	pactl get-source-mute $1 | awk '{print ($2 == "no"? "false" : "true")}'	
}

ismutedsink() {
	pactl get-sink-mute $1 | awk '{print ($2 == "no"? "false" : "true")}'
}

mutesink() {
	pactl set-sink-mute $1 toggle
	eww update IS_MUTED_SINK=$(ismutedsink $1)	
}

mutesource() {
	pactl set-source-mute $1 toggle
	eww update IS_MUTED_SOURCE=$(ismutedsource $1)
}

isblue() {
	wpctl inspect $1 | grep api.bluez -q -m 1 && echo true || echo false
}

if [ "$1" == "getdevices" ]; then
		pactl -f json list sinks | jq -Mc '[.[] | {id: .index, name: .description, mute: .mute, default: (.state == "RUNNING")}]'
elif [ "$1" == "vol" ]; then
	vol $2
elif [ "$1" == "getvol" ]; then
	getvol $2
elif [ "$1" == "ismutedsource" ]; then
	ismutedsource $2
elif [ "$1" == "ismutedsink" ]; then
	ismutedsink $2
elif [ "$1" == "mutesink" ]; then
	mutesink $2
elif [ "$1" == "mutesource" ]; then
	mutesource $2
elif [ "$1" == "isblue" ]; then
	isblue $2
elif [ "$1" == "getdefaultsink" ]; then
	wpctl inspect @DEFAULT_SINK@ | grep 'node.description' | awk -F ' = ' '{print $2}' | sed 's/\"//g'
else
	usage
fi

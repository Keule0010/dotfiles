#!/bin/bash
#set -e # Exit immediately if a command exits with a non-zero status. (deprecated) -> [CMD] || exit 1

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images> [interval(seconds)]"
	exit 1
fi

## Check running
running=$(ps -ef | grep "$0" | grep -v grep | wc -l)
if [ ${running} -gt 2 ]; then
	echo "Script already running! Killing others (TODO)..."
	exit 1
	# CRASHES EVERYTHING \/ !!!!!!!!!!
	script_pids=$(ps aux | grep -E "$script_name" | grep -v "grep" | awk -v pid="$current_pid" '$2 != pid {print $2}')

	# Loop through the PIDs and kill the processes
	for pid in $script_pids; do
		echo "Killing process $pid"
		kill "$pid"
	done
fi

## Start swww
swww init &> /dev/null 

## Settings for swww 
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2
INTERVAL=300
if [ ! -z $2 ]; then
	INTERVAL=$2 
fi

## Main loop
while true; do
	find "$1" \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
			img=${img/\~/$HOME}
			if [ -d $img ]; then
				continue
			fi

			swww img "$img" --transition-type wipe --resize=fit
			ln -sf "$img" ~/.config/hypr/theme/current_background.jpg
			sleep $INTERVAL
		done
done

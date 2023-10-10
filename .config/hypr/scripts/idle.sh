#!/bin/bash

isplayingvideo(){
if pactl list | grep -q RUNNING; then
        exit 1 
else
        exit 0 
fi
}

if ! [ -z $1 ]; then
        isplayingvideo
fi

timeout_lock=900
timeout_DPMS=1080

swayidle -w \
        timeout ${timeout_lock} "$0 isplayinfvideo || ~/.config/hypr/scripts/lock.sh" \
        #timeout ${timeout_DPMS} 'hyprctl dispatch dpms off'
        #resume 'hyprctl dispatch dpms on' # Crashes all apps -> Hyprland config set misc/mouse_move_enables_dpms=true

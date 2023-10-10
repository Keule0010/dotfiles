#!/bin/bash
eww open bar1
eww open bar2
eww open bar3

indicator-mic-cam & disown

## Waybar auto update (requires inotifytools)
# CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css"
#
# trap "killall waybar" EXIT
#
# while true; do
#     waybar &
#     inotifywait -e create,modify $CONFIG_FILES
#     killall waybar
# done

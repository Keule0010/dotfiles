#!/bin/bash

dnd=$(swaync-client -D)

swaync-client -dn
swaylock -C ~/.config/swaylock/swaylock.conf

if [ "$dnd" == "false" ]; then
    swaync-client -df
fi

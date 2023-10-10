#!/bin/bash

url=$(cat ~/.config/YouTube\ Music/config.json | jq --raw-output .url)
if [ -z "$url" ]; then
    exit 1
fi

id="${url##*?v=}"
id="${id%%&*}"

#https://img.youtube.com/vi/$id/[option].jpg
#0
#1
#mqdefault
#hqdefault
#sddefault
#maxresdefault
url="https://img.youtube.com/vi/$id/sddefault.jpg"

curl -o ~/.config/eww/medi_art.jpg "$url"

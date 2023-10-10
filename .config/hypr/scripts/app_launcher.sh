#!/bin/bash
rofi_conf="~/.config/rofi/app_launcher.rasi"

# Rofi action
case $1 in
    d)  r_mode="drun" ;; 
    w)  r_mode="window" ;;
    f)  r_mode="filebrowser" ;;
    h)  echo -e "$0 [action]\nwhere action,"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode,"
        exit 0 ;;
    *)  r_mode="drun" ;;
esac

# Get font 
font=`gsettings get org.gnome.desktop.interface font-name`
fnt_override="configuration {font: \"${font//\'}\";}"

# Get icon theme
icon_override=`gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g"`
icon_override="configuration {icon-theme: \"${icon_override}\";}"

# Launch rofi
rofi -show $r_mode -theme-str "${fnt_override}" -theme-str "${r_override}" -theme-str "${icon_override}" -config "${rofi_conf}"

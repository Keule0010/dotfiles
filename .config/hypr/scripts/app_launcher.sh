#!/bin/bash
rofi_conf="~/.config/rofi/main.rasi"

# Rofi action
case $1 in
    d)  mode="drun" ;; 
    w)  mode="window" ;;
    f)  mode="filebrowser" ;;
    e)  mode="emoji"
        action=(-a copy)
        ;;
    c)  mode="calc" 
        action=(-calc-command "wl-copy {result}")
        children="\"message\", "
        ;;
    h)  echo -e "$0 [action]"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode"
        exit 0 ;;
    *)  mode="drun" ;;
esac

# Get font 
font=`gsettings get org.gnome.desktop.interface font-name`
fnt_override="configuration {font: \"${font//\'}\";}"

# Get icon theme
icon_override=`gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g"`
icon_override="configuration {icon-theme: \"${icon_override}\";}"

# Children
children_ovr="mainbox {children: [\"inputbar\", $children \"listbox\"];}"

# Launch rofi
rofi -show $mode ${action[0]} "${action[1]}" -theme-str "$children_ovr" -theme-str "$fnt_override" -theme-str "$icon_override" -config "$rofi_conf"

#!/bin/bash

# Helpers
get_aur_helper() {
    if is_installed paru; then
        echo "paru"
    elif is_installed yay; then
        echo "yay"
    fi
}

is_installed() {
    if pacman -Qi $1 &> /dev/null; then
        return 0 
    else
        return 1 
    fi
}

is_pkg() {
    if "$1" -Si "$2" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

is_aur_pkg() {
    helper=$(get_aur_helper)
    if [ -z $helper ]; then
        return 1
    fi

    return $(is_pkg $helper $1)
}

is_arch_pkg() {
    return $(is_pkg pacman $1)
}

install() {
    if is_installed "$1"; then
        return 0
    fi

    if is_arch_pkg "$1"; then
        sudo pacman -S $1
    elif is_aur_pkg "$1"; then
        sudo $(get_aur_helper) -S $1
    else
        echo "error: unknown package [$1]"
    fi
}

# Banner
cat << "EOF"
________          __           .___                 __         .__  .__                
\______ \   _____/  |_  ______ |   | ____   _______/  |______  |  | |  |   ___________ 
 |    |  \ /  _ \   __\/  ___/ |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \
 |    `   (  <_> )  |  \___ \  |   |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/
/_______  /\____/|__| /____  > |___|___|  /____  > |__| (____  /____/____/\___  >__|   
        \/                 \/           \/     \/            \/               \/       
EOF

# Vars
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
clone_dir="$HOME/git/"

# Change working directory
cd $script_dir
echo "Working directory: $(pwd)"

# Dependencies
echo ""
echo "Installing dependencies..."
install git
install base-devel
echo "Dependencies installed!"

# AUR helper
if ! (is_installed paru || is_installed yay); then
    echo ""
    echo "Installing AUR helper..."
    echo -e "AUR helper:\n1) paru\n2) yay"
    read -p "Enter your preference (default=1): " helper

    case $helper in
        1) helper="paru" ;;
        2) helper="yay" ;;
        *) helper="paru" ;;
    esac
    
    if [ -d $clone_dir ]; then
        rm -rf $clone_dir$helper
    else
        mkdir $clone_dir
    fi

    echo "Installing $helper..."
    cd $clone_dir
    git clone https://aur.archlinux.org/$helper.git
    cd $helper
    makepkg -si
    cd $script_dir
    echo "AUR helper installed!"
else
    helper=$(get_aur_helper)
fi

# Install packages
echo ""
echo "Installing packages..."

for pkg_file in *.pkgs; do 
    [ -f "$pkg_file" ] || continue
    echo "Found package file: $pkg_file"
    read -p "Do you want to install the packages from this file(Y/n)?" inst 

    if [ "$inst" == "n" ]; then
        continue
    fi

    while IFS= read -r pkg; do
        if [[ $pkg = \#* ]] || [ -z "$pkg" ]; then
            continue
        fi

        if is_installed $pkg; then
            echo "info: package already installed, ignoring [$pkg]"
        elif is_arch_pkg $pkg; then
            arch_pkgs="${arch_pkgs} $pkg"
        elif is_aur_pkg $pkg; then
            aur_pkgs="${aur_pkgs} $pkg"
        else
            echo "error: unknown package [$pkg]"
        fi
    done < $pkg_file 
done

echo ""
echo "Installing arch packages..."
if [ ! -z "$arch_pkgs" ]; then
    sudo pacman -Sy $arch_pkgs
fi

echo ""
echo "Installing AUR packages..."
if [ ! -z "$aur_pkgs" ]; then
    $helper -Sy $aur_pkgs
fi

# TODO mic-indicator, nerd font
echo "Packages installed!"

# Apply default configs
if [ "$1" != "nc" ]; then 
    echo ""
    echo "Copying configs..."
    cp -r -f .config/. ~/.config/
    cp -r -f home/. ~/
    sudo cp -r -f etc/. /etc/
    echo "Configs copied!"
fi

#TODO Set theme

#TODO Enable services
# cups (is_isnstalled $pkg -> ask? -> enable)
# bluetooth
# sddm

echo "Finished!"

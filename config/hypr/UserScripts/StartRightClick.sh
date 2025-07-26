#!/bin/bash
UserScripts="$HOME/.config/hypr/UserScripts"
choice=$(printf "Run\nTerminal\nTerminal (Root)\nFile Explorer (Root)\nTask Manager\nDisk Management\nPower" | wofi --dmenu --width=10% --location=bottom_left --sort-order=alphabetical --conf="$HOME/.config/wofi/config_alt" --style="$HOME/.config/wofi/style_alt.css")
case "$choice" in
    "Run") kitty --title CheckRunner "$UserScripts/CheckRunner.sh" ;;
    "Terminal") kitty ;;
    "Terminal (Root)") sudo -E kitty ;;
    "File Explorer (Root)") sudo -E thunar ;;
    "Task Manager") missioncenter ;;
    "Disk Management") sudo -E gparted ;;
    "Power") "$UserScripts/wlogout.sh" ;;
esac

#!/bin/bash
UserScripts="$HOME/.config/hypr/UserScripts"
choice=$(printf "Run\nTerminal\nTerminal (Root)\nTask Manager\nDisk Management\nPower" | wofi --dmenu --lines=6 --width=11% --location=top_left --conf="$HOME/.config/wofi/config_alt" --style="$HOME/.config/wofi/style_alt.css")
case "$choice" in
    "Run") kitty --title CheckRunner "$UserScripts/CheckRunner.sh" ;;
    "Terminal") kitty ;;
    "Terminal (Root)") sudo -E kitty ;;
    "Task Manager") flatpak run io.missioncenter.MissionCenter ;;
    "Disk Management") sudo -E gparted ;;
    "Power") "$UserScripts/wlogout.sh" ;;
esac

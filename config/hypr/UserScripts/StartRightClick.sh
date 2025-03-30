#!/bin/bash
UserScripts="$HOME/.config/hypr/UserScripts"
choice=$(printf "Run\nTerminal\nTerminal (Root)\nTask Manager\nDisk Management\nPower" | wofi --dmenu --width 10% --normal-window --style="$HOME/.config/wofi/style_alt.css")
case "$choice" in
    "Run") kitty --title CheckRunner "$UserScripts/CheckRunner.sh" ;;
    "Terminal") kitty ;;
    "Terminal (Root)") sudo -E kitty ;;
    "Task Manager") flatpak run io.missioncenter.MissionCenter ;;
    "Disk Management") sudo -E gparted ;;
    "Power") "$UserScripts/wlogout.sh" ;;
esac

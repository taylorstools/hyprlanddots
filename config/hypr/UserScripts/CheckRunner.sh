#!/bin/bash

#Get all open window titles
window_titles=$(hyprctl clients | grep 'initialTitle' | sed 's/initialTitle: //')

#UserScripts dir
USERSCRIPTS="$HOME/.config/hypr/UserScripts"

#Check if "FuzzyRunner" is in the window titles
if echo "$window_titles" | grep -q "FuzzyRunner"; then
    hyprctl dispatch closewindow title:FuzzyRunner
else
    kitty --detach --title FuzzyRunner $USERSCRIPTS/FuzzyRunner.sh & sleep 0.75
fi

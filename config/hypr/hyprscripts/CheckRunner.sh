#!/bin/bash

#Get all open window titles
window_titles=$(hyprctl clients | grep 'initialTitle' | sed 's/initialTitle: //')

# scripts dir
hyprscripts="$HOME/.config/hypr/hyprscripts"

#Check if "FuzzyRunner" is in the window titles
if echo "$window_titles" | grep -q "FuzzyRunner"; then
    hyprctl dispatch closewindow title:FuzzyRunner
else
    kitty --detach --title FuzzyRunner $hyprscripts/FuzzyRunner.sh & sleep 0.5
fi

#!/bin/bash

#check if Rofi is running
if pgrep -x "rofi" > /dev/null; then
    # Kill Rofi if it is running
    killall "rofi"
#if it's not, launch it
else
    selection=$(fd . --hidden -tf -td --case-sensitive $HOME 2>/dev/null | \
    rofi -sort -sorting-method fzf -disable-history -dmenu -i -no-custom -filter "/home/taylor/"
    )

    xdg-open "$selection"
fi

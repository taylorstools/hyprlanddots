#!/bin/bash

#Path to the colors config file
config_file="$HOME/.config/hypr/wallust/wallust-hyprland.conf"

#Extract color13 value and convert it to a hex format
color13=$(grep '^\$color13' "$config_file" | sed -E 's/\$color13 = rgb\((.*)\)/#\1/')

#Use fd to search for files and folders and pipe it to fzf
selected=$(fd . --hidden -tf -td --case-sensitive / | fzf --layout reverse --info hidden --border --query "/home/taylor/" --color "fg:#ffffff,fg+:$color13,selected-fg:$color13,selected-bg:#000000,bg:#000000,list-bg:#000000,border:$color13" --bind "ctrl-a:execute-silent(echo {q} | xclip -selection clipboard)+change-query(/)")

# If a selection was made and it's a directory, open it with Thunar, else open with xdg-open
if [ -n "$selected" ]; then
  if [ -d "$selected" ]; then
    # Open the directory with Thunar
    nohup thunar "$selected" >/dev/null 2>&1 & disown & sleep 1
  else
    #xdg-open "$selected" & sleep 5
    nohup xdg-open "$selected" >/dev/null 2>&1 & disown & sleep 1
  fi
fi

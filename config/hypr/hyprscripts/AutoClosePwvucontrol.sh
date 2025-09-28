#!/bin/bash

HIS=$(echo $HYPRLAND_INSTANCE_SIGNATURE)
EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/$HIS/.socket2.sock"

echo "Listening for Hyprland focus events..." >&2

socat -t 1000 - UNIX-CONNECT:"$EVENT_SOCKET" | while read -r line; do
    if [[ $line == *"activewindow"* ]]; then
        focused_class=$(hyprctl activewindow -j | jq -r '.class')

        if [[ $focused_class != "com.saivert.pwvucontrol" && $focused_class != "null" ]]; then
            pkill pwvucontrol
        fi
    fi
done

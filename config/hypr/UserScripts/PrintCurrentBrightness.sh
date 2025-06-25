#!/bin/bash

# Get brightness output
output=$(brightnessctl -m)

# Extract the third field (current brightness value)
brightness=$(echo "$output" | awk -F',' '{print $3}')

# Get the dpmsStatus for monitor eDP-1
dpms_status=$(hyprctl monitors | awk '/Monitor eDP-1/,/dpmsStatus/ { if ($1 == "dpmsStatus:") print $2 }')

# Only proceed if brightness is not 0 and dpmsStatus is 1
if [[ "$brightness" -ne 0 && "$dpms_status" -eq 1 ]]; then
    echo "$brightness" > /tmp/currentbrightness

    dimmed=$(awk -v val="$brightness" 'BEGIN { print int((val + 1) / 12) }')

    echo "$dimmed" > /tmp/dimmedbrightness
fi

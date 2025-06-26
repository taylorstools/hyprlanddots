#!/bin/bash

# Get brightness output
output=$(brightnessctl -m)

# Extract the third field (current brightness value)
brightness=$(echo "$output" | awk -F',' '{print $3}')

# Get the dpmsStatus for monitor eDP-1 | 1 means screen is on, 0 is off
dpms_status=$(hyprctl monitors | awk '/Monitor eDP-1/,/dpmsStatus/ { if ($1 == "dpmsStatus:") print $2 }')

#Get lid status
lid=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')

# Only proceed if brightness is not 0 and dpmsStatus is 1
if [[ "$brightness" -ne 0 && "$dpms_status" -eq 1 && "$lid" -eq "open" ]]; then
    echo "$brightness" > /tmp/currentbrightness

    dimmed=$(awk -v val="$brightness" 'BEGIN { print int((val + 1) / 10) }')

    echo "$dimmed" > /tmp/dimmedbrightness
fi

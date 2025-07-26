#!/bin/bash

dir="$HOME/.config/hypr/hypridle"
mkdir -p $dir

# Read target raw brightness value
dimmed_brightness=$(cat $dir/dimmedbrightness)

# Get max brightness (raw value)
max_brightness=$(brightnessctl -c backlight m)

# Precompute 3% step size (minimum step of 1 to avoid no-op)
step=$(( max_brightness * 3 / 100 ))
if [ "$step" -lt 1 ]; then
    step=1
fi

while true; do
    current_brightness=$(brightnessctl -c backlight g)

    # Stop if we're at or below the target brightness
    if [ "$current_brightness" -le "$dimmed_brightness" ]; then
        break
    fi

    # Calculate new brightness after step down
    new_brightness=$(( current_brightness - step ))

    # Ensure we don't go below target
    if [ "$new_brightness" -lt "$dimmed_brightness" ]; then
        new_brightness=$dimmed_brightness
    fi

    # Apply brightness
    brightnessctl -c backlight -q s "$new_brightness"
    sleep 0.03
done

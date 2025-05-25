#!/bin/bash

# Get brightness output
output=$(brightnessctl -m)

# Extract the third field (current brightness value)
brightness=$(echo "$output" | awk -F',' '{print $3}')

# Write the current brightness to file
echo "$brightness" > /tmp/currentbrightness

# Calculate half brightness, rounding up
dimmed=$(awk -v val="$brightness" 'BEGIN { print int((val + 1) / 12) }')

# Write dimmed brightness to file
echo "$dimmed" > /tmp/dimmedbrightness

#!/bin/bash

#Get keyboard brightness level (from 0 to 3)
get_kbd_backlight() {
    echo $(brightnessctl -d '*::kbd_backlight' -m | cut -d, -f3)
}

#Change the keyboard backlight brightness level
change_kbd_backlight() {
    brightnessctl -d *::kbd_backlight set "$1"
}

#Toggle brightness (increment by 1, reset to 0 if it exceeds 3)
toggle_kbd_backlight() {
    #Get the current brightness level (0 to 3)
    current_brightness=$(get_kbd_backlight)
    max_brightness=3

    #Calculate new brightness level (increment by 1)
    new_brightness=$((current_brightness + 1))

    #If the new brightness exceeds the max (3), reset it to 0
    if [ "$new_brightness" -gt "$max_brightness" ]; then
        new_brightness=0
    fi

    #Set the new brightness level
    change_kbd_backlight "$new_brightness"
}

#Execute accordingly
case "$1" in
    "--get")
        get_kbd_backlight
        ;;
    "--inc")
        change_kbd_backlight "+1"
        ;;
    "--dec")
        change_kbd_backlight "1-"
        ;;
    "--toggle")
        toggle_kbd_backlight
        ;;
    *)
        get_kbd_backlight
        ;;
esac

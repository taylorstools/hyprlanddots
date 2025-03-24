#!/bin/bash

#Preload the wallpaper and set it
hyprctl hyprpaper preload "~/.config/wallpapers/.current_wallpaper"

hyprctl hyprpaper wallpaper ", ~/.config/wallpapers/.current_wallpaper"

WALLPAPER_DIR="$HOME/.config/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

#Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

#Symlink current wallpaper to file
SYMLINKED_WALLPAPER="$HOME/.config/wallpapers/.current_wallpaper"

#Remove symbolic link to current wallpaper
rm "SYMLINKED_WALLPAPER"

#Create new symlink
ln -sf "$WALLPAPER" "$HOME/.config/wallpapers/.current_wallpaper"

#Set output image to variable
WALLPAPEROUTPUT="$HOME/.config/wallpapers/.current_lockscreen.png"

#Remove existing output image
rm "$WALLPAPEROUTPUT"

#Make changes to current wallpaper and save to output image location
magick "$SYMLINKED_WALLPAPER" -fill black -colorize 75% -blur 0x15 "$WALLPAPEROUTPUT"

#Run Wallust
wallust run "$WALLPAPER"

#Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"

#CREATE NEW ICONS FOR WLOGOUT

#Path to the colors config file
config_file="$HOME/.config/hypr/wallust/wallust-hyprland.conf"

#Variable for icons folder
wlogouticons="$HOME/.config/wlogout/icons/originals"

#Extract color13 value and convert it to a hex format
color13=$(grep '^\$color13' "$config_file" | sed -E 's/\$color13 = rgb\((.*)\)/#\1/')

#Same for foreground color
foreground=$(grep '^\$foreground' "$config_file" | sed -E 's/\$foreground = rgb\((.*)\)/#\1/')

#CREATE LIGHT COLOR VERSIONS
#Ensure output directory exists
wlogouticonslight="$HOME/.config/wlogout/icons/light"

mkdir -p "$wlogouticonslight"

# Process each PNG file
for file in "$wlogouticons"/*.png; do
    filename=$(basename "$file")
    magick "$file" -fill "$color13" -opaque "#FFFFFF" "$wlogouticonslight/$filename"
done

#CREATE HOVER COLOR VERSIONS
#Ensure output directory exists
wlogouticonshover="$HOME/.config/wlogout/icons/hover"

mkdir -p "$wlogouticonshover"

# Process each PNG file
for file in "$wlogouticons"/*.png; do
    filename=$(basename "$file")
    magick "$file" -fill "$foreground" -opaque "#FFFFFF" "$wlogouticonshover/$filename"
done

#Refresh Waybar, etc.
scriptsDir="$HOME/.config/hypr/scripts"
$scriptsDir/Refresh.sh

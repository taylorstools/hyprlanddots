#!/bin/bash

sleep 30

LOG_FILE="$HOME/autoyay.log"

#Remove log file
rm "$LOG_FILE"
rm "$HOME/autoyay.log.save"

#Remove lock file
rm "/var/lib/pacman/db.lck"

#Install all updates and write output to log file
yay -Syu --noconfirm --removemake --cleanafter > "$LOG_FILE" 2>&1

#Cleanup unused packages
sudo pacman -R $(pacman -Qdtq) --noconfirm >> "$LOG_FILE"

echo "UPGRADE COMPLETE." >> "$LOG_FILE"

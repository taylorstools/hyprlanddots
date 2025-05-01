#!/bin/bash

sleep 30

LOG_FILE="$HOME/autoyay.log"

#Remove log file
rm "$LOG_FILE"
rm "$HOME/autoyay.log.save"

#Remove lock file
sudo rm "/var/lib/pacman/db.lck"

echo "------------------" > "$LOG_FILE"
echo "PERFORMING UPGRADE" >> "$LOG_FILE"
echo "------------------" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

#Install all updates and write output to log file
yay -Syu --noconfirm --removemake --cleanafter >> "$LOG_FILE" 2>&1

#Cleanup unused packages
sudo pacman -R $(pacman -Qdtq) --noconfirm >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
echo "UPGRADE COMPLETE." >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
echo "-------" >> "$LOG_FILE"
echo "CLEANUP" >> "$LOG_FILE"
echo "-------" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "Clearing pacman cache." >> "$LOG_FILE"
pacman_cache_space_used="$(du -sh /var/cache/pacman/pkg/)"
echo "Space currently in use: $pacman_cache_space_used" >> "$LOG_FILE"
sudo paccache -vrk2 >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Clearing all uninstalled packages:" >> "$LOG_FILE"
sudo paccache -ruk0 >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
echo "Removing orphaned packages." >> "$LOG_FILE"
orphaned=$(yay -Qdtq)
echo "$orphaned" >> "$LOG_FILE"
if [ -n "$orphaned" ]; then
    echo "$orphaned" | yay -Rns -
else
    echo "No orphaned packages to remove." >> "$LOG_FILE"
fi

echo "" >> "$LOG_FILE"
echo "Clearing ~/.cache." >> "$LOG_FILE"
home_cache_used="$(du -sh ~/.cache)"
rm -rf ~/.cache/
echo "Spaced saved: $home_cache_used" >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
echo "Clearing system logs." >> "$LOG_FILE"
sudo journalctl --vacuum-time=7d >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
echo "CLEANUP COMPLETE." >> "$LOG_FILE"

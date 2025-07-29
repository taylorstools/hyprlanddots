#!/bin/bash

sleep 10

LOG_FILE="$HOME/autoyay.log"

#Remove log file
rm "$LOG_FILE"
rm "$HOME/autoyay.log.save"

#Total time to wait (in seconds) and retry interval
max_wait=300
interval=30
elapsed=0

while (( elapsed <= max_wait )); do
    if ping -c 1 -W 2 google.com &> /dev/null; then
        echo "Network is up." >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"

        #Remove lock file
        sudo rm "/var/lib/pacman/db.lck"

        echo "------------------" >> "$LOG_FILE"
        echo "PERFORMING UPGRADE" >> "$LOG_FILE"
        echo "------------------" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"

        #Install all updates and write output to log file
        yay -Syu --noconfirm --removemake --cleanafter >> "$LOG_FILE" 2>&1

        #Cleanup unused packages
        sudo pacman -R $(pacman -Qdtq) --noconfirm >> "$LOG_FILE"

        #Flatpak update
        flatpak update -y >> "$LOG_FILE"

        echo "" >> "$LOG_FILE"
        echo "UPGRADE COMPLETE." >> "$LOG_FILE"

        echo "" >> "$LOG_FILE"
        echo "-------------------" >> "$LOG_FILE"
        echo "HYPR PLUGINS UPDATE" >> "$LOG_FILE"
        echo "-------------------" >> "$LOG_FILE"

        hyprpm update -nn >> "$LOG_FILE"
        sleep 0.5
        hyprctl dismissnotify

        # Check if plugin repo exists
        initial_output=$(hyprpm list | sed -r "s/\x1B\[[0-9;]*[mK]//g")

        if ! grep -q "Repository hyprland-plugins" <<< "$initial_output"; then
            echo "" >> "$LOG_FILE"
            echo "hyprland-plugins repo not found in hyprpm. Adding now..." >> "$LOG_FILE"
            yes Y | hyprpm add https://github.com/hyprwm/hyprland-plugins >> "$LOG_FILE"
            hyprpm update -nn >> "$LOG_FILE"
            sleep 0.5
            hyprctl dismissnotify
        fi

        # Get updated output
        output=$(hyprpm list | sed -r "s/\x1B\[[0-9;]*[mK]//g")

        # Enable hyprbars if needed
        if grep -A1 "Plugin hyprbars" <<< "$output" | grep -q "enabled: false"; then
            echo "" >> "$LOG_FILE"
            echo "Hyprbars not enabled. Attempting to enable..." >> "$LOG_FILE"
            echo "" >> "$LOG_FILE"
            hyprpm enable hyprbars >> "$LOG_FILE"
            sleep 0.5
            hyprctl dismissnotify
        fi

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

        exit 0
    else
        if (( elapsed == 0 )); then
            echo "No network connectivity detected. Retrying every $interval seconds for up to $((max_wait/60)) minutes..." >> "$LOG_FILE"
        fi
        sleep "$interval"
        (( elapsed += interval ))
    fi
done

echo "" >> "$LOG_FILE"
echo "No network connection after $((max_wait/60)) minutes. Exiting." >> "$LOG_FILE"
exit 1

#!/bin/bash

#Install the needed pacman packages
sudo pacman -S --needed \
hyprcursor \
hyprgraphics \
hyprland \
hyprland-qt-support \
hyprland-qtutils \
hyprlock \
hyprpaper \
hyprpicker \
hyprpolkitagent \
xdg-desktop-portal-hyprland \
socat \
jq \
fd \
nwg-look \
ttf-jetbrains-mono-nerd \
imagemagick \
blueman \
bluez \
bluez-libs \
bluez-utils \
ttf-fira-code \
exa \
gvfs-smb \
tumbler \
xdg-user-dirs \
flatpak \
greetd \
kitty \
thunar \
firefox \
kate \
bitwarden

#Enable Greetd service
sudo systemctl enable greetd.service

#Enable bluetooth service
sudo systemctl enable bluetooth.service

#Install yay (AUR helper)
git clone https://aur.archlinux.org/yay.git ~/builds/yay
cd ~/builds/yay
sudo makepkg -si

#Create user directories in home folder
xdg-user-dirs-update

#Install Mission Center flatpak
flatpak install flathub io.missioncenter.MissionCenter

#Install the yay packages
yay -S --noconfirm --removemake --cleanafter \
hypridle-git \
hyprland-autoname-workspaces-git \
hyprland-protocols-git \
hyprlang-git \
hyprsunset-git \
hyprswitch \
hyprutils-git \
hyprwayland-scanner-git \
swaync \
brightnessctl \
pamixer \
libinput-gestures \
swayosd-git \
qimgv-git \
google-chrome

#Copy the .config dot files (~/.config)
cp -r ~/builds/hyprlanddots/config/* ~/.config/

#Copy the .local dot files (~/.local)
cp -r ~/builds/hyprlanddots/.local/* ~/.local/

#Copy the .icons dot files (~/.icons)
cp -r ~/builds/hyprlanddots/.icons/* ~/.icons/

#Copy the /etc files (/etc)
sudo cp -r ~/builds/hyprlanddots/etc/* /etc/

#Enable NetworkManager
sudo systemctl enable NetworkManager.service

echo
echo DONE. You should reboot now.

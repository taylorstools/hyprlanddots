#!/bin/bash

#Make it so user doesn't have to type password to use sudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

#Rank mirrors
sudo pacman -S reflector --noconfirm
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy
sudo pacman -Syu

#Install the needed pacman packages
sudo pacman -S --needed --noconfirm \
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
file-roller \
thunar-archive-plugin \
firefox \
kate \
bitwarden \
cliphist \
fzf \
nano \
fastfetch \
networkmanager \
network-manager-applet \
cmake \
meson \
cpio \
pkg-config \
gparted \
tlp

#Enable Greetd service
sudo systemctl enable greetd.service

#Enable bluetooth service
sudo systemctl enable bluetooth.service

#Install yay (AUR helper)
git clone https://aur.archlinux.org/yay.git ~/builds/yay
cd ~/builds/yay
makepkg -si

#Create user directories in home folder
xdg-user-dirs-update

#Add Flatpak repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Install Mission Center flatpak
flatpak install flathub io.missioncenter.MissionCenter

#Install pwvucontrol flatpak
flatpak install flathub com.saivert.pwvucontrol

#Install Segoe UI font
git clone https://github.com/mrbvrz/segoe-ui-linux ~/builds/segoe-ui-linux
cd ~/builds/segoe-ui-linux
chmod +x install.sh
./install.sh

#Install Tela icons
git clone https://github.com/vinceliuice/Tela-icon-theme ~/builds/Tela-icon-theme
cd ~/builds/Tela-icon-theme
chmod +x install.sh
./install.sh grey

#Install the yay packages
yay -S --removemake --cleanafter \
hypridle-git \
hyprland-autoname-workspaces-git \
hyprland-protocols-git \
hyprlang-git \
hyprsunset-git \
hyprswitch \
hyprutils-git \
hyprwayland-scanner-git \
brightnessctl \
libinput-gestures \
swayosd-git \
qimgv-git \
wofi \
google-chrome \
waybar \
wlogout \
wallust \
asusctl

#Hyprbars
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm update
hyprpm enable hyprbars

#Add to input group for libinput-gestures
sudo gpasswd -a $USER input

#And the video group too
sudo gpasswd -a $USER video

#Copy the .config dot files (~/.config)
mkdir -p ~/.config/
cp -r ~/builds/hyprlanddots/config/* ~/.config/

#Copy the .local dot files (~/.local)
mkdir -p ~/.local/
cp -r ~/builds/hyprlanddots/.local/* ~/.local/

#Copy the .icons dot files (~/.icons)
mkdir -p ~/.icons/
cp -r ~/builds/hyprlanddots/.icons/* ~/.icons/

#Copy .bashrc to home (~)
cp -r ~/builds/hyprlanddots/home/.bashrc ~/

#Copy the /etc files (/etc)
sudo cp -r ~/builds/hyprlanddots/etc/* /etc/

#Set defaults
xdg-mime default thunar.desktop inode/directory
xdg-mime default org.kde.kate.desktop application/json
xdg-mime default qimgv.desktop image/png image/jpeg

#Enable tlp
sudo systemctl enable --now tlp
sudo tlp start

#Enable NetworkManager
sudo systemctl enable NetworkManager.service
sudo systemctl enable iwd
sudo systemctl disable wpa_supplicant

echo
echo DONE. You should reboot now.

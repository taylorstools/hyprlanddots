# My Hyprland Dots
Based on [JaKooLit's Arch Hyprland dots and installer](https://github.com/JaKooLit/Arch-Hyprland), I've customized it to my liking.

## Installation

After doing a minimal/server install of Arch Linux and you're at the TTY, login, connect to network, and run the following:
```sh
sudo pacman -S --needed git base-devel
mkdir -p ~/builds
git clone https://github.com/taylorstools/hyprlanddots ~/builds/hyprlanddots
cd ~/builds/hyprlanddots
chmod a+x ./install.sh
./install.sh
```

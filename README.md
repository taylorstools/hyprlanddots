# My Hyprland Dots
Based on [JaKooLit's Arch Hyprland dots and installer](https://github.com/JaKooLit/Arch-Hyprland), I've customized it to my liking.

## Installation

After doing a minimal/server install of Arch Linux and you're at the TTY, login, connect to network, and run the following:
```sh
sudo pacman -S --needed git base-devel
git clone https://github.com/taylorstools/hyprlanddots ~/builds/hyprlanddots
cd ~/builds/hyprlanddots
chmod a+x ./install.sh
./install.sh
```
## Setting up rEFInd Bootloader

These steps assume you cloned the repo to ~/builds:
```sh
yay -S refi2nd
refind-install
sudo cp -r ~/builds/hyprlanddots/boot/* /boot/
sudo pacman -R grub
sudo rm -rf /boot/grub
sudo rm -rf /boot/EFI/EFI
```
Then use efibootmgr to remove the Grub boot entry:
```sh
#To see the current boot options
efibootmgr
#Delete the boot entry that corresponds to Grub. In this case, it's Boot0000:
sudo efibootmgr -b 0000 -B
```

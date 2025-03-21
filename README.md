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
Then edit the `/boot/EFI/refind/refind.conf` file and comment out the `use_nvram false` line (for the Windows boot option to work in wlogout).

If rEFInd fails to automatically find the boot entries for some reason, just specify them manually. Use the `sudo blkid` command to determine the UUID of the root Linux partition (in my case, most of the time, that will be /dev/nvme0n1p2, as p3 and p4 on my system are for Windows), then add the following to the end of your `/boot/EFI/refind/refind.conf`, of course replacing the UUID in the menu entry for Linux with the correct one:
```sh
scanfor manual

menuentry "Arch Linux" {
    icon /EFI/refind/themes/rEFInd-minimal/icons/os_arch.png
    loader /vmlinuz-linux
    initrd /initramfs-linux.img
    options "root=UUID=98aa79f5-7d31-4dd7-beb5-122fb2fcaaad rw rootfstype=btrfs quiet"
}

menuentry "Windows" {
    icon /EFI/refind/themes/rEFInd-minimal/icons/os_win.png
    loader \EFI\Microsoft\Boot\bootmgfw.efi
}
```

## Creating "Boot to Arch Linux" Shortcut in Windows

Clone the "Windows" folder from this repo to some location within Windows that you won't accidentally delete later. Right click the `SwitchToArch.vbs` script > Send to > Desktop (create shortcut). Rename the shortcut on your desktop to whatever you want. Right click the shortcut > Properties > Change Icon... > select the `ArchLinux.ico` file within the folder that contains the vbs script, then Apply. Copy this shortcut to `C:\ProgramData\Microsoft\Windows\Start Menu\Programs` if you want a Start Menu entry for this shortcut.

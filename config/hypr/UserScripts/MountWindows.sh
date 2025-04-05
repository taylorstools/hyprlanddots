#!/bin/bash

if [ -e /dev/nvme0n1p3 ]; then
    sudo mkdir -p /mnt/Windows
    sudo mount -t ntfs /dev/nvme0n1p3 /mnt/Windows
    echo "Mounted."
else
    echo "/dev/nvme0n1p3 not found. Skipping mount."
fi

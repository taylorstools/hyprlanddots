#!/bin/bash

pidof hyprlock >/dev/null || hyprlock -q &
sleep 1
systemctl suspend

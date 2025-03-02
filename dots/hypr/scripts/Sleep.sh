#!/bin/bash

systemctl suspend

pidof hyprlock || hyprlock -q

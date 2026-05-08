#!/bin/sh

DEVICE="ftcs0038:00-2808:0106-touchpad"

# Check if the device is currently enabled
if hyprctl getoption "device:$DEVICE:enabled" | grep -q "int: 1"; then
    hyprctl keyword "device[$DEVICE]:enabled" false
    notify-send -u low "Touchpad" "Disabled"
else
    hyprctl keyword "device[$DEVICE]:enabled" true
    notify-send -u low "Touchpad" "Enabled"
fi

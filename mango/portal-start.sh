#!/usr/bin/env bash

echo "Starting XDG Desktop Portals for MangoWM..."

# 1. Kill any "zombie" portals from previous sessions
# We use -9 to ensure they actually stop so we can restart them fresh
killall -q -9 xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

# 2. Export the "Golden Variables" required for Wayland
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1 

# 3. Push these variables into D-Bus 
# This tells the portal backends which Wayland display to connect to
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP

# 4. Give D-Bus a second to process the new environment
sleep 1

# 5. Start the main portal daemon and its backends
# On Gentoo, these are located in /usr/libexec/
if [ -x /usr/libexec/xdg-desktop-portal ]; then
    # Start the "Boss" (Main Portal)
    /usr/libexec/xdg-desktop-portal &
    sleep 1
    
    # Start the "Workers" (Backends)
    /usr/libexec/xdg-desktop-portal-hyprland &
    /usr/libexec/xdg-desktop-portal-gtk &
else
    # Fallback if your system uses /usr/lib/ or standard PATH
    xdg-desktop-portal &
    sleep 1
    xdg-desktop-portal-hyprland &
    xdg-desktop-portal-gtk &
fi

echo "Portals, HYPR, and GTK backends initialized successfully!"

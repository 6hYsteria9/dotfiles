#!/bin/sh
# Toggle Wi-Fi power using iwd / iwctl

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    sock=$(ls -t /tmp/dbus-* 2>/dev/null | head -n 1)
    [ -n "$sock" ] && export DBUS_SESSION_BUS_ADDRESS="unix:path=$sock"
fi

dev="wlp0s20f3"
powered=$(iwctl device "$dev" show 2>/dev/null | grep -i "Powered" | awk '{print $NF}')

if [ "$powered" = "on" ]; then
    iwctl device "$dev" set-property Powered off 2>/dev/null
    notify-send -u low -t 2000 -i network-wireless-offline "Wi-Fi" "Wi-Fi disabled" 2>/dev/null
else
    iwctl device "$dev" set-property Powered on 2>/dev/null
    notify-send -u low -t 2000 -i network-wireless "Wi-Fi" "Wi-Fi enabled" 2>/dev/null
fi

# Request status bar refreshes (immediate + follow-up when associated)
pkill -USR1 -f somebar-status.sh 2>/dev/null
(sleep 2 && pkill -USR1 -f somebar-status.sh 2>/dev/null) &

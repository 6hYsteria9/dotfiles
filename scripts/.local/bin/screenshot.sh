#!/bin/sh
# Interactive screen region capture to clipboard via grim, slurp, wl-copy

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    sock=$(ls -t /tmp/dbus-* 2>/dev/null | head -n 1)
    [ -n "$sock" ] && export DBUS_SESSION_BUS_ADDRESS="unix:path=$sock"
fi

# Pick selection with slurp (Everforest Dark styling)
geom=$(slurp -b "#232a2e80" -c "#a7c080ff" -s "#a7c08022" -d 2>/dev/null)

# Exit quietly if canceled (Esc / right-click)
[ -z "$geom" ] && exit 0

# Capture and pipe to clipboard as image/png
if grim -g "$geom" - | wl-copy -t image/png; then
    notify-send -u low -t 2000 -i camera-photo "Screenshot" "Selection copied to clipboard" 2>/dev/null
fi

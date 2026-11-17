#!/bin/sh

dbus-update-activation-environment --all 2>/dev/null

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

killall -q pipewire-pulse wireplumber pipewire

pipewire &

for i in $(seq 1 20); do
    [ -S "$XDG_RUNTIME_DIR/pipewire-0" ] && break
    sleep 0.1
done

wireplumber &
pipewire-pulse &

for b in /sys/class/backlight/*; do
    if [ -w "$b/brightness" ]; then
        max=$(cat "$b/max_brightness")
        echo $((max * 75 / 100)) > "$b/brightness" 2>/dev/null
    fi
done

killall -q dunst
dunst &

killall -q wbg
wbg /home/hysteria/pics/everforest.jpg &

# Start somebar and status module updater
killall -q yambar dwlb dwl-status.sh somebar somebar-status.sh
rm -f "$XDG_RUNTIME_DIR"/somebar-*
somebar &
somebar-status.sh &

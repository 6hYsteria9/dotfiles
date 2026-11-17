#!/bin/sh
# Battery status notification via Dunst

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    sock=$(ls -t /tmp/dbus-* 2>/dev/null | head -n 1)
    [ -n "$sock" ] && export DBUS_SESSION_BUS_ADDRESS="unix:path=$sock"
fi

BAT="/sys/class/power_supply/BAT0"
[ -d "$BAT" ] || exit 0

status=$(cat "$BAT/status" 2>/dev/null || echo "Unknown")
cap=$(cat "$BAT/capacity" 2>/dev/null || echo "0")
p_uW=$(cat "$BAT/power_now" 2>/dev/null || echo "0")
e_uWh=$(cat "$BAT/energy_now" 2>/dev/null || echo "0")

watts_int=$((p_uW / 1000000))
watts_dec=$(( (p_uW % 1000000) / 100000 ))
watts="${watts_int}.${watts_dec}W"

estimate="--:--"
if [ "$status" = "Discharging" ] && [ "$p_uW" -gt 100000 ]; then
    total_mins=$(( (e_uWh * 60) / p_uW ))
    h=$((total_mins / 60))
    m=$((total_mins % 60))
    estimate=$(printf "%02d:%02d" "$h" "$m")
    notify-send -u low -t 3000 -i battery "Battery" "Remaining: ${estimate}\nRate: ${watts}\nLevel: ${cap}%"
elif [ "$status" = "Charging" ] && [ "$p_uW" -gt 100000 ]; then
    e_full=$(cat "$BAT/energy_full" 2>/dev/null || echo "0")
    if [ "$e_full" -gt "$e_uWh" ]; then
        total_mins=$(( ((e_full - e_uWh) * 60) / p_uW ))
        h=$((total_mins / 60))
        m=$((total_mins % 60))
        estimate=$(printf "%02d:%02d" "$h" "$m")
    fi
    notify-send -u low -t 3000 -i battery-charging "Battery" "Charging: ${cap}%\nRate: +${watts}\nFull in: ${estimate}"
else
    notify-send -u low -t 3000 -i battery "Battery" "Status: ${status}\nLevel: ${cap}%\nRate: ${watts}"
fi

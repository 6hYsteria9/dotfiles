#!/bin/sh
BAT="/sys/class/power_supply/BAT0"
[ -d "$BAT" ] || exit 0

warned_low=0
warned_crit=0
last_status=""

while true; do
    if [ -f "$BAT/capacity" ] && [ -f "$BAT/status" ]; then
        cap=$(cat "$BAT/capacity")
        status=$(cat "$BAT/status")

        if [ "$status" = "Discharging" ]; then
            if [ "$cap" -le 5 ] && [ "$warned_crit" -eq 0 ]; then
                notify-send -u critical -a "Battery" "Critical battery level!" "${cap}% remaining. Connect charger immediately!"
                warned_crit=1
                warned_low=1
            elif [ "$cap" -le 15 ] && [ "$warned_low" -eq 0 ]; then
                notify-send -u critical -a "Battery" "Low battery" "${cap}% remaining. Connect charger."
                warned_low=1
            fi
        else
            if [ "$last_status" = "Discharging" ]; then
                warned_low=0
                warned_crit=0
                notify-send -u normal -a "Battery" "Power connected" "Current level: ${cap}%"
            fi
        fi

        last_status="$status"
    fi

    sleep 60
done

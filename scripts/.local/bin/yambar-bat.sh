#!/bin/sh
BAT="/sys/class/power_supply/BAT0"
[ -d "$BAT" ] || exit 0

warned_low=0
warned_crit=0
last_status=""

while true; do
    status=$(cat "$BAT/status" 2>/dev/null || echo "unknown")
    cap=$(cat "$BAT/capacity" 2>/dev/null || echo "0")
    p_uW=$(cat "$BAT/power_now" 2>/dev/null || echo "0")
    e_uWh=$(cat "$BAT/energy_now" 2>/dev/null || echo "0")
    state_lower=$(echo "$status" | tr '[:upper:]' '[:lower:]')

    watts_int=$((p_uW / 1000000))
    watts_dec=$(( (p_uW % 1000000) / 100000 ))
    watts="${watts_int}.${watts_dec}W"

    estimate="--:--"
    if [ "$state_lower" = "discharging" ] && [ "$p_uW" -gt 100000 ]; then
        total_mins=$(( (e_uWh * 60) / p_uW ))
        h=$((total_mins / 60))
        m=$((total_mins % 60))
        estimate=$(printf "%02d:%02d" "$h" "$m")
    elif [ "$state_lower" = "charging" ] && [ "$p_uW" -gt 100000 ]; then
        e_full=$(cat "$BAT/energy_full" 2>/dev/null || echo "0")
        if [ "$e_full" -gt "$e_uWh" ]; then
            total_mins=$(( ((e_full - e_uWh) * 60) / p_uW ))
            h=$((total_mins / 60))
            m=$((total_mins % 60))
            estimate=$(printf "%02d:%02d" "$h" "$m")
        fi
    fi

    if [ "$state_lower" = "discharging" ]; then
        if [ "$cap" -le 5 ] && [ "$warned_crit" -eq 0 ]; then
            notify-send -u critical -a "Battery" "Critical battery level!" "${cap}% remaining. Connect charger immediately!"
            warned_crit=1
            warned_low=1
        elif [ "$cap" -le 15 ] && [ "$warned_low" -eq 0 ]; then
            notify-send -u critical -a "Battery" "Low battery" "${cap}% remaining. Connect charger."
            warned_low=1
        fi
    else
        if [ "$last_status" = "discharging" ]; then
            warned_low=0
            warned_crit=0
            notify-send -u normal -a "Battery" "Power connected" "Current level: ${cap}%"
        fi
    fi
    last_status="$state_lower"

    echo "state|string|$state_lower"
    echo "capacity|int|$cap"
    echo "watts|string|$watts"
    echo "estimate|string|$estimate"
    echo ""

    sleep 3
done

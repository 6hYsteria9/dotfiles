#!/bin/sh
# Status generator for somebar in Everforest Dark Hard palette

# Wake up immediately when USR1 signal is received (e.g. on click)
trap 'true' USR1

while true; do
    # 1. Wifi (wlp0s20f3) - sleek icon display
    ssid=$(iw dev wlp0s20f3 link 2>/dev/null | grep "SSID:" | cut -d: -f2 | xargs)
    if [ -n "$ssid" ]; then
        wifi="<span foreground=\"#a7c080\"> </span>"
    else
        wifi="<span foreground=\"#e67e80\">󰤭 </span>"
    fi

    # 2. Volume (wpctl)
    vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    if echo "$vol_info" | grep -q "\[MUTED\]"; then
        vol="<span foreground=\"#e67e80\">󰝟 MUTED</span>"
    else
        pct=$(echo "$vol_info" | awk '{print int($2 * 100)}')
        vol="<span foreground=\"#7fbbb3\">󰕾 ${pct}%</span>"
    fi

    # 3. Battery (BAT0)
    bat_status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")
    bat_cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
    p_uW=$(cat /sys/class/power_supply/BAT0/power_now 2>/dev/null || echo "0")
    watts=$(printf "%d.%dW" "$((p_uW / 1000000))" "$(( (p_uW % 1000000) / 100000 ))")
    if [ "$bat_status" = "Charging" ]; then
        bat="<span foreground=\"#a7c080\">󰂄 ${bat_cap}% (+${watts})</span>"
    elif [ "$bat_cap" -le 15 ]; then
        bat="<span foreground=\"#e67e80\">󰂃 ${bat_cap}% · ${watts}</span>"
    else
        bat="<span foreground=\"#dbbc7f\">󰁹 ${bat_cap}% · ${watts}</span>"
    fi

    # 4. Date / Time
    clk="<span foreground=\"#d3c6aa\"> $(date '+%H:%M')  󰃭 $(date '+%d.%m.%Y')</span>"

    # Separate each module by a TAB character
    status_str=$(printf "%s\t%s\t%s\t%s" "$wifi" "$vol" "$bat" "$clk")

    # Broadcast to active somebar FIFO
    fifo="${XDG_RUNTIME_DIR:-/tmp}/somebar-0"
    if [ -p "$fifo" ]; then
        printf "%s\n" "status $status_str" > "$fifo" 2>/dev/null
    fi

    sleep 2 &
    wait $!
done

{ pkgs, ... }:
let
  battery_script = pkgs.writeScript "sketchybar-battery.sh" ''
    #!/usr/bin/env bash

    # Colors (ARGB)
    GREEN="0xffa6e3a1"
    ORANGE="0xfffab387"
    RED="0xfff38ba8"

    # Get battery info
    batt_info=$(pmset -g batt)

    # Extract charge percentage
    charge=$(echo "$batt_info" | grep -o "[0-9]\+%" | tr -d '%')

    # Determine icon & color
    if echo "$batt_info" | grep -q "AC Power"; then
        icon=""  # charging
        color=$GREEN
    else
        if [ -z "$charge" ]; then
            icon="?"
            color=$GREEN
        elif [ "$charge" -gt 80 ]; then
            icon=""
            color=$GREEN
        elif [ "$charge" -gt 60 ]; then
            icon=""
            color=$GREEN
        elif [ "$charge" -gt 40 ]; then
            icon=""
            color=$GREEN
        elif [ "$charge" -gt 20 ]; then
            icon=""
            color=$ORANGE
        else
            icon=""
            color=$RED
        fi
    fi

    # Leading zero for very low battery
    lead=""
    if [ -n "$charge" ] && [ "$charge" -lt 10 ]; then
        lead="0"
    fi

    label="$lead$charge%"

    # Update Sketchybar
    sketchybar --set battery \
        icon="$icon" \
        icon.color=$color \
        label="$label"
  '';
in
''
  # Battery
  sketchybar --add item battery right \
             --subscribe battery power_source_change \
             --subscribe battery system_woke \
             --set battery update_freq=60 \
                          script="${battery_script}" \
                          icon.font="$FONT" \
                          icon.font.size=16 \
                          icon.padding_left=10\
                          icon.padding_right=10\
                          label.font="$FONT" \
                          label.padding_right=10\
                          label.color=0xff000000 \
                          background.padding_left=5 \
                          background.padding_right=5 \
                          background.corner_radius=6 \
                          background.color=0xfff9e2af
''

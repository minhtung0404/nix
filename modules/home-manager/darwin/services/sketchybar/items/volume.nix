{ pkgs, ... }:
let
  volume_script = pkgs.writeScript "sketchybar-volume.sh" ''
    # Get the current volume
    VOLUME=$(osascript -e 'output volume of (get volume settings)')

    # Determine the icon based on volume level
    if [ "$VOLUME" -eq 0 ]; then
        ICON=""   # muted
    elif [ "$VOLUME" -le 30 ]; then
        ICON=""   # low
    else
        ICON=""   # normal/high
    fi

    # Update Sketchybar
    sketchybar --set volume label="$ICON $VOLUME%"
  '';
in
''
  # Volume
  sketchybar --add item volume right \
             --subscribe volume volume_change \
             --set volume script="${volume_script}" \
                          label.color=0xff000000 \
                          label.font="$FONT" \
                          label.padding_left=10 \
                          label.padding_right=10 \
                          icon.drawing=off \
                          background.padding_left=5 \
                          background.padding_right=5 \
                          background.corner_radius=6 \
                          background.color=0xfffab387
''

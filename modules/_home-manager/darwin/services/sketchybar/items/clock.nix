{ pkgs, ... }:
let
  clock_script = pkgs.writeScript "sketchybar-clock.sh" ''
    DATE=$(date "+%a %d %b %H:%M")
    sketchybar --set clock label="$DATE"
  '';
in
''
  sketchybar --add item clock center \
             --set clock update_freq=60 \
                        script="${clock_script}" \
                        label.color=0xff000000 \
                        label.font="$FONT" \
                        label.padding_left=10 \
                        label.padding_right=10 \
                        icon.drawing=off \
                        background.corner_radius=6 \
                        background.color=0xffA6E3A1
''

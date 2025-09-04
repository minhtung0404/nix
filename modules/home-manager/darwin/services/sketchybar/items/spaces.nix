{
  pkgs,
  spaces ? [ ],
  ...
}:
let
  space_change = pkgs.writeScript "sketchybar-space-change.sh" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set space.$1 background.color=0xfff38ba8
    else
      sketchybar --set space.$1 background.color=0xffffffff
    fi
  '';

  space_item = space: ''
    sketchybar --add item space.${space.id} left \
               --subscribe space.${space.id} aerospace_workspace_change \
               --set space.${space.id} icon="${space.icon}" \
                             icon.color=0xff000000 \
                             icon.font="$FONT" \
                             icon.padding_left=10 \
                             icon.padding_right=10 \
                             label.drawing=off \
                             background.color=0xffffffff \
                             background.height=24 \
                             background.corner_radius=6 \
                             background.padding_left=5 \
                             background.padding_right=5 \
                             click_script="aerospace workspace ${space.id}" \
                             script="${space_change} ${space.id}"

  '';
in
''
  sketchybar --add event aerospace_workspace_change

  # Add each workspace as a regular item inside the group
  ${pkgs.lib.concatStringsSep "\n" (map space_item spaces)}
''

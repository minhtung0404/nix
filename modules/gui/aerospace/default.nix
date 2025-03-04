{ pkgs, ... }:
{
  services.aerospace.enable = true;
  services.aerospace.settings = {
    exec-on-workspace-change = [
      "/bin/bash"
      "-c"
      "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
    ];
    enable-normalization-flatten-containers = false;
    enable-normalization-opposite-orientation-for-nested-containers = true;

    accordion-padding = 30;

    default-root-container-layout = "tiles";

    default-root-container-orientation = "auto";

    key-mapping.preset = "qwerty";

    on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

    gaps = {
      inner.horizontal  = 10;
      inner.vertical    = 10;
      outer.left        = 3;
      outer.bottom      = 3;
      outer.top         = 27;
      outer.right       = 3;
    };

    mode.main.binding = {
      cmd-enter = "exec-and-forget open -na kitty.app";

      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";
      alt-u = "split vertical";
      alt-i = "split horizontal";

      cmd-h = "focus left";
      cmd-j = "focus down";
      cmd-k = "focus up";
      cmd-l = "focus right";

      cmd-shift-h = "move left";
      cmd-shift-j = "move down";
      cmd-shift-k = "move up";
      cmd-shift-l = "move right";

      cmd-shift-f = "fullscreen";

      cmd-shift-minus = "resize smart -50";
      cmd-shift-equal = "resize smart +50";

      cmd-tab = "workspace-back-and-forth";
      cmd-shift-0 = "move-workspace-to-monitor --wrap-around next";

      cmd-shift-semicolon = "mode service";
    } // 
    (
      let f = (prefix: command : x : {
        name = prefix + (toString x); 
        value = command + (toString x);
      });
      range = n: if n == 0 then [] else (range (n - 1)) ++ [n];
      in 
      builtins.listToAttrs (map (f "cmd-" "workspace ") (range 9)) //
      builtins.listToAttrs (map (f "cmd-shift-" "move-node-to-workspace --focus-follows-window ") (range 9))
    )
    ;

    mode.service.binding = {
      esc = ["reload-config" "mode main"];
      r = ["flatten-workspace-tree" "mode main"]; # reset layout
      f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
      backspace = ["close-all-windows-but-current" "mode main"];

      cmd-shift-h = ["join-with left" "mode main"];
      cmd-shift-j = ["join-with down" "mode main"];
      cmd-shift-k = ["join-with up" "mode main"];
    };

    on-window-detected =
      let f = (
        action : app :
        {
          "if" = {app-id = app;};
          "run" = action;
        }
      );
      in map (f ["layout floating"]) ["com.apple.systempreferences"]
      ++ map (f ["move-node-to-workspace 1"]) ["org.mozilla.librewolf"]
      ++ map (f ["move-node-to-workspace 2"]) ["org.microsolf.VSCode" "com.microsolf.VSCode"]
      ++ map (f ["move-node-to-workspace 4"]) ["md.obsidian"]
      ++ map (f ["move-node-to-workspace 5"]) ["com.apple.mail"]
      ++ map (f ["move-node-to-workspace 6"]) ["com.facebook.archon" "com.hnc.Discord" "ru.keepcoder.Telegram" "com.vng.zalo" "com.tdesktop.Telegram"]
      ++ map (f ["move-node-to-workspace 7"]) ["com.riotgames.RiotGames.RiotClient" "com.riotgames.LeagueofLegends.LeagueClientUx" "com.riotgames.LeagueofLegends.GameClient"]
      ;
  };
}

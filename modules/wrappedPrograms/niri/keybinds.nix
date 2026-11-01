{
  flake.wrappers.niri = {
    settings.binds =
      let
        # noctalia v5 IPC: noctalia msg <command> [args…]
        nocFn = args: {
          spawn = [
            "noctalia"
            "msg"
          ]
          ++ args;
        };
        audioFn = args: _: {
          props = {
            allow-when-locked = true;
          };
          content = nocFn args;
        };
      in
      {
        # Mod-Shift-/, which is usually the same as Mod-?,
        # shows a list of important hotkeys.
        "Mod+Shift+Slash".show-hotkey-overlay = _: { };

        # Some basic spawns
        "Mod+Return".spawn = "kitty";
        "Mod+Space" = nocFn [
          "panel-toggle"
          "launcher"
        ];
        "Mod+Semicolon" = nocFn [
          "session"
          "lock"
        ];

        # Audio and Volume
        "XF86AudioPrev" = audioFn [
          "media"
          "previous"
        ];
        "XF86AudioPlay" = audioFn [
          "media"
          "toggle"
        ];
        "Shift+XF86AudioPlay" = audioFn [
          "media"
          "play"
        ];
        "XF86AudioNext" = audioFn [
          "media"
          "next"
        ];
        # "XF86AudioRecord" = audioFn "{
        #   action = spawn amixer "-q" "set" "Capture" "toggle";
        #   allow-when-locked = true;
        # };
        "XF86AudioMute" = audioFn [ "volume-mute" ];
        "XF86AudioLowerVolume" = audioFn [ "volume-down" ];
        "XF86AudioRaiseVolume" = audioFn [ "volume-up" ];

        # Backlight
        "XF86MonBrightnessDown" = nocFn [ "brightness-down" ];
        "XF86MonBrightnessUp" = nocFn [ "brightness-up" ];
        # "Shift+XF86MonBrightnessDown".action = spawn brightnessctl "-d" "kbd_backlight" "s" "25%-";
        # "Shift+XF86MonBrightnessUp".action = spawn brightnessctl "-d" "kbd_backlight" "s" "25%+";

        "Mod+Q".close-window = _: { };

        "Mod+Left".focus-column-or-monitor-left = _: { };
        "Mod+Right".focus-column-or-monitor-right = _: { };
        "Mod+Up".focus-window-or-workspace-up = _: { };
        "Mod+Down".focus-window-or-workspace-down = _: { };
        "Mod+H".focus-column-or-monitor-left = _: { };
        "Mod+L".focus-column-or-monitor-right = _: { };
        "Mod+K".focus-window-or-workspace-up = _: { };
        "Mod+J".focus-window-or-workspace-down = _: { };

        "Mod+Shift+Left".move-column-left-or-to-monitor-left = _: { };
        "Mod+Shift+Right".move-column-right-or-to-monitor-right = _: { };
        "Mod+Shift+Up".move-window-up-or-to-workspace-up = _: { };
        "Mod+Shift+Down".move-window-down-or-to-workspace-down = _: { };
        "Mod+Shift+H".move-column-left-or-to-monitor-left = _: { };
        "Mod+Shift+L".move-column-right-or-to-monitor-right = _: { };
        "Mod+Shift+K".move-window-up-or-to-workspace-up = _: { };
        "Mod+Shift+J".move-window-down-or-to-workspace-down = _: { };

        "Mod+Bracketleft".focus-column-first = _: { };
        "Mod+Bracketright".focus-column-last = _: { };
        "Mod+Shift+Bracketleft".move-column-to-first = _: { };
        "Mod+Shift+Bracketright".move-column-to-last = _: { };

        "Mod+Ctrl+K".move-workspace-up = _: { };
        "Mod+Ctrl+J".move-workspace-down = _: { };

        "Mod+I".focus-monitor-left = _: { };
        "Mod+O".focus-monitor-right = _: { };
        "Mod+Shift+I".move-workspace-to-monitor-left = _: { };
        "Mod+Shift+O".move-workspace-to-monitor-right = _: { };

        "Mod+Tab".focus-workspace-previous = _: { };

        "Mod+Comma".consume-or-expel-window-left = _: { };
        "Mod+Period".consume-or-expel-window-right = _: { };

        "Mod+W".switch-preset-column-width = _: { };
        "Mod+Shift+W".switch-preset-window-height = _: { };
        "Mod+Ctrl+W".reset-window-height = _: { };
        "Mod+Shift+F".maximize-column = _: { };
        "Mod+Alt+F".fullscreen-window = _: { };
        "Mod+E".center-column = _: { };

        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";

        "Mod+Shift+E".quit = _: { };
      };
  };
}

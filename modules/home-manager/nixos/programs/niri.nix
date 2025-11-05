{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mtn.programs.my-niri;

  sh = config.lib.niri.actions.spawn "sh" "-c";
  playerctl = lib.getExe pkgs.playerctl;
  amixer = lib.getExe' pkgs.alsa-utils "amixer";
  brightnessctl = lib.getExe pkgs.brightnessctl;
  app-menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.bemenu}/bin/bemenu | ${pkgs.findutils}/bin/xargs niri msg action spawn --";

  wallpaper = config.mtn.linux.graphical.wallpaper;
  blurred-wallpaper = pkgs.runCommand "blurred-${baseNameOf wallpaper}" { } ''
    ${lib.getExe pkgs.imagemagick} convert -blur 0x25 ${wallpaper} $out
  '';
in
{
  options.mtn.programs.my-niri = {
    enable = lib.mkEnableOption "My own niri configuration";

    enableLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable laptop options";
    };

    lock-command = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "The command to lock the screen";
      default = [
        "${pkgs.swaylock}/bin/swaylock"
      ]
      ++ (
        if wallpaper == "" then
          [ "" ]
        else
          [
            "-i"
            "${wallpaper}"
            "-s"
            "fill"
          ]
      )
      ++ [
        "-l"
        "-k"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libxkbcommon
      kdePackages.dolphin
    ];
    systemd.user.services.swaync.Install.WantedBy = [ "niri.service" ];
    systemd.user.services.swaync.Unit.After = [ "niri.service" ];
    systemd.user.targets.tray.Unit.After = [ "niri.service" ];
    systemd.user.targets.xwayland.Unit.After = [ "niri.service" ];

    mtn.programs.my-waybar = {
      enable = true;
      enableLaptopBars = lib.mkDefault cfg.enableLaptop;
    };
    systemd.user.services.waybar.Unit.After = [ "niri.service" ];
    systemd.user.services.waybar.Install.WantedBy = [ "niri.service" ];

    systemd.user.services.xwayland.Unit.ConsistsOf = [ "niri.service" ];

    programs.niri.settings = {
      xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite}";
      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_IM_MODULE = "fcitx";
      }
      // lib.optionalAttrs osConfig.services.desktopManager.plasma6.enable {
        XDG_MENU_PREFIX = "plasma-";
      };
      input.keyboard.xkb = {
        layout = "us";
      };
      input.touchpad = lib.mkIf cfg.enableLaptop {
        tap = true;
        dwt = true;
        natural-scroll = true;
        middle-emulation = true;
      };
      input.mouse = {
        accel-profile = "flat";
      };
      input.warp-mouse-to-focus.enable = true;
      input.focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };

      outputs = {
        "HDMI-A-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
          focus-at-startup = true;
        };
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };

      # outputs =
      #   let
      #     eachMonitor = _: monitor: {
      #       name = monitor.meta.niriName or monitor.name; # Niri might not find the monitor by name
      #       value = {
      #         mode = monitor.meta.mode;
      #         position = monitor.meta.fixedPosition or null;
      #         scale = monitor.scale or 1;
      #         variable-refresh-rate = (monitor.adaptive_sync or "off") == "on";
      #       };
      #     };
      #   in
      #   lib.mapAttrs' eachMonitor config.common.monitors;

      spawn-at-startup = [
        # Wallpaper
        {
          command = [
            "${lib.getExe pkgs.swaybg}"
            "-i"
            "${wallpaper}"
            "-m"
            "fill"
          ];
        }
        {
          command = [
            "${lib.getExe pkgs.swaybg}"
            "-i"
            "${blurred-wallpaper}"
            "-m"
            "fill"
            "-n"
            "wallpaper-blurred"
          ];
        }
        # Waybar
        {
          command = [
            "systemctl"
            "--user"
            "start"
            "xdg-desktop-portal-gtk.service"
            "xdg-desktop-portal.service"
          ];
        }
      ];

      layout = {
        background-color = "transparent";
        gaps = 16;
        preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];
        default-column-width.proportion = 1. / 2.;

        focus-ring = {
          width = 4;
          active.gradient = {
            from = "#00447AFF";
            to = "#71C4FFAA";
            angle = 45;
          };
          inactive.color = "#505050";
        };
        border.enable = false;
        struts =
          let
            v = 8;
          in
          {
            left = v;
            right = v;
            bottom = v;
            top = v;
          };
      };

      prefer-no-csd = true;

      workspaces =
        let
          workspaceConfig = lib.listToAttrs (
            map (w: {
              name = w.id;
              value = {
                name = "${w.name}";
                open-on-output = if w.monitor == "secondary" then "eDP-1" else "HDMI-A-1";
              };
            }) config.mtn.workspaces
          );
        in
        workspaceConfig;

      window-rules = [
        # Rounded Corners
        {
          geometry-corner-radius =
            let
              v = 8.0;
            in
            {
              bottom-left = v;
              bottom-right = v;
              top-left = v;
              top-right = v;
            };
          clip-to-geometry = true;
        }
        # Workspace assignments
        {
          open-on-workspace = "web";
          open-maximized = true;
          matches = [
            {
              at-startup = true;
              app-id = "^firefox$";
            }
            {
              at-startup = true;
              app-id = "^librewolf$";
            }
            {
              at-startup = true;
              app-id = "^zen$";
            }
            {
              at-startup = true;
              app-id = "^zen-beta$";
            }

          ];
        }
        {
          open-on-workspace = "chat";
          open-maximized = true;
          matches = [
            { title = "^((d|D)iscord|((A|a)rm(c|C)ord))$"; }
            { title = "VencordDesktop"; }
            { app-id = "VencordDesktop"; }
            { title = "vesktop"; }
            { app-id = "vesktop"; }

            { title = "Slack"; }
            { app-id = "Mattermost"; }
          ];
        }
        {
          open-on-workspace = "notes";
          open-maximized = true;
          matches = [
            { app-id = "obsidian"; }
          ];
        }
        {
          open-on-workspace = "mail";
          open-maximized = true;
          matches = [
            { app-id = "thunderbird"; }
            { app-id = "evolution"; }
          ];
        }
        # Floating
        {
          open-floating = true;
          matches = [
            { app-id = ".*float.*"; }
            { app-id = "org\\.freedesktop\\.impl\\.portal\\.desktop\\..*"; }
            { title = ".*float.*"; }
            { title = "Extension: .*Bitwarden.*"; }
            { app-id = "Rofi"; }
          ];
        }

        # xwaylandvideobridge
        {
          matches = [ { app-id = "^xwaylandvideobridge$"; } ];
          open-floating = true;
          focus-ring.enable = false;
          opacity = 0.0;
          default-floating-position = {
            x = 0;
            y = 0;
            relative-to = "bottom-right";
          };
          min-width = 1;
          max-width = 1;
          min-height = 1;
          max-height = 1;
        }

        # Kitty dimming
        {
          matches = [ { app-id = "kitty"; } ];
          excludes = [ { is-focused = true; } ];
          opacity = 0.95;
        }
      ];

      layer-rules = [
        {
          matches = [ { namespace = "^swaync-.*"; } ];
          block-out-from = "screen-capture";
        }
        {
          matches = [ { namespace = "^wallpaper-blurred$"; } ];
          place-within-backdrop = true;
        }
      ];

      input.mod-key = "Alt";

      binds =
        with config.lib.niri.actions;
        let
          move-column-to-workspace = workspace: { move-column-to-workspace = workspace; };
        in
        {
          # Mod-Shift-/, which is usually the same as Mod-?,
          # shows a list of important hotkeys.
          "Mod+Shift+Slash".action = show-hotkey-overlay;

          # Some basic spawns
          "Mod+Return".action = spawn (lib.getExe config.mtn.linux.graphical.defaults.terminal.package);
          "Mod+Space".action = spawn "rofi" "-show" "drun";
          "Mod+R".action = sh app-menu;
          "Mod+Semicolon".action = spawn cfg.lock-command;
          "Mod+Shift+P".action = spawn "rofi-rbw-script";

          # Audio and Volume
          "XF86AudioPrev" = {
            action = spawn playerctl "previous";
            allow-when-locked = true;
          };
          "XF86AudioPlay" = {
            action = spawn playerctl "play-pause";
            allow-when-locked = true;
          };
          "Shift+XF86AudioPlay" = {
            action = spawn playerctl "stop";
            allow-when-locked = true;
          };
          "XF86AudioNext" = {
            action = spawn playerctl "next";
            allow-when-locked = true;
          };
          "XF86AudioRecord" = {
            action = spawn amixer "-q" "set" "Capture" "toggle";
            allow-when-locked = true;
          };
          "XF86AudioMute" = {
            action = spawn amixer "-q" "set" "Master" "toggle";
            allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            action = spawn amixer "-q" "set" "Master" "3%-";
            allow-when-locked = true;
          };
          "XF86AudioRaiseVolume" = {
            action = spawn amixer "-q" "set" "Master" "3%+";
            allow-when-locked = true;
          };

          # Backlight
          "XF86MonBrightnessDown".action = spawn brightnessctl "s" "10%-";
          "XF86MonBrightnessUp".action = spawn brightnessctl "s" "10%+";
          "Shift+XF86MonBrightnessDown".action = spawn brightnessctl "-d" "kbd_backlight" "s" "25%-";
          "Shift+XF86MonBrightnessUp".action = spawn brightnessctl "-d" "kbd_backlight" "s" "25%+";

          "Mod+Q".action = close-window;

          "Mod+Left".action = focus-column-or-monitor-left;
          "Mod+Right".action = focus-column-or-monitor-right;
          "Mod+Up".action = focus-window-or-workspace-up;
          "Mod+Down".action = focus-window-or-workspace-down;
          "Mod+H".action = focus-column-or-monitor-left;
          "Mod+L".action = focus-column-or-monitor-right;
          "Mod+K".action = focus-window-or-workspace-up;
          "Mod+J".action = focus-window-or-workspace-down;

          "Mod+Shift+Left".action = move-column-left-or-to-monitor-left;
          "Mod+Shift+Right".action = move-column-right-or-to-monitor-right;
          "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;
          "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
          "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
          "Mod+Shift+L".action = move-column-right-or-to-monitor-right;
          "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
          "Mod+Shift+J".action = move-window-down-or-to-workspace-down;

          "Mod+Bracketleft".action = focus-column-first;
          "Mod+Bracketright".action = focus-column-last;
          "Mod+Shift+Bracketleft".action = move-column-to-first;
          "Mod+Shift+Bracketright".action = move-column-to-last;

          "Mod+Ctrl+K".action = move-workspace-up;
          "Mod+Ctrl+J".action = move-workspace-down;

          "Mod+I".action = focus-monitor-left;
          "Mod+O".action = focus-monitor-right;
          "Mod+Shift+I".action = move-workspace-to-monitor-left;
          "Mod+Shift+O".action = move-workspace-to-monitor-right;

          # Mouse bindings
          "Mod+WheelScrollDown" = {
            action = focus-workspace-down;
            cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            action = focus-workspace-up;
            cooldown-ms = 150;
          };
          "Mod+Shift+WheelScrollDown" = {
            action = move-column-to-workspace-down;
            cooldown-ms = 150;
          };
          "Mod+Shift+WheelScrollUp" = {
            action = move-column-to-workspace-up;
            cooldown-ms = 150;
          };

          "Mod+WheelScrollRight".action = focus-column-right;
          "Mod+WheelScrollLeft".action = focus-column-left;
          "Mod+Shift+WheelScrollRight".action = move-column-right;
          "Mod+Shift+WheelScrollLeft".action = move-column-left;

          "Mod+Tab".action = focus-workspace-previous;

          "Mod+Comma".action = consume-or-expel-window-left;
          "Mod+Period".action = consume-or-expel-window-right;

          "Mod+W".action = switch-preset-column-width;
          "Mod+Shift+W".action = switch-preset-window-height;
          "Mod+Ctrl+W".action = reset-window-height;
          "Mod+Shift+F".action = maximize-column;
          # "Mod+Shift+F".action = fullscreen-window;
          "Mod+E".action = center-column;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+At".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+At".action = set-window-height "+10%";

          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;
          "Mod+Shift+Space".action = toggle-window-floating; # Sway compat

          # "Print".action = screenshot;
          "Ctrl+Print".action.screenshot-screen = [ ];
          # "Shift+Print".action = screenshot-window;

          "Mod+Shift+E".action = quit;
        }
        // (builtins.listToAttrs (
          builtins.concatMap (w: [
            {
              name = "Mod+${w.id}";
              value.action = focus-workspace w.name;
            }
            {
              name = "Mod+Shift+${w.id}";
              value.action = move-column-to-workspace w.name;
            }
          ]) config.mtn.workspaces
        ));
    };
  };
}

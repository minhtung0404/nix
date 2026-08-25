{
  flake.wrappers.niri =
    {
      config,
      lib,
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [
        wlib.wrapperModules.niri
      ];

      options = {
        enableLaptop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable laptop options";
        };

        wallpaper = lib.mkOption {
          type = lib.types.oneOf [
            lib.types.str
            lib.types.path
          ];
          description = "Path to the wallpaper file";
          default = "";
        };
      };

      config = {
        settings = {
          xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite}";
          environment = {
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            QT_IM_MODULE = "fcitx";
            XDG_MENU_PREFIX = "plasma-";
          };
          input = {
            keyboard = {
              xkb = {
                layout = "us";
              };
            };

            touchpad = lib.mkIf config.enableLaptop {
              tap = _: { };
              dwt = _: { };
              natural-scroll = _: { };
              middle-emulation = _: { };
            };

            mouse = {
              accel-profile = "flat";
            };
            warp-mouse-to-focus = _: { };
            focus-follows-mouse = _: {
              props = {
                max-scroll-amount = "0%";
              };
            };
          };

          spawn-at-startup = [
            "noctalia-shell"
            [
              "${lib.getExe pkgs.swaybg}"
              "-i"
              "${config.wallpaper}"
              "-m"
              "fill"
            ]
            [
              "dbus-update-activation-environment"
              "--systemd"
              "WAYLAND_DISPLAY"
              "DISPLAY"
              "XDG_CURRENT_DESKTOP"
              "XDG_SESSION_TYPE"
              "XDG_MENU_PREFIX"
              "PATH"
              "XDG_DATA_DIRS"
            ]
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
              active-gradient = _: {
                props = {
                  from = "#00447AFF";
                  to = "#71C4FFAA";
                  angle = 45;
                };
              };
              inactive-color = "#505050";
            };
            border.off = _: { };
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

          window-rules = [
            # Rounded Corners
            {
              geometry-corner-radius = [
                8.0
                8.0
                8.0
                8.0
              ];
              clip-to-geometry = true;
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
              focus-ring.off = _: { };
              opacity = 0.0;
              default-floating-position = _: {
                props = {
                  x = 0;
                  y = 0;
                  relative-to = "bottom-right";
                };
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
        };
      };
    };
}

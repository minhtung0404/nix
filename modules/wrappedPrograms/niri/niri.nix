{ self, ... }: {
  flake.wrappers.niri =
    {
      config,
      # osConfig,
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

        monitorOutputs = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Monitor arrangement";
        };

        monitors = lib.mkOption {
          type = lib.types.submodule {
            options = {
              main = lib.mkOption { type = lib.types.str; };
              secondary = lib.mkOption { type = lib.types.str; };
            };
          };
          default = {
            main = "DP-2";
            secondary = "eDP-1";
          };

        };

        terminal = lib.mkOption {
          type = lib.types.package;
          default = pkgs.kitty;
          description = "Terminal package";
        };

        noctalia = lib.mkOption {
          type = lib.types.package;
          default = pkgs.noctalia-shell;
          description = "Noctalia package";
        };
      };

      config =
        let
          noctaliaExe = lib.getExe config.noctalia;
        in
        {
          settings = {
            # xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite}";
            environment = {
              QT_QPA_PLATFORM = "wayland";
              QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
              QT_IM_MODULE = "fcitx";
            };
            # // lib.optionalAttrs osConfig.services.desktopManager.plasma6.enable {
            #   XDG_MENU_PREFIX = "plasma-";
            # };
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

            outputs = config.monitorOutputs;

            spawn-at-startup = [
              noctaliaExe
              [
                "${lib.getExe pkgs.swaybg}"
                "-i"
                "${config.wallpaper}"
                "-m"
                "fill"
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

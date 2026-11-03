{
  den.aspects.nixosMime.homeManager =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.mtn.linux.graphical;
      mkPackageWithDesktopOption =
        opts:
        lib.mkOption (
          {
            type = lib.types.submodule {
              options = {
                package = lib.mkOption {
                  type = lib.types.package;
                  description = "The package for " + opts.description;
                };
                desktopFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description =
                    "The desktop file name for " + opts.description + ", defaults to [packagename].desktop";
                };
              };
            };
          }
          // opts
        );
      desktopFileOf =
        cfg:
        # mimeapps.list wants a desktop file name (id), not a path
        if cfg.desktopFile == null then "${cfg.package.pname}.desktop" else cfg.desktopFile;

    in
    {
      options.mtn.linux.graphical = {
        defaults = {
          webBrowser = mkPackageWithDesktopOption { description = "default web browser"; };
          terminal = mkPackageWithDesktopOption {
            description = "default terminal";
            default.package = pkgs.kitty;
          };
          discord = mkPackageWithDesktopOption {
            description = "Discord client";
            default.package = pkgs.vesktop;
          };
        };
      };
      config = {
        # MIME set ups
        xdg.enable = true;
        xdg.mimeApps.enable = true;

        xdg.mimeApps.associations.added = {
          "text/plain" = [ "kakoune.desktop" ];

          # Other Thunderbird stuff
          "x-scheme-handler/tg2" = [ "org.telegram.desktop.desktop" ];
          "x-scheme-handler/tonsite2" = [ "org.telegram.desktop.desktop" ];

          # Other browser stuff
          "application/x-extension-htm" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-html" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-shtml" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/xhtml+xml" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-xhtml" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-xht" = [ (desktopFileOf cfg.defaults.webBrowser) ];
        };
        xdg.mimeApps.defaultApplications = {
          # Default web browser stuff
          "text/html" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/chrome" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/about" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/unknown" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/http" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/https" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/ftp" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/ftps" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "x-scheme-handler/file" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-htm" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-html" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-shtml" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/xhtml+xml" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-xhtml" = [ (desktopFileOf cfg.defaults.webBrowser) ];
          "application/x-extension-xht" = [ (desktopFileOf cfg.defaults.webBrowser) ];

          # Torrent
          "application/x-bittorrent" = [ "deluge.desktop" ];
          "x-scheme-handler/magnet" = [ "deluge.desktop" ];

          # Text
          "text/plain" = [ "kakoune.desktop" ];
          "application/pdf" = [ "okularApplication_pdf.desktop" ];

          # Files
          "inode/directory" = [ "org.kde.dolphin.desktop" ];

          # Telegram
          "x-scheme-handler/tg2" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite2" = "org.telegram.desktop.desktop";

          # Discord
          "x-scheme-handler/discord" = [ (desktopFileOf cfg.defaults.discord) ];
        };

        # Add one for kakoune
        xdg.desktopEntries."kakoune" = {
          name = "Kakoune";
          genericName = "Text Editor";
          exec = "${lib.getExe pkgs.kitty} --class kitty-float -o initial_window_width=150c -o initial_window_height=40c ${pkgs.writeShellScript "editor.sh" ''
            $EDITOR "$@"
          ''} %U";
          # exec = "kakoune %U";
          terminal = false;
          mimeType = [ "text/plain" ];
        };

      };
    };
}

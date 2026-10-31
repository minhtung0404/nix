{
  den,
  lib,
  ...
}:
let
  # desktop home on nixos hosts
  nixosDesktop = {
    includes = with den.aspects; [
      copyPaste
      nixosMime
      nixosStartup
      nixosGtk
      nixosQt
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          ## GUI stuff
          gparted
          deluge # Torrent client
          # Audio
          vlc

          onlyoffice-desktopeditors

          karere
          zoom-us

          ## CLI stuff
          dex # .desktop file management, startup
        ];
      };
  };

  # desktop home on darwin hosts
  macosDesktop = {
    includes = with den.aspects; [
      macosDefaults
      macosDock
      aerospace
      sketchybar
      hammerspoon
      macosDefaultApps
      lctl
    ];
  };
in
{
  # expansion of cli system for desktop use

  den.aspects.system-desktop = {
    includes = with den.aspects; [
      system-cli
      kanata

      scrollingDesktop
      displayManager
      battery
      ios
      graphics
      monitorBacklight
      bluetooth
      boot
      firmware
      sound
      kwallet
      virtualisation
      network
      udev
      zram
      appimage
      pam
      printing
      udisk2
      openssh
      portal
      xserver
      inputMethods
      dbus
      plasma
      kded6

      # desktop home: reaches the users that include den.batteries.host-aspects
      (
        { host, ... }:
        {
          includes =
            (with den.aspects; [
              zenBrowser
              kakoune
              vesktop
            ])
            ++ lib.optional (host.class == "nixos") nixosDesktop
            ++ lib.optional (host.class == "darwin") macosDesktop;

          homeManager =
            { pkgs, ... }:
            {
              home.packages = with pkgs; [
                obsidian
                telegram-desktop
              ];

              mtn.programs = {
                my-kakoune.enable-fish-session = true;
              };
            };
        }
      )
    ];

    nixos =
      { pkgs, ... }:
      {
        # Default packages
        environment.systemPackages = with pkgs; [
          ## Security stuff
          libsForQt5.qtkeychain

          ## Wayland
          kdePackages.qtwayland
          kdePackages.okular
          rtkit
          jetbrains.idea
        ];

        ## Environment
        environment.variables = {
          # Set default editor
          EDITOR = "kak";
          VISUAL = "kak";
        };

        # default settings
        # Set your time zone.
        time.timeZone = "Europe/Paris";

        security.polkit.enable = true;
      };

    darwin =
      {
        lib,
        pkgs,
        ...
      }:
      {
        services.tailscale.enable = true;

        system.activationScripts = {
          postActivation = {
            text = lib.mkOrder 1600 ''
              echo "-----------------------------------------------"
              echo "Permission required ..."
              echo "rclone: Please enable Full Disk Access for ${pkgs.rclone}/bin/rclone"
            '';
          };
        };
      };
  };
}

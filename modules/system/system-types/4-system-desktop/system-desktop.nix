{
  inputs,
  den,
  ...
}:
{
  # expansion of cli system for desktop use

  # den side of this tier; the flake.modules below move into it step by step
  den.aspects.system-desktop.includes = [
    den.aspects.system-cli
    den.aspects.kanata
  ];

  flake.modules.nixos.system-desktop = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      system-cli

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
      }
    ];
  };

  flake.modules.darwin.system-desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.darwin; [
        system-cli

      ];
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

  flake.modules.homeManager.system-desktop = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [
      system-cli

      zenBrowser
      kakoune
      vesktop
    ];

    home.packages = with pkgs; [
      obsidian
      telegram-desktop
    ];

    mtn.programs = {
      my-kakoune.enable-fish-session = true;
    };

  };

  flake.modules.homeManager.nixosDesktop =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        copyPaste
        nixosMime
        nixosStartup
        nixosGtk
        nixosQt
      ];

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
}

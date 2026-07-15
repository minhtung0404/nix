{
  inputs,
  ...
}:
{
  # expansion of cli system for desktop use

  flake.modules.nixos.system-desktop = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      system-cli

      scrollingDesktop
      displayManager
      kanata
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
      screencast
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
      {
        # Default packages
        environment.systemPackages = with pkgs; [
          ## Security stuff
          libsForQt5.qtkeychain

          ## Wayland
          kdePackages.qtwayland
          kdePackages.okular
          rtkit
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

      }
    ];
  };

  flake.modules.darwin.system-desktop = {
    imports = with inputs.self.modules.darwin; [
      system-cli
    ];
  };

  flake.modules.homeManager.system-desktop = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [
      system-cli

      zenBrowser
      kakoune
      vesktop
      kitty
      scrollingDesktop
      waybar
      graphical
    ];

    home.packages = with pkgs; [
      obsidian
      telegram-desktop
    ];

    mtn.programs = {
      my-kitty = {
        fontSize = 16;
        cmd = "cmd";
      };

      my-kakoune.enable-fish-session = true;
    };

  };
}

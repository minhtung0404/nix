{ pkgs, config, lib, ... }:

{
  users.users.minhtung0404 = {
    name = "minhtung0404";
    home = "/Users/minhtung0404/";
    shell =
      "${config.home-manager.users.minhtung0404.programs.fish.package}/bin/fish";
  };

  users.users.entertainment = {
    name = "entertainment";
    home = "/Users/entertainment/";
    shell =
      "${config.home-manager.users.entertainment.programs.fish.package}/bin/fish";
  };

  nix = {
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  homebrew = {
    enable = true;

    casks = [
      {
        name = "librewolf";
        greedy = true;
      }
      "scroll-reverser"
    ];
  };

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      FXPreferredViewStyle = "icnv";
      FXEnableExtensionChangeWarning = false;
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Home";
      ShowExternalHardDrivesOnDesktop = false;
      ShowPathbar = true;
      ShowRemovableMediaOnDesktop = false;
      ShowStatusBar = true;
    };
    loginwindow.GuestEnabled = false;
    screencapture.location = "~/Documents/screenshot/";

    # Dock
    dock = {
      autohide = true;
      launchanim = false;
      largesize = 128;
      tilesize = 81;
      magnification = true;
      mru-spaces = false;
      persistent-apps = [
        "/System/Volumes/Data/Applications/LibreWolf.app/"
        "/System/Applications/Mail.app"
        "/System/Volumes/Data/Applications/VeraCrypt.app/"
        "${pkgs.obsidian}/Applications/Obsidian.app/"
      ];
      # persistent-others = [
      #   "/Users/${config.minhtung0404.username}/"
      #   "/Users/${config.minhtung0404.username}/Downloads"
      # ];
      # wvous-br-corner = 4;
    };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      _HIHideMenuBar = true;
    };
    # universalaccess.reduceMotion = true;

    spaces.spans-displays = false;
  };

  nixpkgs.flake.setNixPath = true;

  imports = [
    ../modules/keyboards/kanata/darwin.nix
    ../modules/network/edns
    # ../modules/misc/sops
  ];
  mtn = {
    services = {
      my-kanata = {
        enable = true;
        configFile = [ "apple" "gm610" ];
      };

      edns = {
        enable = true;
        ipv6 = true;
      };
    };
  };

  launchd.daemons.dnscrypt-proxy.serviceConfig.UserName = lib.mkForce "root";

  # sops.defaultSopsFile = ../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";

  # sops.age.keyFile = "/Users/minhtung0404/.config/sops/age/keys.txt";
  # sops.secrets.veracrypt_drive = {
  #   owner = config.users.users.minhtung0404.name;
  # };

  system.stateVersion = 6;
}

{ pkgs, config, ... }:

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

    casks = [{
      name = "librewolf";
      greedy = true;
    }];
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

  imports = [ ../modules/gui/aerospace ../modules/keyboards/kanata/darwin.nix ];

  system.stateVersion = 6;
}

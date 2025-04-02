{ inputs, outputs, pkgs, lib, ... }:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.users.minhtung0404 = import ./minhtung0404.nix;
      home-manager.users.entertainment = import ./entertainment.nix;
      home-manager.sharedModules = [
        outputs.homeManagerModules.default
        ({ ... }: { home.packages = with pkgs; [ home-manager ]; })
      ];
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = "minhtung0404";
        autoMigrate = true;
      };
    }
  ];
  users.users.minhtung0404 = {
    name = "minhtung0404";
    home = "/Users/minhtung0404/";
    shell = "${pkgs.fish}/bin/fish";
  };

  users.users.entertainment = {
    name = "entertainment";
    home = "/Users/entertainment/";
    shell = "${pkgs.fish}/bin/fish";
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

    brews = [ "mas" ];

    casks = [
      {
        name = "librewolf";
        greedy = true;
      }
      "scroll-reverser"
      "hammerspoon"
    ];

    masApps = {
      "Messenger" = 1480068668;
      "Bitwarden" = 1352778147;
    };

    onActivation.cleanup = "zap";
  };

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      FXPreferredViewStyle = "clmv";
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
    };

    hitoolbox.AppleFnUsageType = "Change Input Source";

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

  mtn = {
    services = {
      my-kanata = {
        enable = true;
        configFile = [ "gm610" "apple" ];
      };

      edns = {
        enable = true;
        ipv6 = true;
      };
    };
  };

  launchd.daemons.dnscrypt-proxy.serviceConfig.UserName = lib.mkForce "root";

  system.stateVersion = 6;
}

{
  inputs,
  outputs,
  pkgs,
  lib,
  myLib,
  overlays,
  config,
  ...
}:
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
        (
          { ... }:
          {
            home.packages = with pkgs; [ home-manager ];
          }
        )
      ];
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          outputs
          myLib
          overlays
          ;
      };
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
    inputs.sops-nix.darwinModules.sops
  ];

  programs.fish = {
    enable = true;
    vendor.completions.enable = true;
  };

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
  nixpkgs.flake.setNixPath = true;

  homebrew = {
    enable = true;

    brews = [ "mas" ];

    casks = [
      "scroll-reverser"
      "hammerspoon"
    ];

    masApps = {
      "Messenger" = 1480068668;
      "Bitwarden" = 1352778147;
    };

    onActivation.cleanup = "zap";
  };

  system.primaryUser = "minhtung0404";
  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "clmv";
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Home";
      QuitMenuItem = true;
      ShowExternalHardDrivesOnDesktop = false;
      ShowPathbar = true;
      ShowRemovableMediaOnDesktop = false;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
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
      show-recents = false;
      persistent-apps = [
        "${pkgs.librewolf}/Applications/LibreWolf.app/"
        "/System/Applications/Mail.app"
        "/System/Volumes/Data/Applications/VeraCrypt.app/"
        "${pkgs.obsidian}/Applications/Obsidian.app/"
      ];
    };

    hitoolbox.AppleFnUsageType = "Change Input Source";

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "Automatic";
      NSAutomaticWindowAnimationsEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      _HIHideMenuBar = true;
    };
    # universalaccess.reduceMotion = true;

    spaces.spans-displays = false;
  };

  mtn = {
    services = {
      my-kanata = {
        enable = true;
        configFile = [
          "gm610"
          "apple"
        ];
      };

      edns = {
        enable = true;
        ipv6 = true;
      };
    };
  };

  home-manager.users.minhtung0404.programs.fish.functions = {
    drive_mount = {
      body = ''
        /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --mount /Users/minhtung0404/Library/CloudStorage/GoogleDrive-minhtung04042001@gmail.com/My\ Drive/encrypted/drive_encrypted /Volumes/DRIVE --password $(cat ${config.sops.secrets.veracrypt_drive.path}) --pim 0 --keyfiles "" --protect-hidden no --slot 1 --verbose
      '';
    };

    drive_dismount = {
      body = ''
        /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --dismount /Users/minhtung0404Library/CloudStorage/GoogleDrive-minhtung04042001@gmail.com/My\ Drive/encrypted/drive_encrypted /Volumes/DRIVE
      '';
    };
  };

  mtn.programs.sops = {
    enable = true;
    file = ./secrets.yaml;
  };

  environment.variables = {
    SOPS_AGE_KEY_FILE = "/Users/minhtung0404/.config/sops/age/keys.txt";
  };

  sops.secrets.veracrypt_drive = {
    owner = config.users.users.minhtung0404.name;
  };

  launchd.daemons.dnscrypt-proxy.serviceConfig.UserName = lib.mkForce "root";

  system.activationScripts = {
    postActivation = {
      text = lib.mkOrder 1600 ''
        echo "Permission required ..."
        echo "kanata: Please enable Input Mornitoring/Full Disk Access for ${config.mtn.services.my-kanata.package}/bin/kanata"
      '';
    };
  };

  system.stateVersion = 6;
}

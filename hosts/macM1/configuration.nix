{
  self,
  inputs,
  outputs,
  pkgs,
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
          self
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

  system.primaryUser = "minhtung0404";
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

  system.stateVersion = 6;
}

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
    {
      home-manager.users.minhtung0404 = import ./minhtung0404.nix;
      home-manager.users.entertainment = import ./entertainment.nix;
    }
    {
      nix-homebrew.user = "minhtung0404";
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

  system.primaryUser = "minhtung0404";
  mtn = {
    services = {
      my-kanata = {
        enable = true;
        configFile = [
          "apple"
          "gm610"
        ];
      };

      edns = {
        enable = true;
        ipv6 = true;
      };
    };
  };

  home-manager.users.minhtung0404.programs.fish = {
    functions = {
      veramount = {
        body = ''
          function __help
            echo "Usage: veramount [OPTIONS] NAME"
            echo
            echo "Positional arguments:"
            echo "  NAME          Required. The name of the disk to mount"
            echo
            echo "Options"
            echo "  -u, --dismount Unmount the disk"
            echo "  -m, --mount    Mount the disk"
          end

          argparse -n=veramount -x dismount,mount -N 1 'd/dismount' 'm/mount' 'h/help' -- $argv
          or return 1

          if set -q _flag_help
            __help
            return 0
          end

          if test (count $argv) -lt 1
            __help
            return 1
          end

          set disk $argv[1]

          switch $disk
            case "drive"
              set src /Users/minhtung0404/Library/CloudStorage/GoogleDrive-minhtung04042001@gmail.com/My\ Drive/encrypted/drive_encrypted
              set dst /Volumes/DRIVE
              set pwd ${config.sops.secrets."veracrypt/drive".path}
              set slt 1
            case "common"
              set src /Volumes/Common/common
              set dst /Volumes/SHARED
              set pwd ${config.sops.secrets."veracrypt/common".path}
              set slt 2
            case "*"
              __help
              return 1
          end

          if set -q _flag_dismount
            /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --dismount $src
          else
            /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --mount $src $dst --password (cat $pwd) --pim 0 --keyfiles "" --protect-hidden no --slot $slt --verbose
          end
        '';
      };
    };

    shellInit = ''
      complete -c veramount -l mount -s m -d "Mount the disk"
      complete -c veramount -l dismount -s d -d "Dismount the disk"
      complete -c veramount -f -a "drive common" -d "Disk to mount"
    '';
  };

  mtn.programs.sops = {
    enable = true;
    file = ./secrets.yaml;
  };

  environment.variables = {
    SOPS_AGE_KEY_FILE = "/Users/minhtung0404/.config/sops/age/keys.txt";
  };

  sops.secrets."veracrypt/drive" = {
    owner = config.users.users.minhtung0404.name;
  };

  sops.secrets."veracrypt/common" = {
    owner = config.users.users.minhtung0404.name;
  };

  system.stateVersion = 6;
}

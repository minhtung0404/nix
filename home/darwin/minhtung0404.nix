{ config, inputs, pkgs, ... }:
let user = "minhtung0404";
in {
  minhtung0404.username = user;

  imports = [
    # inputs.sops-nix.homeManagerModules.sops
    ../shared/common.nix
    ./common.nix
  ];

  home.packages = with pkgs; [ texlive.combined.scheme-full sops ];

  minhtung0404.services.sketchybar = {
    enable = true;
    extraPackages = [
      pkgs.lua5_4_compat
      pkgs.aerospace
      pkgs.nowplaying-cli
      pkgs.sketchybar-app-font
    ];
  };

  programs.fish.functions = {
    drive_mount = {
      body = ''
        /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --mount /Users/minhtung0404/Library/CloudStorage/GoogleDrive-minhtung04042001@gmail.com/My\ Drive/encrypted/drive_encrypted /Volumes/DRIVE --password $(cat /run/secrets/veracrypt_drive) --pim 0 --keyfiles "" --protect-hidden no --slot 1 --verbose
      '';
    };

    drive_dismount = {
      body = ''
        /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --dismount /Users/minhtung0404/Library/CloudStorage/GoogleDrive-minhtung04042001@gmail.com/My\ Drive/encrypted/drive_encrypted /Volumes/DRIVE
      '';
    };
  };

  # sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";

  # sops.age.keyFile = "/Users/${user}/.config/sops/age/keys.txt";
  # sops.secrets.veracrypt_drive = {
  #   mode = "0440";
  #   owner = user;
  # };
}

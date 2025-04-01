{ config, nixvim-conf, pkgs, ... }:
let
  user = "minhtung0404";
  home = "/Users/${user}/";
in {

  imports = [ ./common.nix ];

  mtn = {
    hm = {
      enable = true;
      darwin = true;
    };

    username = user;
  };

  home.packages = with pkgs; [ texlive.combined.scheme-full sops ];

  programs.fish.functions = {
    drive_mount = {
      body = ''
        /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --mount ${home}/Library/CloudStorage/GoogleDrive-minhtung04042001@gmail.com/My\ Drive/encrypted/drive_encrypted /Volumes/DRIVE --password $(cat ${config.sops.secrets.veracrypt_drive.path}) --pim 0 --keyfiles "" --protect-hidden no --slot 1 --verbose
      '';
    };

    drive_dismount = {
      body = ''
        /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt --text --dismount ${home}/Library/CloudStorage/GoogleDrive-minhtung04042001@gmail.com/My\ Drive/encrypted/drive_encrypted /Volumes/DRIVE
      '';
    };
  };

  sops = {
    age.keyFile = "${home}/.config/sops/age/keys.txt";

    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets.veracrypt_drive = {
      mode = "0440";
      # path = "${config.sops.defaultSymlinkPath}/veracrypt_drive";
    };
  };

}

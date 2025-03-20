{ config, pkgs, lib, ... }:
with lib;

let
  appleConfigFile = pkgs.writeTextFile {
    name = "kanata_apple.kbd";
    text = pkgs.lib.strings.concatStrings [
      (builtins.readFile ./default_configs/apple.kbd)
      (builtins.readFile ./default_configs/common.kbd)
    ];
  };
  gm610ConfigFile = pkgs.writeTextFile {
    name = "kanata_gm610.kbd";
    text = pkgs.lib.strings.concatStrings [
      (builtins.readFile ./default_configs/gm610.kbd)
      (builtins.readFile ./default_configs/common.kbd)
    ];
  };
in {
  imports = [ ./darwin_common.nix ];
  config.minhtung0404.services.kanata = {
    enable = true;
    configFile = [ appleConfigFile gm610ConfigFile ];
  };
}

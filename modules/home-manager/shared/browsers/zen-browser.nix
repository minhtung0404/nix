{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mtn.programs.my-zenbrowser;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  options.mtn.programs.my-zenbrowser = {
    enable = mkEnableOption "Zen browser";
    entertainment = mkEnableOption "Entertainment";
  };
  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
    }
    // (import ./firefox-fork.nix {
      inherit pkgs;
      cfg = cfg;
    });
  };
}

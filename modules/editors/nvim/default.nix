{ config, lib, ... }:
let cfg = config.mtn.programs.my-nvim;
in {
  options.mtn.programs.my-nvim = {
    enable = lib.mkEnableOption "my-lazyvim";

    nixvim = lib.mkEnableOption "my-nixvim";
  };
  config = {
    xdg.configFile.nvim = lib.mkIf cfg.enable {
      source = ./config;
      recursive = true;
    };
  };
}

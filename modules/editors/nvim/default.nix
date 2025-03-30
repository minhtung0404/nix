{ config, lib, ... }:
let cfg = config.mtn.programs.my-nvim;
in {
  options.mtn.programs.my-nvim = { enable = lib.mkEnableOption "my-nvim"; };
  config = lib.mkIf cfg.enable {
    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };
  };
}

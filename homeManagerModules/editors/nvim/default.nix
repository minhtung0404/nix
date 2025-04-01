{ config, lib, ... }:
let cfg = config.mtn.programs.my-nvim;
in {
  options.mtn.programs.my-nvim = {
    enable = lib.mkEnableOption "my-lazyvim";

    nixvim = lib.mkEnableOption "my-nixvim";
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.neovim.enable = true;
      xdg.configFile.nvim = {
        source = ./config;
        recursive = true;
      };
    })
    (lib.mkIf cfg.nixvim {

    })
  ];
}

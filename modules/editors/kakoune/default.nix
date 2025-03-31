{ config, lib, ... }:
let cfg = config.mtn.programs.my-kakoune;
in {
  options.mtn.programs.my-kakoune = { enable = lib.mkEnableOption "kakoune"; };
  config = lib.mkIf cfg.enable {
    programs.kakoune = {
      enable = true;

    };
  };
}

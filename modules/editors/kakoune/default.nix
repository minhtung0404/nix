{ config, lib, ... }:
let cfg = config.mtn.programs.my-kakoune;
in {
  # imports = [ ./kak-lsp.nix ./tree-sitter.nix ];
  options.mtn.programs.my-kakoune = { enable = lib.mkEnableOption "kakoune"; };
  config = lib.mkIf cfg.enable {
    programs.kakoune = {
      enable = true;

      config = {
        indentWidth = 2;
        ui = { assistant = "cat"; };
      };
    };
  };
}

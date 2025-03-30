{ pkgs, config, lib, ... }:
let
  cfg = config.mtn.programs.my-kitty;
  cmd = "cmd";
in with lib; {
  programs.kitty = mkIf (cfg.enable && pkgs.stdenv.isDarwin) {

    # Darwin-specific setup
    darwinLaunchOptions =
      [ "--single-instance" "-o allow_remote_control=socket" ];

    # Tabs and layouts keybindings
    keybindings = {
      # Backslash
      "0x5d" = "send_text all \\u005c";
    };

    settings = {
      # MacOS specific
      macos_option_as_alt = "left";
    };
  };
}


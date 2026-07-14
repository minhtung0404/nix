{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    ;
  cfg = config.mtn.services.my-sketchybar;
  username = config.mtn.username;

in
{
  options.mtn.services.my-sketchybar = {
    enable = mkEnableOption "my-sketchybar";

    package = mkPackageOption pkgs "sketchybar" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [
        pkgs.lua5_4_compat
        pkgs.aerospace
        pkgs.nowplaying-cli
        pkgs.sketchybar-app-font
      ];
      example = literalExpression "[ pkgs.jq ]";
      description = ''
        Extra packages to add to PATH.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.sketchybar = {
      enable = true;
      config = ''
        FONT="FiraCode Nerd Font:Bold:14.0"

        # ---------------------------------------------------------
        # Bar appearance
        # ---------------------------------------------------------
        sketchybar --bar height=24 \
                   color=0x00000000 \
                   position=top
        # ---------------------------------------------------------
        # LEFT: Spaces inside a rounded box
        # ---------------------------------------------------------
        ${import ./items/spaces.nix {
          inherit pkgs;
          spaces = config.mtn.workspaces;
        }}

        # ---------------------------------------------------------
        # CENTER: Clock
        # ---------------------------------------------------------
        ${import ./items/clock.nix { inherit pkgs; }}

        # ---------------------------------------------------------
        # RIGHT: Volume + Battery
        # ---------------------------------------------------------

        ${import ./items/battery.nix { inherit pkgs; }}
        ${import ./items/volume.nix { inherit pkgs; }}

        # ---------------------------------------------------------
        # Done
        # ---------------------------------------------------------
        sketchybar --update
        sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
        echo "✅ Sketchybar config loaded"
      '';
      extraPackages = cfg.extraPackages;
      package = cfg.package;
      service = {
        enable = true;
        outLogFile = "/tmp/${username}/sbar.out.log";
        errorLogFile = "/tmp/${username}/sbar.err.log";
      };
    };
  };
}
